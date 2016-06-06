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
	
	public init(position: (x: Float, y: Float, z: Float),
	            rotation: (x: Float, y: Float, z: Float),
	            scale: (x: Float, y: Float)) {
		self.position = float3(position.x, position.y, position.z)
		self.rotation = float3(rotation.x, rotation.y, rotation.z)
		self.scale = float2(scale.x, scale.y)
	}
	
	public convenience init(positionX x: Float, y: Float, z: Float) {
		self.init(position: (x, y, z),
		          rotation: (0.0, 0.0, 0.0),
		          scale: (1.0, 1.0))
	}
	
	public convenience init(rotationX x: Float, y: Float, z: Float) {
		self.init(position: (0.0, 0.0, 0.0),
		          rotation: (x, y, z),
		          scale: (1.0, 1.0))
	}
	
	public convenience init(scaleX x: Float, y: Float) {
		self.init(position: (0.0, 0.0, 0.0),
		          rotation: (0.0, 0.0, 0.0),
		          scale: (x, y))
	}
	
	public convenience init() {
		self.init(position: (0.0, 0.0, 0.0),
		          rotation: (0.0, 0.0, 0.0),
		          scale: (1.0, 1.0))
	}
}