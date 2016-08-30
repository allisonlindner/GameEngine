//
//  dMesh.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 25/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation

public class dMeshDef {
	internal var name: String
	internal var buffers: [String : dBufferable] = [:]
	internal var indicesBuffer: dBufferable?
	internal var indicesCount: Int?
	
	public init(name: String) {
		self.name = name
	}
	
	internal func set(buffer name: String, data: dBufferable) {
		self.buffers[name] = data
	}
	
	internal func set(indices buffer: dBufferable, count: Int) {
		self.indicesBuffer = buffer
		self.indicesCount = count
	}
}

internal class dMesh {
	private var _meshDef: dMeshDef
	
	internal init(meshDef: dMeshDef) {
		self._meshDef = meshDef
	}
	
	internal func build() {
		var buffers: [dBufferable] = []
		for buffer in self._meshDef.buffers {
			buffers.append(buffer.value)
		}
		
		dCore.instance.mshManager.create(mesh: self._meshDef.name,
		                                 buffers: buffers,
		                                 indicesBuffer: self._meshDef.indicesBuffer,
		                                 indicesCount: self._meshDef.indicesCount)
	}
}
