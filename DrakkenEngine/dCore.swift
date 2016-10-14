//
//  DKRCore.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import CoreGraphics

public class dCore {
	public static let instance: dCore = dCore()
	
	internal var device: MTLDevice
	internal var library: MTLLibrary!
	
	internal var cQueue: MTLCommandQueue
	
	internal var renderer: dRenderer!
	
	internal var bManager: dBufferManager
	internal var tManager: dTextureManager
	internal var trManager: dTransformManager
	internal var mtManager: dMaterialManager
	internal var shManager: dShaderManager
	internal var mshManager: dMeshManager
	internal var spManager: dSpriteManager
    internal var scManager: dSceneManager
	
	internal init() {
		self.device = MTLCreateSystemDefaultDevice()!
		self.cQueue = device.makeCommandQueue()
		
		self.bManager = dBufferManager()
		self.tManager = dTextureManager()
		self.trManager = dTransformManager()
		self.mtManager = dMaterialManager()
		self.shManager = dShaderManager()
		self.mshManager = dMeshManager()
		self.spManager = dSpriteManager()
        self.scManager = dSceneManager()

		self.renderer = dRenderer()
		
		let bundle = Bundle.init(identifier: "drakkenstudio.DrakkenEngine")
		
		if let path = bundle!.path(forResource: "default", ofType: "metallib") {
			do
			{
				library = try self.device.makeLibrary(filepath: path)
			}
			catch MTLLibraryErrorDomain.internal
			{
				assert(false, "Bundle identifier incorrect!")
			}
			catch MTLLibraryErrorDomain.compileFailure
			{
				assert(false, "Compile failure")
			}
			catch MTLLibraryErrorDomain.compileWarning
			{
				assert(false, "Compile warning")
			}
			catch MTLLibraryErrorDomain.unsupported
			{
				assert(false, "Unsupported")
			}
			catch
			{
				assert(false, "default.metallib error!")
			}
		}
	}
}
