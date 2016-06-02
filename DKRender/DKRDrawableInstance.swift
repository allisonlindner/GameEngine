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
	
	internal func addUModelBuffer(uModel: DKModelUniform) {
		if _uModels == nil {
			_createBuffer([uModel])
		} else {
			_uModels?.data.append(uModel)
		}
	}
	
	private func _createBuffer(uModel: [DKModelUniform]) {
		_uModels = DKRBuffer(data: uModel, index: 1)
	}
}