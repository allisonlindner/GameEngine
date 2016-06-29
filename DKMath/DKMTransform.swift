//
//  DKMTransform.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import simd

public class DKMTransform {
	private var _id: Int
	internal var drawableInstances: [(drawable: DKRDrawableInstance, index: Int)]
	
	public var matrix4x4: float4x4 {
		get {
			return DKRCore.instance.trManager.getTransform(_id).matrix4x4
		}
	}
	
	public var position: float3 {
		get {
			return DKRCore.instance.trManager.getTransform(_id).position
		}
		set {
			changedValue()
			DKRCore.instance.trManager.getTransform(_id).position = newValue
		}
	}
	
	public var rotation: float3 {
		get {
			return DKRCore.instance.trManager.getTransform(_id).rotation
		}
		set {
			changedValue()
			DKRCore.instance.trManager.getTransform(_id).rotation = newValue
		}
	}
	
	public var scale: float2 {
		get {
			return DKRCore.instance.trManager.getTransform(_id).scale
		}
		set {
			changedValue()
			DKRCore.instance.trManager.getTransform(_id).scale = newValue
		}
	}
	
	private func changedValue() {
		for drawableInstance in drawableInstances {
			drawableInstance.drawable.changedTransforms[drawableInstance.index] = self
			drawableInstance.drawable.changed = true
		}
	}
	
	public init(position: (x: Float, y: Float, z: Float),
	            rotation: (x: Float, y: Float, z: Float),
				   scale: (x: Float, y: Float)) {
		
		self._id = DKRCore.instance.trManager.create(position, rotation, scale)
		drawableInstances = []
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