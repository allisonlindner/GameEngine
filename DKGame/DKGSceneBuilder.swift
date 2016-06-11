//
//  DKGSceneBuilder.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKRender

public class DKGSceneBuilder {
	private var _scene: DKGScene?
	
	public func new(name: String) -> DKGSceneBuilder {
		_scene = DKGScene()
		
		DKGGameManager.instance.sManager.addScene(name, scene: _scene!)
		
		return self
	}
	
	public func create() -> DKGScene {
		if _scene == nil {
			fatalError("You must use 'new' function before creating scene")
		}
		
		return _scene!
	}
}