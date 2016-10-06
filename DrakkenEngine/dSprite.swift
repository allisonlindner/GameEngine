//
//  dSprite.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 25/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//


public class dSpriteDef {
	public var name: String
	public var texture: dTexture
	
	public var columns: Int = 1
	public var lines: Int = 1
	
	internal var animations: [String : dAnimation] = [:]
	
	public func add(animation data: dAnimation) {
		self.animations[data.name] = data
	}
	
    public init(_ name: String, columns: Int = 1, lines: Int = 1, texture: dTexture) {
		self.name = name
		self.texture = texture
		
		self.columns = columns
		self.lines = lines
	}
    
    public convenience init(_ name: String, columns: Int = 1, lines: Int = 1, texture: String) {
        let t = dTexture(texture)
        
        self.init(name, columns: columns, lines: lines, texture: t)
    }
}

public class dSprite : dComponent {
	internal var spriteName: String
	internal var meshRender: dMeshRender
	internal var animator: dAnimator?
	
	internal var animations: [String : dAnimation] {
		get {
			return dCore.instance.spManager.get(sprite: self.spriteName)!.animations
		}
	}
	
	internal var frame: Int32
	
	public init(sprite name: String, frame: Int32 = 0) {
		self.spriteName = name
		self.frame = frame
		
		self.meshRender = dMeshRender()
		self.meshRender.material = "\(name)_spritematerial"
		self.meshRender.mesh = "\(name)_spritemesh"
		
		super.init()
		
		_ = self.add(dependence: meshRender)
		
		if animations.count > 0 {
			self.animator = dAnimator(sprite: self, defaultAnimation: animations.first!.key)
			_ = self.add(dependence: animator!)
		}
	}
	
	public func play(animation name: String) {
		if animator != nil {
			animator!.set(animation: name)
			animator!.play()
		}
	}
	
	public func stop() {
		if animator != nil {
			animator!.stop()
		}
	}
	
	public func set(frame: Int32) {
		self.frame = frame
	}
	
	public func set(texture: dTexture) {
		dCore.instance.spManager.get(sprite: spriteName)!.set(texture: texture)
	}
}
