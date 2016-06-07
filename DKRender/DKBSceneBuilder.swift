//
//  DKRSceneCreator.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKMath

public protocol DKSceneBuilder {
	func createScene(transform: DKMTransform) -> DKScene
	func newTexture(name: String, fileName fName: String, fileExtension ext: String)
	func finish()
}

public protocol DKScene {
	func createScene(transform: DKMTransform) -> DKScene
	func addMaterial(material: DKRMaterial) -> DKMaterial
	func finish()
}

public protocol DKMaterial {
	func createDrawable(name: String, drawable: DKRDrawable) -> DKMaterial
	func createDrawable(name: String, drawable: DKRDrawable, size: Int) -> DKMaterial
	func addDrawableInstance(name: String, transform: DKMTransform) -> DKMaterial
	func setTexture(textureName: String) -> DKMaterial
}

public class DKBSceneBuilder: DKScene, DKMaterial, DKSceneBuilder {
	internal var sceneGraph: DKRSceneGraph
	internal var sceneName: String
	private var _currentScene: DKRScene?

	private var _nextMateriableIndex: Int
	
	private var _materialIndex: Int?

	internal init(inout sceneGraph: DKRSceneGraph, name: String, scene: DKRScene? = nil) {
		self.sceneGraph = sceneGraph
		self._nextMateriableIndex = 0
		self.sceneName = name
		self._currentScene = scene
	}
	
	public func createScene(transform: DKMTransform) -> DKScene {
		let newScene = DKRScene()
		
		self.sceneGraph.scene = newScene
		
		newScene.currentCamera.changeSize(transform.scale.x, transform.scale.y)
		
		let newSceneBuilder = DKBSceneBuilder(sceneGraph: &self.sceneGraph,
		                                      name: self.sceneName,
		                                      scene: newScene)
		
		if let scene = self._currentScene {
			scene.scenes.append(newScene)
		} else {
			newSceneBuilder._nextMateriableIndex = self._nextMateriableIndex
		}
		
		return newSceneBuilder
	}
	
	public func addMaterial(material: DKRMaterial) -> DKMaterial {
		let index = self._nextMateriableIndex
		if let scene = self._currentScene {
			scene.materials[index] = material
			self._nextMateriableIndex += 1
		}
		
		let newSceneBuilder = DKBSceneBuilder(sceneGraph: &self.sceneGraph,
		                                      name: self.sceneName,
		                                      scene: self._currentScene)
		
		newSceneBuilder._nextMateriableIndex = self._nextMateriableIndex
		newSceneBuilder._materialIndex = index
		
		return newSceneBuilder
	}
	
	public func createDrawable(name: String, drawable: DKRDrawable) -> DKMaterial {
		return self.createDrawable(name, drawable: drawable, size: 1)
	}
	
	public func createDrawable(name: String, drawable: DKRDrawable, size: Int) -> DKMaterial {
		if let scene = self._currentScene {
			if let materialIndex = self._materialIndex {
				let material = scene.materials[materialIndex]!
				
				material.createDrawable(name, drawable: drawable, size: size)
			}
		}
		
		return self
	}
	
	public func addDrawableInstance(name: String, transform: DKMTransform) -> DKMaterial {
		if let scene = self._currentScene {
			if let materialIndex = self._materialIndex {
				let material = scene.materials[materialIndex]!
				
				if let drawable = material.drawables[name] {
					drawable.addUModelBuffer(
						DKModelUniform(modelMatrix: transform.matrix4x4)
					)
					sceneGraph.nodeCount += 1
				}
			}
		}
		
		return self
	}
	
	public func finish() {
		if let scene = self._currentScene {
			if let materialIndex = self._materialIndex {
				let material = scene.materials[materialIndex]!
				
				for drawable in material.drawables {
					drawable.1.uModelBuffer?.finishBuffer()
				}
			}
		}
		print("Scene: \(self.sceneName) - nodes: \(sceneGraph.nodeCount)")
	}
	
	public func newTexture(name: String, fileName fName: String, fileExtension ext: String) {
		_ = DKRTexture(name: name, fileName: fName, fileExtension: ext)
	}
	
	public func setTexture(textureName: String) -> DKMaterial {
		if let scene = self._currentScene {
			if let materialIndex = self._materialIndex {
				let material = scene.materials[materialIndex]!
				
				material.textureInstances.append(
												DKRTextureInstance(
														index: 0,
														texture: DKRTexture(name: textureName)
													)
												)
			}
		}
		
		return self
	}
}