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
	internal var id: Int?
	internal var shader: DKRShader!
	internal var drawables: [String : DKRDrawableInstance]
	internal var textureInstances: [Int:DKRTextureInstance]
	
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
		textureInstances = [:]
	}
	
	public func createDrawable(_ name: String, drawable: DKRDrawable, size: Int = 1) {
		if drawables[name] == nil {
			drawables[name] = DKRDrawableInstance(drawable: drawable)
			drawables[name]!.extendTo(size)
		}
	}
	
	public func extendDrawable(_ name: String, to size: Int) {
		if drawables[name] == nil {
			drawables[name]!.extendTo(size)
		}
	}
	
	public func addInstance(_ name: String, transform: DKMTransform) {
		if drawables[name] == nil {
			fatalError("No drawable with name: \(name)")
		}
		
		_ = drawables[name]?.addTransform(transform)
	}
	
	public func setTexture(_ name: String, index: Int) {
		textureInstances[index] = DKRTextureInstance(index: index, texture: DKRTexture(name: name))
	}
	
	internal func getUniformBuffers() -> [DKBuffer]? {
		if let _dataSource = dataSource {
			return _dataSource.uniformBuffers()
		}
		
		return nil
	}
}
