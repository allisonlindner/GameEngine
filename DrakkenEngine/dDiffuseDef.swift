//
//  dSpriteDef.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 23/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import simd

public class dDiffuseDef: dMaterialDef {
	public init(name: String) {
		super.init(name: name, shader: "diffuse")
		
		self.set(light: dLight(color: float3(1.0, 1.0, 1.0), intensity: 1.0))
	}
	
	public func set(albedo texture: dTexture) {
		self.set(texture: "albedo", texture, 0)
	}
	
	public func set(light: dLight) {
		let buffer = dBuffer(data: light, index: 0, preAllocateSize: 1, bufferType: .fragment)
		self.set(buffer: "uLight", buffer)
	}
}
