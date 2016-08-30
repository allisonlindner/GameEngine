//
//  SharedUniforms.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 23/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import simd

public struct dLight {
	var color: float3
	var intensity: Float
}

public struct dCameraUniform {
	var viewMatrix: float4x4
	var projectionMatrix: float4x4
}
