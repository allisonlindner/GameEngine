//
// Created by Allison Lindner on 14/05/16.
// Copyright (c) 2016 Allison Lindner. All rights reserved.
//

import Metal

internal class DKRRendererFactory {

	private func buildDepthTexture(_ texture: MTLTexture) -> MTLTexture {
		let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(with: .depth32Float_Stencil8,
				width: texture.width,
				height: texture.height,
				mipmapped: false)
		textureDescriptor.usage = .renderTarget
		textureDescriptor.storageMode = .private
		
		let depthTexture = DKRCore.instance.device.newTexture(with: textureDescriptor)

		return depthTexture
	}

	private func buildDepthStencilDescriptor() -> MTLDepthStencilDescriptor {
		let stencilState = MTLStencilDescriptor()
		
		stencilState.stencilCompareFunction = .always;
		stencilState.stencilFailureOperation = .keep;
		stencilState.depthFailureOperation = .keep;
		stencilState.depthStencilPassOperation = .replace;
		stencilState.readMask = 0xFF;
		stencilState.writeMask = 0xFF;
		
		let dsDescriptor = MTLDepthStencilDescriptor();
		dsDescriptor.depthCompareFunction = .less
		dsDescriptor.isDepthWriteEnabled = true
		dsDescriptor.frontFaceStencil.stencilCompareFunction = .equal
		dsDescriptor.frontFaceStencil.stencilFailureOperation = .keep
		dsDescriptor.frontFaceStencil.depthFailureOperation = .incrementClamp
		dsDescriptor.frontFaceStencil.depthStencilPassOperation = .incrementClamp
		dsDescriptor.depthCompareFunction = .lessEqual;
		
		dsDescriptor.backFaceStencil = stencilState
		dsDescriptor.frontFaceStencil = stencilState

		return dsDescriptor
	}

	internal func buildRenderPassDescriptor(_ texture: MTLTexture) -> MTLRenderPassDescriptor {
		let renderPassDescriptor = MTLRenderPassDescriptor()
		let depthStencilTexture = buildDepthTexture(texture)

		renderPassDescriptor.colorAttachments[0].texture = texture
		renderPassDescriptor.colorAttachments[0].loadAction = .clear
		renderPassDescriptor.colorAttachments[0].storeAction = .store
		renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
		renderPassDescriptor.depthAttachment.texture = depthStencilTexture
		renderPassDescriptor.stencilAttachment.texture = depthStencilTexture

		return renderPassDescriptor
	}

	internal func buildDepthStencil() -> MTLDepthStencilState {
		return DKRCore.instance.device.newDepthStencilState(with: buildDepthStencilDescriptor())
	}
	
	internal func buildSamplerState() -> MTLSamplerState {
		let samplerDescriptor = MTLSamplerDescriptor()
		samplerDescriptor.minFilter = .nearest
		samplerDescriptor.magFilter = .linear
		samplerDescriptor.sAddressMode = .repeat
		samplerDescriptor.tAddressMode = .repeat
		samplerDescriptor.rAddressMode = .clampToEdge
		samplerDescriptor.normalizedCoordinates = true
		samplerDescriptor.lodMinClamp = 0
		samplerDescriptor.lodMaxClamp = FLT_MAX
		
		return DKRCore.instance.device.newSamplerState(with: samplerDescriptor)
	}
}
