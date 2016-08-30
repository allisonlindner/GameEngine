//
//  DKMTransform.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import simd

public class dTransform {
	internal var _id: Int
	private var _tranformData: dTransformData!
	
	private var _indexOnParentArray: Int?
	private var _parentTransform: dTransform?
	internal var parentTransform: dTransform? {
		get { return self._parentTransform }
	}
	
	private var _childrenTransforms: [dTransform] = []
	internal var childrenTransforms: [dTransform] {
		get { return self._childrenTransforms }
	}
	
	private var _components: [dComponent] = []
	internal var components: [dComponent] {
		get { return self._components }
	}
	
	public var localMatrix4x4: float4x4 {
		get { return self._tranformData.localMatrix4x4 }
	}
	
	public var worldMatrix4x4: float4x4 {
		get { return self._tranformData.worldMatrix4x4 }
	}
	
	public var localPosition: float3 {
		get { return self._tranformData.position }
		set { self._tranformData.position = newValue }
	}
	
	public var rotation: float3 {
		get { return self._tranformData.rotation }
		set { self._tranformData.rotation = newValue }
	}
	
	public var scale: float2 {
		get { return self._tranformData.scale }
		set { self._tranformData.scale = newValue }
	}
	
	public init(position: (x: Float, y: Float, z: Float),
	            rotation: (x: Float, y: Float, z: Float),
				   scale: (x: Float, y: Float),
				  parent: dTransform?) {
		
		self._id = dCore.instance.trManager.create(position, rotation, scale)
		self._tranformData = dCore.instance.trManager.getTransform(_id)
		
		self._parentTransform = parent
	}
	
	public convenience init(positionX x: Float, y: Float, z: Float) {
		self.init(position: (x, y, z),
		          rotation: (0.0, 0.0, 0.0),
					 scale: (1.0, 1.0),
					 parent: nil)
	}
	
	public convenience init(rotationX x: Float, y: Float, z: Float) {
		self.init(position: (0.0, 0.0, 0.0),
		          rotation: (x, y, z),
					 scale: (1.0, 1.0),
					parent: nil)
	}
	
	public convenience init(scaleX x: Float, y: Float) {
		self.init(position: (0.0, 0.0, 0.0),
		          rotation: (0.0, 0.0, 0.0),
					 scale: (x, y),
					parent: nil)
	}
	
	public convenience init() {
		self.init(position: (0.0, 0.0, 0.0),
		          rotation: (0.0, 0.0, 0.0),
					 scale: (1.0, 1.0),
					parent: nil)
	}
	
	internal func set(parent: dTransform) {
		self._parentTransform = parent
		self._tranformData.parentTransform = parent._tranformData
	}
	
	public func add(child: dTransform) {
		child._indexOnParentArray = self._childrenTransforms.count
		self._childrenTransforms.append(child)
		self.set(parent: self)
	}
	
	public func remove(child: dTransform) {
		if _indexOnParentArray != nil {
			self._childrenTransforms.remove(at: child._indexOnParentArray!)
		}
	}
	
	public func add(component: dComponent) {
		if component === dMeshRender.self {
			for c in _components {
				if c === dMeshRender.self {
					return
				}
			}
		}
		
		component.set(parent: self)
		self._components.append(component)
	}
}
