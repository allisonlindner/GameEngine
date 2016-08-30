//
//  dShaderManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//


internal class dShaderManager {
	private var _shaders: [String : dShader] = [:]
	
	internal func register(shader name: String, vertexFunc: String, fragmentFunc: String) {
		do {
			let shader = try dShader(name: name, vertexName: vertexFunc, fragmentName: fragmentFunc)
			self._shaders[name] = shader
		} catch let error as dShaderNotFoundError {
			fatalError(error.description)
		} catch {
			fatalError("Error on shader creation: \(name)")
		}
	}
	
	public func get(shader name: String) -> dShader {
		if let shader = self._shaders[name] {
			return shader
		}
		fatalError("\(name) -> Shader not found")
	}
}
