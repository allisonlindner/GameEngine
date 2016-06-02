//
//  GameViewTest.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 30/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKRender
import DKMath
import simd

class GameViewTest: DKGameView {

    override func start() {
		let scene = builder.createScene()
		
		let spriteMaterial = scene.addMaterial(DKRSpriteMaterial())
		
		builder.newTexture("box", fileName: "box", fileExtension: ".jpg")
		spriteMaterial.setTexture("box")
		
		let transform1 = DKMTransform()
		transform1.scale = float2(10.0, 10.0)
		
		spriteMaterial.addQuad("box", transform: transform1)
		
		transform1.position.x = 20.0
		transform1.position.y = 0.0
		spriteMaterial.addQuad("box", transform: transform1)
		
		transform1.position.x = -30.0
		transform1.position.y = 0.0
		spriteMaterial.addQuad("box", transform: transform1)
		
		transform1.position.x = 0.0
		transform1.position.y = -20.0
		spriteMaterial.addQuad("box", transform: transform1)
		
		transform1.position.x = 0.0
		transform1.position.y = 20.0
		spriteMaterial.addQuad("box", transform: transform1)
		
		transform1.position.x = 20.0
		transform1.position.y = 20.0
		spriteMaterial.addQuad("box", transform: transform1)
		
		transform1.position.x = 40.0
		transform1.position.y = 20.0
		spriteMaterial.addQuad("box", transform: transform1)
		
		transform1.position.x = -20.0
		transform1.position.y = 20.0
		spriteMaterial.addQuad("box", transform: transform1)
		
		transform1.position.x = -40.0
		transform1.position.y = 20.0
		spriteMaterial.addQuad("box", transform: transform1)
		
		
		let spriteMaterial2 = scene.addMaterial(DKRSpriteMaterial())
		spriteMaterial2.setTexture("box")
		
		transform1.scale = float2(10.0, 10.0)
		transform1.position.x = 100.0
		transform1.position.y = 100.0
		spriteMaterial2.addQuad("box", transform: transform1)
	}
}
