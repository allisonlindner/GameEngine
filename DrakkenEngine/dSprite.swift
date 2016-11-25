//
//  dSprite.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 25/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import simd

public class dSpriteDef {
	public var name: String
	public var texture: dTexture
	
	public var columns: Int = 1
	public var lines: Int = 1
	
    public var scale: dSize2D = dSize2D(1, 1)
    
	internal var animations: [String : dAnimation] = [:]
	
	public func add(animation data: dAnimation) {
		self.animations[data.name] = data
	}
	
    public init(_ name: String, columns: Int = 1, lines: Int = 1, texture: dTexture) {
		self.name = name
		self.texture = texture
		
		self.columns = columns
		self.lines = lines
        
        self.scale.Set(Float(texture.getTexture().width), Float(texture.getTexture().height))
	}
    
    public convenience init(_ name: String, columns: Int = 1, lines: Int = 1, texture: String) {
        let t = dTexture(texture)
        
        self.init(name, columns: columns, lines: lines, texture: t)
    }
    
    public convenience init(json: JSON) {
        let _name = json["name"].stringValue
        let _columns = json["columns"].intValue
        let _lines = json["lines"].intValue
        let _texture = json["texture"].stringValue
        
        self.init(_name, columns: _columns, lines: _lines, texture: _texture)
        
        let _scaleJson = json["scale"].dictionaryValue
        
        let _scaleW = _scaleJson["w"]!.floatValue
        let _scaleH = _scaleJson["h"]!.floatValue
        
        self.scale = dSize2D(_scaleW, _scaleH)
    }
    
    public convenience init(json url: URL) {
        var fileString: String = ""
        var json: JSON!
        
        do {
            fileString = try String(contentsOf: url)
            
            if let dataFromString = fileString.data(using: String.Encoding.utf8) {
                json = JSON(data: dataFromString)
            } else {
                fatalError("Sprite def load file error")
            }
        } catch {
            NSLog("Sprite def load file error")
        }
        
        self.init(json: json)
    }
    
    internal func toDict() -> [String: JSON] {
        var dict = [String: JSON]()
        
        dict["name"] = JSON(name)
        dict["columns"] = JSON(columns)
        dict["lines"] = JSON(lines)
        dict["texture"] = JSON(texture.name)
        
        var scaleDict = [String: JSON]()
        scaleDict["w"] = JSON(scale.width)
        scaleDict["h"] = JSON(scale.height)
        
        dict["scale"] = JSON(scaleDict)
        
        return dict
    }
    
    internal func toData() -> Data? {
        let json = JSON(self.toDict())
        
        do {
            let data = try json.rawData(options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = String(data: data, encoding: String.Encoding.utf8)
            NSLog(string!)
            
            return data
        } catch let error {
            NSLog("JSON conversion FAIL!! \(error)")
        }
        
        return nil
    }
}

public class dSprite : dComponent {
	internal var spriteName: String
	internal var meshRender: dMeshRender
	internal var animator: dAnimator?
	
	internal var animations: [String : dAnimation] {
		get {
            if dCore.instance.spManager.get(sprite: self.spriteName) != nil {
                return dCore.instance.spManager.get(sprite: self.spriteName)!.animations
            } else {
                return [:]
            }
		}
	}
	
	internal var frame: Int32
	
    public init(sprite name: String, scale: dSize2D, frame: Int32 = 0) {
		self.spriteName = name
		self.frame = frame
		
		self.meshRender = dMeshRender()
		self.meshRender.material = "\(name)_spritematerial"
		self.meshRender.mesh = "\(name)_spritemesh"
        self.meshRender.scale = scale
		
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
    
    internal override func toDict() -> [String: JSON] {
        var dict = [String: JSON]()
        
        dict["type"] = JSON("SPRITE")
        dict["name"] = JSON(self.spriteName)
        dict["frame"] = JSON(Int(self.frame))
        
        var scaleDict = [String: JSON]()
        
        scaleDict["w"] = JSON(self.meshRender.scale.width)
        scaleDict["h"] = JSON(self.meshRender.scale.height)
        
        dict["scale"] = JSON(scaleDict)
        
        return dict
    }
}
