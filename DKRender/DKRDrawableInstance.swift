//
//  DKRDrawableInstance.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 19/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

public class DKRDrawableInstance {
	internal var changed = false
	internal var changedTransforms: [Int : DKRTransform]
	internal var drawable: DKRDrawable
	
	private var _uModels: DKRBuffer<DKModelUniform>?
	private var _preAllocateSize: Int?
	
	internal var uModelBuffer: DKRBuffer<DKModelUniform>? {
		get {
			if changed {
				for transform in changedTransforms {
					_uModels?.change(DKModelUniform(modelMatrix: transform.1.matrix4x4),
					                 atIndex: transform.0)
				}
				changed = false
			}
			return _uModels
		}
	}
	
	internal init(drawable: DKRDrawable) {
		self.drawable = drawable
		self.changedTransforms = [:]
	}
	
	internal func addUModelBuffer(uModel: DKModelUniform) -> Int {
		if _uModels == nil {
			_createBuffer([uModel])
			
			if let size = _preAllocateSize {
				_uModels?.extendTo(size)
				_preAllocateSize = nil
			}
			
			return 0
		}
		
		if let size = _preAllocateSize {
			_uModels?.extendTo(size)
			_preAllocateSize = nil
		}
		
		return _uModels!.append(uModel)
	}
	
	internal func addTransform(transform: DKRTransform) -> Int {
		let index = self.addUModelBuffer(DKModelUniform(modelMatrix: transform.matrix4x4))
		
		transform.drawableInstances.append((drawable: self, index: index))
		
		return index
	}
	
	internal func extendTo(size: Int) {
		_preAllocateSize = size
	}
	
	private func _createBuffer(uModel: [DKModelUniform]) {
		_uModels = DKRBuffer(data: uModel, index: 1)
		
		if let size = _preAllocateSize {
			_uModels!.extendTo(size)
			_preAllocateSize = nil
		}
	}
}