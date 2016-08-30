//
//  DKRTransformManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 10/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import simd

internal class dTransformData {
	internal var position: float3
	// Definir a posição dentro de outro transform
	//internal var localPosition: float3
	internal var rotation: float3
	internal var scale: float2
	internal var parentTransform: dTransformData?
	
	private var _localMatrix4x4: float4x4!
	internal var localMatrix4x4: float4x4! {
		get {
			self._updateMatrix()
			return self._localMatrix4x4
		}
	}
	
	private var _worldMatrix4x4: float4x4!
	internal var worldMatrix4x4: float4x4! {
		get {
			self._updateMatrix()
			return self._worldMatrix4x4
		}
	}
	
	internal init(position: (x: Float, y: Float, z: Float),
	              rotation: (x: Float, y: Float, z: Float),
					 scale: (x: Float, y: Float)) {
		
		self.position = float3(position.x, position.y, position.z)
		self.rotation = float3(rotation.x, rotation.y, rotation.z)
		self.scale =	float2(scale.x, scale.y)
		
		_updateMatrix()
	}
	
	private func _updateMatrix() {
		self._localMatrix4x4 =	dMath.newTranslation(self.position) *
								dMath.newRotationX(self.rotation.x) *
								dMath.newRotationY(self.rotation.y) *
								dMath.newRotationZ(self.rotation.z) *
								dMath.newScale(self.scale.x, y: self.scale.y, z: 1.0)
		
		if self.parentTransform != nil {
			self._worldMatrix4x4 = self.parentTransform!._worldMatrix4x4 *
									self._localMatrix4x4
		} else {
			self._worldMatrix4x4 = _localMatrix4x4
		}
	}
}

internal class dTransformManager {
	private var _transforms: [Int : dTransformData] = [:]
	private var _nextTransformIndex: Int = 0
	
	internal func create(_ position: (x: Float, y: Float, z: Float),
	                     _ rotation: (x: Float, y: Float, z: Float),
							_ scale: (x: Float, y: Float)) -> Int {
		
		let transform = dTransformData(position: position, rotation: rotation, scale: scale)
		
		let index = _nextTransformIndex
		_transforms[index] = transform
		_nextTransformIndex += 1
		
		return index
	}
	
	internal func getTransform(_ id: Int) -> dTransformData {
		return _transforms[id]!
	}
}
