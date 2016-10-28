//
//  DKRTransformManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 10/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Foundation
import simd

internal class dTransformData {
	internal var position: dVector3D
	// Definir a posição dentro de outro transform
	//internal var localPosition: float3
    internal var name: String
	internal var rotation: dVector3D
	internal var scale: dSize2D
	internal var parentTransform: dTransformData?
    
    internal var meshScale: dSize2D?
	
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
	
    internal init(name: String,
                  position: (x: Float, y: Float, z: Float),
	              rotation: (x: Float, y: Float, z: Float),
	              scale: (x: Float, y: Float)) {
		
		self.position = dVector3D(position.x, position.y, position.z)
		self.rotation = dVector3D(rotation.x, rotation.y, rotation.z)
		self.scale =	dSize2D(scale.x, scale.y)
        self.name = name
		
		_updateMatrix()
	}
	
    private func _updateMatrix() {
        self._localMatrix4x4 =	dMath.newTranslation(self.position.Get()) *
                                dMath.newRotationX(self.rotation.Get().x) *
                                dMath.newRotationY(self.rotation.Get().y) *
                                dMath.newRotationZ(self.rotation.Get().z) *
                                dMath.newScale(self.scale.Get().x, y: self.scale.Get().y, z: 1.0)
        
		if self.parentTransform != nil {
            self.parentTransform!._updateMatrix()
			self._worldMatrix4x4 = self.parentTransform!._worldMatrix4x4 * self._localMatrix4x4
		} else {
            self._worldMatrix4x4 = _localMatrix4x4
		}
	}
}

internal class dTransformManager {
	private var _transforms: [Int : dTransformData] = [:]
	
    internal func create(_ name: String,
                         _ position: (x: Float, y: Float, z: Float),
                         _ rotation: (x: Float, y: Float, z: Float),
                         _ scale: (x: Float, y: Float)) -> Int {
        
        return self.create(name, position, rotation, scale, Int(NSDate().timeIntervalSince1970 * 1000000))
    }
    
    internal func create(_ name: String,
                         _ position: (x: Float, y: Float, z: Float),
	                     _ rotation: (x: Float, y: Float, z: Float),
                         _ scale: (x: Float, y: Float),
                         _ id: Int) -> Int {
		
        let transform = dTransformData(name: name, position: position, rotation: rotation, scale: scale)
		
		_transforms[id] = transform
		
		return id
	}
	
	internal func getTransform(_ id: Int) -> dTransformData {
		return _transforms[id]!
	}
}
