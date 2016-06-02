//
//  DKRSceneCreator.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKMath

public protocol DKSceneBuilder {
	func createScene() -> DKScene
	func createScene(mainScene: Bool) -> DKScene
	func newTexture(name: String, fileName fName: String, fileExtension ext: String)
}

public protocol DKScene {
	func createScene(mainScene: Bool) -> DKScene
	func addMaterial(material: DKRMateriable) -> DKMaterial
}

public protocol DKMaterial {
	func addQuad(name: String, transform: DKMTransform) -> DKMaterial
	func setTexture(textureName: String) -> DKMaterial
}

public class DKBSceneBuilder: DKScene, DKMaterial, DKSceneBuilder {
	internal var renderGraph: DKRRenderGraph

	private var _nextMateriableIndex: Int
	private var _nextSceneIndex: Int
	private var _parentScene: Int?
	
	private var _sceneIndex: Int?
	private var _materialIndex: Int?

	internal init(renderGraph: DKRRenderGraph, nextMateriableIndex: Int = 0, nextSceneIndex: Int = 0) {
		self.renderGraph = renderGraph
		self._nextMateriableIndex = nextMateriableIndex
		self._nextSceneIndex = nextSceneIndex
	}
	
	public func createScene() -> DKScene {
		if self._parentScene  == nil {
			return self.createScene(true)
		} else {
			return self.createScene(false)
		}
	}
	
	public func createScene(mainScene: Bool) -> DKScene {
		let scene = DKRScene()
		
		if let parentScene = self._parentScene {
			//TODO Setup parent scene
		}
		
		let index = _nextSceneIndex
		self.renderGraph.scenes[index] = scene
		self._nextSceneIndex += 1
		
		if mainScene {
			self.renderGraph.mainScene = index
			scene.currentCamera.changeSize(Int(self.renderGraph.screenSize.width),
										   Int(self.renderGraph.screenSize.height))
		}
		
		let newSceneBuilder = DKBSceneBuilder(renderGraph: self.renderGraph,
		                               nextMateriableIndex: self._nextMateriableIndex,
		                               nextSceneIndex: self._nextSceneIndex)
		
		if self._sceneIndex != nil {
			newSceneBuilder._parentScene = self._sceneIndex
		}
		
		newSceneBuilder._sceneIndex = index
		
		return newSceneBuilder
	}
	
	public func addMaterial(material: DKRMateriable) -> DKMaterial {
		let index = self._nextMateriableIndex
		if let sceneIndex = self._sceneIndex {
			self.renderGraph.scenes[sceneIndex]!.materiables[index] = material
			self._nextMateriableIndex += 1
		}
		
		let newSceneBuilder = DKBSceneBuilder(renderGraph: self.renderGraph,
		                               nextMateriableIndex: self._nextMateriableIndex,
		                               nextSceneIndex: self._nextSceneIndex)
		newSceneBuilder._sceneIndex = self._sceneIndex
		newSceneBuilder._materialIndex = index
		
		return newSceneBuilder
	}
	
	public func addQuad(name: String, transform: DKMTransform) -> DKMaterial {
		if let sceneIndex = self._sceneIndex {
			if let materialIndex = self._materialIndex {
				let scene = self.renderGraph.scenes[sceneIndex]!
				var materiable = scene.materiables[materialIndex]!
				
				if let drawable = materiable.drawables[name] {
					drawable.addUModelBuffer(
						DKModelUniform(modelMatrix: transform.matrix4x4)
					)
				} else {
					materiable.drawables[name] = DKRDrawableInstance(drawable: DKRQuad())
					let drawable = materiable.drawables[name]!
					
					drawable.addUModelBuffer(
						DKModelUniform(modelMatrix: transform.matrix4x4)
					)
				}
			}
		}
		
		return self
	}
	
	public func newTexture(name: String, fileName fName: String, fileExtension ext: String) {
		_ = DKRTexture(name: name, fileName: fName, fileExtension: ext)
	}
	
	public func setTexture(textureName: String) -> DKMaterial {
		if let sceneIndex = self._sceneIndex {
			if let materialIndex = self._materialIndex {
				let scene = self.renderGraph.scenes[sceneIndex]!
				var materiable = scene.materiables[materialIndex]!
				
				materiable.textureInstances.append(
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