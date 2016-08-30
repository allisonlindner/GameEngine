//
//  dMaterialManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 23/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//


internal class dMaterialTexture {
	internal var texture: dTexture
	internal var index: Int
	
	internal init(texture: dTexture, index: Int) {
		self.texture = texture
		self.index = index
	}
}

internal class dMaterialData {
	internal var shader: dShader
	internal var buffers: [dBufferable] = []
	internal var textures: [dMaterialTexture] = []
	
	internal init(shader: dShader) {
		self.shader = shader
	}
}

internal class dMaterialManager {
	private var _materials: [String : dMaterialData] = [:]
	
	internal func create(name:		String,
	                     shader:	String,
	                     buffers:	[dBufferable],
	                     textures:	[dMaterialTexture]) {
		
		let instancedShader = dCore.instance.shManager.get(shader: shader)
		
		let materialData = dMaterialData(shader: instancedShader)
		materialData.buffers = buffers
		materialData.textures = textures
		
		self._materials[name] = materialData
	}
	
	internal func get(material name: String) -> dMaterialData? {
		return self._materials[name]
	}
}
