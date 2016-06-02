//
// Created by Allison Lindner on 14/05/16.
// Copyright (c) 2016 Allison Lindner. All rights reserved.
//

import Metal

internal class DKRRendererFactory {

	private func buildDepthTexture(texture: MTLTexture) -> MTLTexture {
		let textureDescriptor = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(.Depth32Float_Stencil8,
				width: texture.width,
				height: texture.height,
				mipmapped: false)
		textureDescriptor.usage = .RenderTarget
		textureDescriptor.storageMode = .Private
		
		let depthTexture = DKRCore.instance.device.newTextureWithDescriptor(textureDescriptor)

		return depthTexture
	}

	private func buildDepthStencilDescriptor() -> MTLDepthStencilDescriptor {
		let dsDescriptor = MTLDepthStencilDescriptor();
		dsDescriptor.depthCompareFunction = .Less
		dsDescriptor.depthWriteEnabled = true
		dsDescriptor.frontFaceStencil.stencilCompareFunction = .Equal
		dsDescriptor.frontFaceStencil.stencilFailureOperation = .Keep
		dsDescriptor.frontFaceStencil.depthFailureOperation = .IncrementClamp
		dsDescriptor.frontFaceStencil.depthStencilPassOperation = .IncrementClamp
		dsDescriptor.frontFaceStencil.readMask = 0x0
		dsDescriptor.frontFaceStencil.writeMask = 0x0
		dsDescriptor.backFaceStencil = nil

		return dsDescriptor
	}

	internal func buildRenderPassDescriptor(texture: MTLTexture) -> MTLRenderPassDescriptor {
		let renderPassDescriptor = MTLRenderPassDescriptor()
		let depthStencilTexture = buildDepthTexture(texture)

		renderPassDescriptor.colorAttachments[0].texture = texture
		renderPassDescriptor.colorAttachments[0].loadAction = .Clear
		renderPassDescriptor.colorAttachments[0].storeAction = .Store
		renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
		renderPassDescriptor.depthAttachment.texture = depthStencilTexture
		renderPassDescriptor.stencilAttachment.texture = depthStencilTexture

		return renderPassDescriptor
	}

	internal func buildDepthStencil() -> MTLDepthStencilState {
		return DKRCore.instance.device.newDepthStencilStateWithDescriptor(buildDepthStencilDescriptor())
	}
	
	internal func buildSamplerState() -> MTLSamplerState {
		let samplerDescriptor = MTLSamplerDescriptor()
		samplerDescriptor.minFilter = .Nearest
		samplerDescriptor.magFilter = .Linear
		samplerDescriptor.sAddressMode = .Repeat
		samplerDescriptor.tAddressMode = .Repeat
		samplerDescriptor.rAddressMode = .ClampToEdge
		samplerDescriptor.normalizedCoordinates = true
		samplerDescriptor.lodMinClamp = 0
		samplerDescriptor.lodMaxClamp = FLT_MAX
		
		return DKRCore.instance.device.newSamplerStateWithDescriptor(samplerDescriptor)
	}
}