//
//  DKRSceneCreator.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//


public class DKRSceneBuilder {
	internal var sceneGraph: DKRSceneGraph
	internal var sceneName: String
	private var _currentScene: DKRScene?

	private var _nextMateriableIndex: Int
	
	private var _materialIndex: Int?

	public init(inout sceneGraph: DKRSceneGraph, name: String, scene: DKRScene? = nil) {
		self.sceneGraph = sceneGraph
		self._nextMateriableIndex = 0
		self.sceneName = name
		self._currentScene = scene
	}
	
	public func createScene(transform: DKMTransform) -> Self {
		let newScene = DKRScene()
		
		self.sceneGraph.scene = newScene
		
		newScene.currentCamera.changeSize(transform.scale.x, transform.scale.y)
		
		return self
	}
	
	public func addMaterial(material: DKRMaterial) -> Self {
		let index = self._nextMateriableIndex
		if let scene = self._currentScene {
			scene.materials[index] = material
			self._nextMateriableIndex += 1
		}
		
		self._materialIndex = index
		
		return self
	}
	
	public func createDrawable(name: String, drawable: DKRDrawable) -> Self {
		return self.createDrawable(name, drawable: drawable, size: 1)
	}
	
	public func createDrawable(name: String, drawable: DKRDrawable, size: Int) -> Self {
		if let scene = self._currentScene {
			if let materialIndex = self._materialIndex {
				let material = scene.materials[materialIndex]!
				
				material.createDrawable(name, drawable: drawable, size: size)
			}
		}
		
		return self
	}
	
	public func addDrawableInstance(name: String, transform: DKMTransform) -> Int? {
		if let scene = self._currentScene {
			if let materialIndex = self._materialIndex {
				let material = scene.materials[materialIndex]!
				
				if let drawable = material.drawables[name] {
					sceneGraph.nodeCount += 1
					return drawable.addUModelBuffer(
						DKModelUniform(modelMatrix: transform.matrix4x4)
					)
				}
			}
		}
		
		return nil
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
	
	public func setTexture(textureName: String) -> Self {
		if let scene = self._currentScene {
			if let materialIndex = self._materialIndex {
				let material = scene.materials[materialIndex]!
				
				material.textureInstances[0] = DKRTextureInstance(
														index: 0,
														texture: DKRTexture(name: textureName)
													)
			}
		}
		
		return self
	}
}