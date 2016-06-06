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
import Foundation

class GameViewTest: DKGameView {

	override func start() {
		var scene = builder().createScene(DKMTransform(scaleX: Float(self.frame.width),
															y: Float(self.frame.height)))
		
		var spriteMaterial = scene.addMaterial(DKRSpriteMaterial())
		
		builder().newTexture("grid", fileName: "grid2", fileExtension: ".png")
		spriteMaterial.setTexture("grid")
		
		let transform = DKMTransform()
		transform.scale = float2(2.0, 2.0)
		
		let xUnits = 170
		let yUnits = 110
		
		for x in 0..<xUnits {
			for y in 0..<yUnits {
				transform.position.x = -((Float(xUnits) * transform.scale.x)/2.0) + (Float(x) * transform.scale.x)
				transform.position.y = -((Float(yUnits) * transform.scale.y)/2.0) + (Float(y) * transform.scale.y)
				
				spriteMaterial.addQuad("box", transform: transform)
			}
		}
		
		scene.finish()
		
		createScene("main2")
		scene = builder("main2").createScene(DKMTransform(scaleX: Float(self.frame.width),
														y: Float(self.frame.height)))
		spriteMaterial = scene.addMaterial(DKRSpriteMaterial())
		
		builder().newTexture("box", fileName: "box", fileExtension: ".jpg")
		spriteMaterial.setTexture("box")
		
		for x in 0..<xUnits {
			for y in 0..<yUnits {
				transform.position.x = -((Float(xUnits) * transform.scale.x)/2.0) + (Float(x) * transform.scale.x)
				transform.position.y = -((Float(yUnits) * transform.scale.y)/2.0) + (Float(y) * transform.scale.y)
				
				spriteMaterial.addQuad("box", transform: transform)
			}
		}
		scene.finish()
	}
}
