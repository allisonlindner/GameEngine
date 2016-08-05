//
//  DKRDiffuseMaterial.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 23/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import simd

public struct DKRSpriteUniform {
	var light: DKLight
}

public class DKRSpriteMaterial: DKRMaterial, DKRMaterialDataSource {
	private var _uDiffuse: DKRSpriteUniform
	private var _uDiffuseBuffer: DKRBuffer<DKRSpriteUniform>
	
	public init(
		lightColor: (r: Float, g: Float, b: Float) = (1.0, 1.0, 1.0),
		intensity: Float = 1.0
	) {
		_uDiffuse = DKRSpriteUniform(light: DKLight(
												color: float3(lightColor.r, lightColor.g, lightColor.b),
												intensity: intensity)
											)
		_uDiffuseBuffer = DKRBuffer(
								data: _uDiffuse,
								index: 0,
								bufferType: DKRBufferType.fragment,
								staticMode: true,
								offset: 0
							)
		
		super.init(shaderName: "sprite")
		
		self.dataSource = self
	}
	
	public func uniformBuffers() -> [DKBuffer] {
		return [_uDiffuseBuffer]
	}
	
	public func setTexture(_ name: String) {
		super.setTexture(name, index: 0)
	}
}
