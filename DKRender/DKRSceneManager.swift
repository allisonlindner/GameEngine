//
//  DKRSceneManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 03/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Foundation

internal class DKRSceneManager {
	internal var sceneGraphs: [String : DKRSceneGraph]
	internal var currentScene: String
	
	internal init(mainScene: String) {
		sceneGraphs = [:]
		currentScene = mainScene
		
		sceneGraphs[mainScene] = DKRSceneGraph()
	}
	
	internal func changeSize(width: Float, _ height: Float) {
		sceneGraphs[currentScene]?.changeSize(width, height)
	}
}