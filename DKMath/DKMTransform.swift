//
//  DKMTransform.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import simd

public class DKMTransform {
	public var position: float3
	public var rotation: float3
	public var scale: float2
	
	public var matrix4x4: float4x4 {
		get {
			let m = newTranslation(position) *
					newRotationX(rotation.x) *
					newRotationY(rotation.y) *
					newRotationZ(rotation.z) *
					newScale(scale.x, y: scale.y, z: 1.0)
			
			return m
		}
	}
	
	public init() {
		self.position = float3(0.0)
		self.rotation = float3(0.0)
		self.scale = float2(1.0)
	}
}