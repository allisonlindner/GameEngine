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
	
	internal func createBuffer<T>(data: [T], index: Int = -1, offset: Int = 0) -> Int {
		let buffer = DKRCore.instance.device.newBufferWithBytes(
													data,
													length: data.count * sizeofValue(data[0]) * 2,
													options: .CPUCacheModeDefaultCache
												)
		
		let _index = _nextIndex
		_buffers[_index] = buffer
		
		_nextIndex += 1
		
		return _index
	}
	
	internal func deleteBuffer(id: Int) {
		_buffers.removeAtIndex(_buffers.indexForKey(id)!)
	}
	
	internal func getBuffer(id: Int) -> MTLBuffer? {
		return _buffers[id]
	}
}