//
//  dMeshManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 26/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation

public class dMeshData {
	internal var name: String
	internal var buffers: [dBufferable] = []
	internal var indicesBuffer: dBufferable?
	internal var indicesCount: Int?
	
	internal init(name: String) {
		self.name = name
	}
}

internal class dMeshManager {
	private var _meshes: [String : dMeshData] = [:]
	
	internal func create(mesh name: String,
	                     buffers: [dBufferable],
	                     indicesBuffer: dBufferable?,
	                     indicesCount: Int?) {
		
		let meshData = dMeshData(name: name)
		meshData.buffers = buffers
		meshData.indicesBuffer = indicesBuffer
		meshData.indicesCount = indicesCount
		
		self._meshes[name] = meshData
	}
	
	internal func get(mesh name: String) -> dMeshData? {
		return self._meshes[name]
	}
}
