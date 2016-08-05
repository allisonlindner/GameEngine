//
//  Renderer.swift
//  Underground - Survivors
//
//  Created by Allison Lindner on 03/09/15.
//  Copyright © 2015 Allison Lindner. All rights reserved.
//

import Metal
import MetalKit

internal class DKRRenderer {

	private var _rFactory: DKRRendererFactory?
	private var _cBuffer: MTLCommandBuffer!

	private var _rcEncoders: [Int : MTLRenderCommandEncoder]
	private var _nextIndex: Int

	internal init () {
		_rcEncoders = [:]
		_nextIndex = 0
	}

	internal func startFrame(_ texture: MTLTexture) -> Int {
		_cBuffer = DKRCore.instance.cQueue.commandBuffer()
		_cBuffer.enqueue()
		
		if _rFactory == nil {
			_rFactory = DKRRendererFactory()
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
	
	internal func bind(_ buffer: DKBuffer, encoderID: Int) {
		let encoder = _rcEncoders[encoderID]!
		
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
	}
}
