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
	
	public init(name: String, columns: Int = 1, lines: Int = 1, texture: dTexture) {
		self.name = name
		self.texture = texture
		
		self.columns = columns
		self.lines = lines
	}
}

public class dSprite : dComponent {
	internal var spriteName: String
	internal var meshRender: dMeshRender
	
	internal var frame: Int32
	
	public init(sprite name: String, frame: Int32 = 0) {
		self.spriteName = name
		self.frame = frame
		
		self.meshRender = dMeshRender()
		self.meshRender.material = "\(name)_spritematerial"
		self.meshRender.mesh = "\(name)_spritemesh"
		
		super.init()
		
		_ = self.add(dependence: meshRender)
	}
	
	public func set(frame: Int32) {
		self.frame = frame
	}
	
	public func set(texture: dTexture) {
		dCore.instance.spManager.get(sprite: spriteName)!.set(texture: texture)
	}
}
