//
//  DKRCore.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import CoreGraphics

public class DKRCore {
	public static let instance: DKRCore = DKRCore()
	
	internal var device: MTLDevice
	internal var library: MTLLibrary!
	
	internal var cQueue: MTLCommandQueue
	
	internal var renderer: DKRRenderer!
	
	internal var bManager: DKRBufferManager
	internal var tManager: DKRTextureManager
	internal var trManager: DKRTransformManager
	public var sManager: DKRSceneManager
	
	internal init() {
		self.device = MTLCreateSystemDefaultDevice()!
		self.cQueue = device.newCommandQueue()
		
		self.bManager = DKRBufferManager()
		self.tManager = DKRTextureManager()
		self.trManager = DKRTransformManager()
		self.sManager = DKRSceneManager()

		self.renderer = DKRRenderer()
		
		let bundle = Bundle.init(identifier: "drakken.DrakkenKit")
		
		if let path = bundle!.pathForResource("default", ofType: "metallib") {
			do
			{
				library = try self.device.newLibrary(withFile: path)
			}
			catch MTLLibraryError.internal
			{
				assert(false, "Bundle identifier incorrect!")
			}
			catch MTLLibraryError.compileFailure
			{
				assert(false, "Compile failure")
			}
			catch MTLLibraryError.compileWarning
			{
				assert(false, "Compile warning")
			}
			catch MTLLibraryError.unsupported
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
