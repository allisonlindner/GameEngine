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

	internal func startFrame(texture texture: MTLTexture) -> Int {
		_cBuffer = DKRCore.instance.cQueue.commandBuffer()
		_cBuffer.enqueue()
		
		if _rFactory == nil {
			_rFactory = DKRRendererFactory()
		}
		
		let index = _nextIndex
		let encoder = _cBuffer.renderCommandEncoderWithDescriptor(_rFactory!.buildRenderPassDescriptor(texture))
		encoder.setDepthStencilState(_rFactory?.buildDepthStencil())
		encoder.setFrontFacingWinding(.CounterClockwise)
		encoder.setCullMode(.Back)
		
		encoder.setFragmentSamplerState(_rFactory?.buildSamplerState(), atIndex: 0)
		
		_rcEncoders[index] = encoder
		_nextIndex += 1
		
		return index
	}
	
	internal func endFrame(id: Int) {
		let encoder: MTLRenderCommandEncoder = _rcEncoders[id]!
		encoder.endEncoding()
		
		_rcEncoders.removeAtIndex(_rcEncoders.indexForKey(id)!)
	}
	
	internal func encoder(withID id: Int) -> MTLRenderCommandEncoder {
		return self._rcEncoders[id]!
	}
	
	internal func present(drawable: CAMetalDrawable) {
		_cBuffer.presentDrawable(drawable)
		_cBuffer.commit()
	}
	
	internal func bind(buffer: DKBuffer, encoderID: Int) {
		let encoder = _rcEncoders[encoderID]!
		
		switch buffer.bufferType {
		case .Vertex:
			encoder.setVertexBuffer(
				buffer.buffer, offset: buffer.offset, atIndex: buffer.index
			)
		case .Fragment:
			encoder.setFragmentBuffer(
				buffer.buffer, offset: buffer.offset, atIndex: buffer.index
			)
		}
	}
}
