//
//  DKRQuad.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 19/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import simd

public class DKRQuad: DKRDrawable {
	private var _verticesBuffer: DKRBuffer<float4>
	private var _normalBuffer: DKRBuffer<float4>
	private var _texCoordBuffer: DKRBuffer<float2>
	private var _indicesBuffer: DKRBuffer<Int32>
	
	private var _indicesCount: Int = 0
	
	public init() {
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
		
		let texCoords = [
			float2(0.0, 0.0),
			float2(0.0, 1.0),
			float2(1.0, 1.0),
			float2(1.0, 0.0)
		]
		
		let indices: [Int32] = [2, 1, 0, 3, 2, 0]
		_indicesCount = indices.count
		
		//VertexBuffers
		_verticesBuffer = DKRBuffer(data: vertices, index: 2)
		_normalBuffer = DKRBuffer(data: normals, index: 3)
		
		//FragmentBuffer
		_texCoordBuffer = DKRBuffer(data: texCoords, index: 4)
		
		//Indices
		_indicesBuffer = DKRBuffer(data: indices)
	}
	
	internal func getBuffers() -> [DKBuffer] {
		return [_verticesBuffer, _normalBuffer, _texCoordBuffer]
	}
	
	internal func getIndicesBuffer() -> DKBuffer {
		return _indicesBuffer
	}
}