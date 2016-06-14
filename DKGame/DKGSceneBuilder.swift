//
//  DKGSceneBuilder.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import CoreGraphics
import simd

public class DKGSceneBuilder {
	private var _scene: DKGScene?
	private var _name: String?
	
	public init() {
		
	}
	
	public func newScene(name: String) -> Self {
		_scene = DKGScene(name: name)
		_name = name
		
		return self
	}
	
	public func changeSize(size: CGSize) -> Self {
		_scene?.sceneGraph.changeSize(Float(size.width), Float(size.height))
		
		return self
	}
	
	public func addComponent(component: DKGComponent) -> Self {
		if _scene == nil {
			fatalError("You must use 'new' function before this")
		}

		_scene!.sceneGraph.nodeCount += 1
		_scene!.components.append(component)
		
		return self
	}
	
	public func addActor(actor: DKGActor) -> Self {
		if _scene == nil {
			fatalError("You must use 'new' function before this")
		}

		_scene!.sceneGraph.nodeCount += 1
		_scene!.components.append(actor)
		
		_scene!.sceneGraph.addMaterial(actor.sprite.material)
		
		return self
	}
	
	public func create() -> DKGScene {
		if _scene == nil {
			fatalError("You must use 'new' function before creating scene")
		}
		
		DKGGameManager.instance.sManager.addScene(_name!, scene: _scene!)
		
		return _scene!
	}
}