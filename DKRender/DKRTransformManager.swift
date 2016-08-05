//
//  DKRTransformManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 10/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import simd

internal class DKRTransformData {
	internal var position: float3
	internal var rotation: float3
	internal var scale: float2
	
	internal var _matrix: float4x4!
	internal var matrix4x4: float4x4! {
		get {
			self._updateMatrix()
			return self._matrix
		}
	}
	
	internal init(position: (x: Float, y: Float, z: Float),
	              rotation: (x: Float, y: Float, z: Float),
					 scale: (x: Float, y: Float)) {
		
		self.position = float3(position.x, position.y, position.z)
		self.rotation = float3(rotation.x, rotation.y, rotation.z)
		self.scale = float2(scale.x, scale.y)
		
		_updateMatrix()
	}
	
	private func _updateMatrix() {
		self._matrix = DKMath.newTranslation(self.position) *
					   DKMath.newRotationX(self.rotation.x) *
					   DKMath.newRotationY(self.rotation.y) *
					   DKMath.newRotationZ(self.rotation.z) *
					   DKMath.newScale(self.scale.x, y: self.scale.y, z: 1.0)
	}
}

internal class DKRTransformManager {
	private var _transforms: [Int : DKRTransformData]
	private var _nextTransformIndex: Int
	
	internal init() {
		_transforms = [:]
		_nextTransformIndex = 0
	}
	
	internal func create(_ position: (x: Float, y: Float, z: Float),
	                     _ rotation: (x: Float, y: Float, z: Float),
							_ scale: (x: Float, y: Float)) -> Int {
		
		let transform = DKRTransformData(position: position, rotation: rotation, scale: scale)
		
		let index = _nextTransformIndex
		_transforms[index] = transform
		_nextTransformIndex += 1
		
		return index
	}
	
	internal func getTransform(_ id: Int) -> DKRTransformData {
		return _transforms[id]!
	}
}
