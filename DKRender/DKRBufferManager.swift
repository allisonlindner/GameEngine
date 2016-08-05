//
//  DKRBufferManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 19/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

internal class DKRBufferManager {
	private var _buffers: [Int: MTLBuffer]
	private var _nextIndex: Int
	
	internal init() {
		_buffers = [:]
		_nextIndex = 0
	}
	
	internal func createBuffer<T>(_ data: [T], index: Int = -1, offset: Int = 0, id: Int? = nil) -> Int {
		let buffer = DKRCore.instance.device.newBuffer(
													withBytes: data,
													length: (data.count + 1) * sizeofValue(data[0]),
													options: MTLResourceOptions()
												)
		if id != nil {
			_buffers[id!] = buffer
			return id!
		}
		
		let _index = _nextIndex
		_buffers[_index] = buffer
		
		_nextIndex += 1
		
		return _index
	}
	
	internal func deleteBuffer(_ id: Int) {
		_buffers.remove(at: _buffers.index(forKey: id)!)
	}
	
	internal func getBuffer(_ id: Int) -> MTLBuffer? {
		return _buffers[id]
	}
}
