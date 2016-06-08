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
	
	private var _preAllocateSize: Int?
	
	internal var uModelBuffer: DKRBuffer<DKModelUniform>? {
		get {
			return _uModels
		}
	}
	
	internal init(drawable: DKRDrawable) {
		self.drawable = drawable
	}
	
	internal func addUModelBuffer(uModel: DKModelUniform) -> Int {
		if _uModels == nil {
			_createBuffer([uModel])
		}
		
		if let size = _preAllocateSize {
			_uModels?.extendTo(size)
			_preAllocateSize = nil
		}
		
		return _uModels!.append(uModel)
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