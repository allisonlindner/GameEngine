//
//  Renderer.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Metal
import MetalKit

internal class dRenderer {

	private var _rFactory: dRendererFactory?
	private var _cBuffer: MTLCommandBuffer!

	private var _rcEncoders: [Int : MTLRenderCommandEncoder] = [:]
	private var _nextIndex: Int = 0

	internal func startFrame(_ texture: MTLTexture) -> Int {
		_cBuffer = dCore.instance.cQueue.commandBuffer()
		_cBuffer.enqueue()
		
		if _rFactory == nil {
			_rFactory = dRendererFactory()
		}
		
		let index = _nextIndex
		let encoder = _cBuffer.renderCommandEncoder(with: _rFactory!.buildRenderPassDescriptor(texture))
		encoder.setDepthStencilState(_rFactory?.buildDepthStencil())
		encoder.setFrontFacing(.counterClockwise)
		encoder.setCullMode(.back)
		
		encoder.setFragmentSamplerState(_rFactory?.buildSamplerState(), at: 0)
		
		_rcEncoders[index] = encoder
		_nextIndex += 1
		
		return index
	}
	
	internal func endFrame(_ id: Int) {
		let encoder: MTLRenderCommandEncoder = _rcEncoders[id]!
		encoder.endEncoding()
		
		_rcEncoders.remove(at: _rcEncoders.index(forKey: id)!)
	}
	
	internal func encoder(withID id: Int) -> MTLRenderCommandEncoder {
		return self._rcEncoders[id]!
	}
	
	internal func present(_ drawable: CAMetalDrawable) {
		_cBuffer.present(drawable)
		_cBuffer.commit()
	}
	
	internal func bind(_ buffer: dBufferable, encoderID: Int) {
		if let encoder = _rcEncoders[encoderID] {
			switch buffer.bufferType {
			case .vertex:
				encoder.setVertexBuffer(
					buffer.buffer, offset: buffer.offset, at: buffer.index
				)
			case .fragment:
				encoder.setFragmentBuffer(
					buffer.buffer, offset: buffer.offset, at: buffer.index
				)
			}
		} else {
			fatalError("Invalid Encoder ID")
		}
	}
	
	internal func bind(_ materialTexture: dMaterialTexture, encoderID: Int) {
		if let encoder = _rcEncoders[encoderID] {
			encoder.setFragmentTexture(materialTexture.texture.getTexture(), at: materialTexture.index)
		} else {
			fatalError("Invalid Encoder ID")
		}
	}
	
	internal func bind(_ material: dMaterialData, encoderID: Int) {
		if let encoder = _rcEncoders[encoderID] {
			encoder.setRenderPipelineState(material.shader.rpState)
		}
		
		for buffer in material.buffers {
			self.bind(buffer, encoderID: encoderID)
		}
		
		for texture in material.textures {
			self.bind(texture, encoderID: encoderID)
		}
	}
	
	internal func draw(_ mesh: dMeshData, encoderID: Int, modelMatrixBuffer: dBufferable) {
		for buffer in mesh.buffers {
			self.bind(buffer, encoderID: encoderID)
		}
		
		self.bind(modelMatrixBuffer, encoderID: encoderID)
		
		if let encoder = _rcEncoders[encoderID] {
			encoder.drawIndexedPrimitives(.triangle,
			                              indexCount: mesh.indicesCount!,
			                              indexType: .uInt32,
			                              indexBuffer: mesh.indicesBuffer!.buffer,
			                              indexBufferOffset: 0,
			                              instanceCount: modelMatrixBuffer.count)
		}
	}
}
