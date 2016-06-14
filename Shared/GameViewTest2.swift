//
//  GameViewTest2.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 12/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import CoreGraphics
import DKGame
import DKRender

class GameViewTest2: DKGame {
	
	override func start() {
		let sceneBuilder = DKGSceneBuilder()
		let actorBuilder = DKGActorBuilder()
		
		let moveBehavior = MoveBehavior()

		let sprite = DKGSprite(name: "box", size: CGSizeMake(10, 10), fileName: "box", fileExtension: ".jpg")

		let box = actorBuilder.new()
							  .setSprite(sprite)
							  .create()
		
		box.set(position: CGPointMake(100.0, 0.0))
		box.addBehavior(moveBehavior)

		sceneBuilder.newScene("test01")
					.addActor(box)
					.create()
		
		super.start()
	}
}