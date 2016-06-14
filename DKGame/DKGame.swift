//
//  DKGame.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 12/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKRender
import Metal
import MetalKit

public class DKGame: DKGameView {
	
	public func present(sceneName: String) {
		DKGGameManager.instance.sManager.presentScene(sceneName)
	}
	
	public override func start() {
		if let scene = DKGGameManager.instance.sManager.currentScene {
//			NSLog("Scene count \(scene.sceneGraph.nodeCount)")
			scene.start()
		}
	}
	
	public override func update() {
		if let scene = DKGGameManager.instance.sManager.currentScene {
//			NSLog("Scene count \(scene.sceneGraph.nodeCount)")
			scene.update()
		}
	}
}