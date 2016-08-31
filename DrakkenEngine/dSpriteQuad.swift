//
//  dSQuad.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 30/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import simd

public class dSpriteQuad: dQuad {
	private var _verticesBuffer: dBuffer<float4>
	private var _normalBuffer: dBuffer<float4>
	private var _indicesBuffer: dBuffer<Int32>
	private var _verticesCountBuffer: dBuffer<Int32>
	
	private var _indicesCount: Int = 0
	
	public init(name: String = "spritequad") {
		
		let vertices = [
			float4(-0.5,-0.5, 0.0, 1.0),
			float4(-0.5, 0.5, 0.0, 1.0),
			float4( 0.5, 0.5, 0.0, 1.0),
			float4( 0.5,-0.5, 0.0, 1.0)
		]
		
		let normals = [
			float4(0.0, 0.0,-1.0, 0.0),
			float4(0.0, 0.0,-1.0, 0.0),
			float4(0.0, 0.0,-1.0, 0.0),
			float4(0.0, 0.0,-1.0, 0.0)
		]
		
		let indices: [Int32] = [2, 1, 0, 3, 2, 0]
		_indicesCount = indices.count
		
		//VertexBuffers
		_verticesBuffer = dBuffer(data: vertices, index: 2)
		_normalBuffer = dBuffer(data: normals, index: 3)
		_verticesCountBuffer = dBuffer(data: Int32(vertices.count), index: 4)
		
		//Indices
		_indicesBuffer = dBuffer(data: indices)
		
		super.init(name: name)
		
		self.buffers = ["vertices": _verticesBuffer,
		                "normals": _normalBuffer,
						"verticescount": _verticesCountBuffer]
		
		self.indicesBuffer = _indicesBuffer
		self.indicesCount = _indicesCount
	}
}
