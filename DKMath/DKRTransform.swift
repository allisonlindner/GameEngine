//
//  DKMTransform.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import simd
import DKMath

public class DKRTransform {
	private var _id: Int
	
	public var matrix4x4: float4x4 {
		get {
			let data = DKRCore.instance.trManager.getTransform(_id)
			return data.matrix4x4
		}
	}
	
	public var position: float3 {
		get {
			let data = DKRCore.instance.trManager.getTransform(_id)
			return data.position
		}
		set {
			let data = DKRCore.instance.trManager.getTransform(_id)
			data.position = newValue
		}
	}
	
	public var rotation: float3 {
		get {
			let data = DKRCore.instance.trManager.getTransform(_id)
			return data.rotation
		}
		set {
			let data = DKRCore.instance.trManager.getTransform(_id)
			data.rotation = newValue
		}
	}
	
	public var scale: float2 {
		get {
			let data = DKRCore.instance.trManager.getTransform(_id)
			return data.scale
		}
		set {
			let data = DKRCore.instance.trManager.getTransform(_id)
			data.scale = newValue
		}
	}
	
	public init(position: (x: Float, y: Float, z: Float),
	            rotation: (x: Float, y: Float, z: Float),
				   scale: (x: Float, y: Float)) {
		
		self._id = DKRCore.instance.trManager.create(position, rotation, scale)
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