//
//  dSpriteManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 02/09/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import simd

internal class dSpriteData {
	internal var name: String
	internal var texture: dTexture
	
	internal var columns: Int = 1
	internal var lines: Int = 1
	internal var animations: [String : dAnimation] = [:]
	
	private var materialDef: dMaterialDef
	private var meshDef: dMeshDef
	
	
	internal init(name: String, columns: Int = 1, lines: Int = 1, texture: dTexture, animations: [String : dAnimation]) {
		self.name = name
		self.texture = texture
		
		self.columns = columns
		self.lines = lines
		
		self.animations = animations
		
		let materialName = "\(name)_spritematerial"
		self.materialDef = dDiffuseDef(name: materialName)
		(materialDef as! dDiffuseDef).set(albedo: texture)
		
		let meshName = "\(name)_spritemesh"
		self.meshDef = dSpriteQuad(name: meshName)
		
		self.set(columns: self.columns, lines: self.lines)
		
		DrakkenEngine.Register(material: self.materialDef)
		DrakkenEngine.Register(mesh: self.meshDef)
	}
	
	internal func set(texture: dTexture) {
		(materialDef as! dDiffuseDef).set(albedo: texture)
		self.set(columns: self.columns, lines: self.lines)
	}
	
	public func set(columns: Int, lines: Int) {
		self.columns = columns
		self.lines = lines
		
		let tW: Float = Float(texture.getTexture().width)
		let tH: Float = Float(texture.getTexture().height)
		
		let sW: Float = tW / Float(self.columns)
		let sH: Float = tH / Float(self.lines)
		
		var texCoords: [float2] = []
		
		for l in 0..<lines {
			let _l = Float(l)
			for c in 0..<columns {
				let _c = Float(c)
				texCoords.append(float2( (_c * sW) / tW			 , ((_l + 1.0) * sH) / tH	))
				texCoords.append(float2( (_c * sW) / tW			 , (_l * sH) / tH			))
				texCoords.append(float2( ((_c + 1.0) * sW) / tW	 , (_l * sH) / tH			))
				texCoords.append(float2( ((_c + 1.0) * sW) / tW	 , ((_l + 1.0) * sH) / tH	))
			}
		}
		
		(self.meshDef as! dSpriteQuad).set(texCoords: texCoords)
	}
}

internal class dSpriteManager {
	private var sprites: [String : dSpriteData] = [:]
	
	internal func create(sprite def: dSpriteDef) -> dSpriteData {
		let sprite = dSpriteData(name: def.name,
		                         columns: def.columns,
		                         lines: def.lines,
		                         texture: def.texture,
		                         animations: def.animations)
		self.sprites.updateValue(sprite, forKey: def.name)
		
		return sprite
	}
	
	internal func get(sprite name: String) -> dSpriteData? {
		return sprites[name]
	}
}
