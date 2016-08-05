//
//  DKGSceneManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//


public class DKGSceneManager {
	internal var scenes: [String : DKGScene]
	private var _currentSceneName: String?
	
	internal var currentScene: DKGScene? {
		get {
			if let currentSceneName = self._currentSceneName {
				return scenes[currentSceneName]
			}
			return nil
		}
	}
	
	internal init() {
		self.scenes = [:]
	}
	
	internal func addScene(_ name: String, scene: DKGScene) {
		self.scenes[name] = scene

		DKRCore.instance.sManager.addScene(name, sceneGraph: &scene.sceneGraph)

		if _currentSceneName == nil {
			self._currentSceneName = name
			presentScene(name)
		}
	}

	public func presentScene(_ name: String) {
		if scenes[name] != nil {
			self._currentSceneName = name
			DKRCore.instance.sManager.presentScene(name)
		}
	}
}
