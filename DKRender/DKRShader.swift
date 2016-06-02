//
//  DKRShader.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 12/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

public class DKRShader {
	internal var rpState: MTLRenderPipelineState!
	internal var name: String
	internal var vfName: String
	internal var ffName: String
	
	private var _vertexFunction: MTLFunction?
	private var _fragmentFunction: MTLFunction?
	
	public init(name: String, vertexName: String = "", fragmentName: String = "") throws {
		if name.isEmpty {
			throw DKInvalidArgumentError(description: "Shader name cannot be empty!")
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
		
		self._vertexFunction = DKRCore.instance.library.newFunctionWithName(vfName)
		
		if self._vertexFunction == nil {
			throw DKShaderNotFoundError(name: vfName)
		}
		
		self._fragmentFunction = DKRCore.instance.library.newFunctionWithName(ffName)
		
		if self._fragmentFunction == nil {
			throw DKShaderNotFoundError(name: ffName)
		}
		
		do {
			rpState = try DKRCore.instance.device.newRenderPipelineStateWithDescriptor(setupRenderPipelineDescriptor())
		}
		catch {
			assert(false, "Shader with name: \(name) fail on creation!!")
		}
	}
	
	private func setupRenderPipelineDescriptor() -> MTLRenderPipelineDescriptor {
		let rpDescriptor = MTLRenderPipelineDescriptor()
		
		rpDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
		rpDescriptor.colorAttachments[0].blendingEnabled = true
		
//		rpDescriptor.colorAttachments[0].alphaBlendOperation = MTLBlendOperation.Add
//		rpDescriptor.colorAttachments[0].rgbBlendOperation = MTLBlendOperation.Add
//		
//		rpDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactor.SourceAlpha
//		rpDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactor.OneMinusSourceAlpha
//		
//		rpDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactor.SourceAlpha
//		rpDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactor.OneMinusSourceAlpha
		
		rpDescriptor.depthAttachmentPixelFormat = .Depth32Float_Stencil8
		rpDescriptor.stencilAttachmentPixelFormat = .Depth32Float_Stencil8
		
		rpDescriptor.vertexFunction = self._vertexFunction
		rpDescriptor.fragmentFunction = self._fragmentFunction
		
		return rpDescriptor
	}
}