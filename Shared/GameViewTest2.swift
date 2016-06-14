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
		
		let sprite = DKGSprite(name: "box", fileName: "box", fileExtension: ".jpg")

		let box = actorBuilder.new()
							  .setSprite(sprite)
							  .create()
		
		box.set(position: CGPointMake(100.0, 0.0))
		box.set(size: CGSizeMake(10.0, 10.0))
		box.addBehavior(MoveBehavior())
		
		let box2 = actorBuilder.new()
							   .setSprite(sprite)
							   .create()
		
		box2.set(position: CGPointMake(-100.0, 20.0))
		box2.set(size: CGSizeMake(10.0, 10.0))
		box2.addBehavior(MoveBehavior())

		sceneBuilder.newScene("test01")
					.addActor(box)
					.addActor(box2)
					.create()
		
		super.start()
	}
}