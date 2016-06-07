//
//  DKRDrawableInstance.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 19/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import DKMath

public class DKRDrawableInstance {
	internal var drawable: DKRDrawable
	
	private var _uModels: DKRBuffer<DKModelUniform>?
	
	internal var uModelBuffer: DKRBuffer<DKModelUniform>? {
		get {
			return _uModels
		}
	}
	
	internal init(drawable: DKRDrawable) {
		self.drawable = drawable
	}
	
	internal func addUModelBuffer(uModel: DKModelUniform, preAllocateQuad: Int = 1) {
		if _uModels == nil {
			_createBuffer([uModel], preAllocateQuad: preAllocateQuad)
		} else {
			_uModels?.append(uModel)
		}
	}
	
	private func _createBuffer(uModel: [DKModelUniform], preAllocateQuad: Int = 1) {
		_uModels = DKRBuffer(data: uModel, index: 1, preAllocateSize: preAllocateQuad)
	}
}