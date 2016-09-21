//
//  DKRShader.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 12/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

public class dShader {
	internal var rpState: MTLRenderPipelineState!
	internal var name: String
	internal var vfName: String
	internal var ffName: String
	
	private var _vertexFunction: MTLFunction?
	private var _fragmentFunction: MTLFunction?
	
	public init(name: String, vertexName: String = "", fragmentName: String = "") throws {
		if name.isEmpty {
			throw dInvalidArgumentError(description: "Shader name cannot be empty!")
		}
		
		self.name = name
		
		if vertexName.isEmpty {
			self.vfName = "\(name)_vertex"
		} else {
			self.vfName = vertexName
		}
		
		if vertexName.isEmpty {
			self.ffName = "\(name)_fragment"
		} else {
			self.ffName = fragmentName
		}
		
		self._vertexFunction = dCore.instance.library.makeFunction(name: vfName)
		
		if self._vertexFunction == nil {
			throw dShaderNotFoundError(name: vfName) as Error
		}
		
		self._fragmentFunction = dCore.instance.library.makeFunction(name: ffName)
		
		if self._fragmentFunction == nil {
			throw dShaderNotFoundError(name: ffName) as Error
		}
		
		do {
			rpState = try dCore.instance.device.makeRenderPipelineState(descriptor: setupRenderPipelineDescriptor())
		}
		catch {
			assert(false, "Shader with name: \(name) fail on creation!!")
		}
	}
	
	private func setupRenderPipelineDescriptor() -> MTLRenderPipelineDescriptor {
		let rpDescriptor = MTLRenderPipelineDescriptor()
		
		#if os(iOS)
			if #available(iOS 10.0, *) {
				rpDescriptor.colorAttachments[0].pixelFormat = .bgra10_XR_sRGB
			} else {
				rpDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
			}
		#endif
		#if os(tvOS)
			if #available(tvOS 10.0, *) {
				rpDescriptor.colorAttachments[0].pixelFormat = .bgra10_XR_sRGB
			} else {
				rpDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
			}
		#endif
		#if os(OSX)
			if #available(OSX 10.12, *) {
				rpDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm_srgb
			} else {
				rpDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
			}
		#endif
		
		rpDescriptor.colorAttachments[0].isBlendingEnabled = true
		
		rpDescriptor.colorAttachments[0].alphaBlendOperation = MTLBlendOperation.add
		rpDescriptor.colorAttachments[0].rgbBlendOperation = MTLBlendOperation.add

		rpDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactor.sourceAlpha
		rpDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactor.oneMinusSourceAlpha

		rpDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactor.sourceAlpha
		rpDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactor.oneMinusSourceAlpha
		
		rpDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
		rpDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
		
		rpDescriptor.vertexFunction = self._vertexFunction
		rpDescriptor.fragmentFunction = self._fragmentFunction
		
		return rpDescriptor
	}
}
