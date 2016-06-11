//
//  DKGSceneManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKRender

internal class DKGSceneManager {
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
	
	internal func addScene(name: String, scene: DKGScene) {
		if _currentSceneName == nil {
			self._currentSceneName = name
		}
		
		self.scenes[name] = scene
	}
	
	internal func presentScene(name: String) {
		if scenes[name] != nil {
			self._currentSceneName = name
		}
	}
}