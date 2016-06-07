//
//  DKRMateriable.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 18/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

public protocol DKRMaterialDataSource {
	func uniformBuffers() -> [DKBuffer]
}

public class DKRMaterial {
	internal var shader: DKRShader!
	internal var drawables: [String : DKRDrawableInstance]
	internal var textureInstances: [DKRTextureInstance]
	
	public var dataSource: DKRMaterialDataSource?
	
	public init(shaderName: String) {
		do {
			shader = try DKRShader(name: shaderName)
		} catch let error as DKShaderNotFoundError {
			assert(false, error.description)
		} catch {
			assert(false, "Error on shader creation: diffuse")
		}
		
		drawables = [:]
		textureInstances = []
	}
	
	public func createDrawable(name: String, drawable: DKRDrawable, size: Int = 1) {
		drawables[name] = DKRDrawableInstance(drawable: drawable)
		drawables[name]!.extendTo(size)
	}
	
	internal func getUniformBuffers() -> [DKBuffer]? {
		if let _dataSource = dataSource {
			return _dataSource.uniformBuffers()
		}
		
		return nil
	}
}