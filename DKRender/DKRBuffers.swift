//
//  Buffer.swift
//  DKMetal
//
//  Created by Allison Lindner on 07/04/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import MetalKit

public enum DKRBufferType {
	case vertex
	case fragment
}

public protocol DKBuffer {
	var buffer: MTLBuffer { get }
	var index: Int { get set }
	var offset: Int { get set }
	var bufferType: DKRBufferType { get }
	var count: Int { get }
}

internal class DKRBuffer<T>: DKBuffer {
	private var _data: [T]
	private var _id: Int!
	private var _index: Int
	private var _offset: Int
	private var _staticMode: Bool
	private var _bufferType: DKRBufferType
	
	private var _bufferChanged: Bool
	
	internal var id: Int {
		get {
			return self._id
		}
	}
	
	internal var bufferType: DKRBufferType {
		get {
			return _bufferType
		}
	}
	
	internal var index: Int {
		get {
			return self._index
		}
		set (i) {
			self._index = i
		}
	}
	
	internal var offset: Int {
		get {
			return self._offset
		}
		set (o) {
			self._offset = o
		}
	}
	
	internal var data: [T] {
		get {
			return self._data
		}
	}
	
	internal var buffer: MTLBuffer {
		get {
			if self._bufferChanged {
				_updateBuffer()
			}
			
			guard let buffer = DKRCore.instance.bManager.getBuffer(_id) else {
				fatalError("Buffer nil")
			}
			
			return buffer
		}
	}
	
	internal var count: Int {
		get {
			return self._data.count
		}
	}

	internal init(data: [T], index: Int = -1, preAllocateSize size: Int = 1, bufferType: DKRBufferType = .vertex,
	            staticMode: Bool = false , offset: Int = 0) {
		self._index = index
		self._offset = offset
		self._staticMode = staticMode
		self._bufferType = bufferType
		
		self._data = data
		self._bufferChanged = true
		
		if size > data.count {
			self._data.reserveCapacity(size)
		}
		
		_updateBuffer()
	}
	
	internal convenience init(data: T, index: Int = -1, preAllocateSize size: Int = 1, bufferType: DKRBufferType = .vertex,
	                          staticMode: Bool = false , offset: Int = 0) {
		
		self.init(data: [data], index: index, preAllocateSize: size, bufferType: bufferType, staticMode: staticMode, offset: offset)
	}
	
	internal func append(_ data: T) -> Int {
		self._data.append(data)
		self._bufferChanged = true
		
		return self._data.count - 1
	}
	
	internal func change(_ data: T, atIndex: Int) {
		self._data[atIndex] = data
		
		let pointer = self.buffer.contents()
		memcpy(pointer + (atIndex * sizeof(T.self)), [data], sizeof(T.self))
	}
	
	internal func extendTo(_ size: Int) {
		if size > self._data.capacity {
			self._data.reserveCapacity(size)
		}
		self._bufferChanged = true
	}

	private func _updateBuffer() {
		self._id = DKRCore.instance.bManager.createBuffer(
															_data,
															index: self._index,
															offset: self._offset,
															id: self._id
														)
		_bufferChanged = false
	}
	
	internal func finishBuffer() {
		_updateBuffer()
	}
}
