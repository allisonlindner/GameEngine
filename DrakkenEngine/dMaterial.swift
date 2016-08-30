//
//  dMaterial.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 23/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation

public class dMaterialDef {
	internal var name: String
	internal var shader: String
	fileprivate var buffers: [String : dBufferable] = [:]
	fileprivate var textures: [String : dMaterialTexture] = [:]
	
	public init(name: String, shader: String) {
		self.name = name
		self.shader = shader
	}
	
	internal func set(buffer name: String, _ data: dBufferable) {
		self.buffers[name] = data
	}
	
	internal func set(texture name: String, _ data: dTexture, _ index: Int) {
		let materialTexture = dMaterialTexture(texture: data, index: index)
		self.textures[name] = materialTexture
	}
}

internal class dMaterial {
	private var _materialDef: dMaterialDef
	
	internal init(materialDef: dMaterialDef) {
		self._materialDef = materialDef
	}
	
	internal func build() {
		var buffers: [dBufferable] = []
		for buffer in _materialDef.buffers {
			buffers.append(buffer.value)
		}
		
		var textures: [dMaterialTexture] = []
		for materialTexture in _materialDef.textures {
			textures.append(materialTexture.value)
		}
		
		dCore.instance.mtManager.create(name: _materialDef.name,
		                                shader: _materialDef.shader,
		                                buffers: buffers,
		                                textures: textures)
	}
}
