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

public class DKRSpriteMaterial: DKRMateriable {
	public var shader: DKRShader!
	public var drawables: [String : DKRDrawableInstance]
	public var textureInstances: [DKRTextureInstance]
	
	private var _uDiffuse: DKRSpriteUniform
	private var _uDiffuseBuffer: DKRBuffer<DKRSpriteUniform>
	
	public init(
		lightColor: (r: Float, g: Float, b: Float) = (1.0, 1.0, 1.0),
		intensity: Float = 1.0
	) {
		do {
			shader = try DKRShader(name: "sprite")
		} catch let error as DKShaderNotFoundError {
			assert(false, error.description)
		} catch {
			assert(false, "Error on shader creation: diffuse")
		}
		
		drawables = [:]
		textureInstances = []
		
		_uDiffuse = DKRSpriteUniform(light: DKLight(
												color: float3(lightColor.r, lightColor.g, lightColor.b),
												intensity: intensity)
											)
		_uDiffuseBuffer = DKRBuffer(
								data: _uDiffuse,
								index: 0,
								bufferType: DKRBufferType.Fragment,
								staticMode: true,
								offset: 0
							)
	}
	
	public func getUniformBuffers() -> [DKBuffer] {
		return [_uDiffuseBuffer]
	}
}