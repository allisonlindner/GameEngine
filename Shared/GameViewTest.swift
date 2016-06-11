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
		var scene = builder().createScene(DKRTransform(scaleX: Float(self.frame.width),
															y: Float(self.frame.height)))
		
		var spriteMaterial = scene.addMaterial(DKRSpriteMaterial())
		
		builder().newTexture("grid", fileName: "grid2", fileExtension: ".png")
		spriteMaterial.setTexture("grid")
		
		let transform = DKRTransform()
		transform.scale = float2(5.0, 5.0)
		
		let xUnits = 60
		let yUnits = 40
		
		spriteMaterial.createDrawable("quad", drawable: DKRQuad(), size: xUnits * yUnits)
		
		for x in 0..<xUnits {
			for y in 0..<yUnits {
				transform.position.x = -((Float(xUnits) * transform.scale.x)/2.0) + (Float(x) * transform.scale.x)
				transform.position.y = -((Float(yUnits) * transform.scale.y)/2.0) + (Float(y) * transform.scale.y)
				
				spriteMaterial.addDrawableInstance("quad", transform: transform)
			}
		}
		
		scene.finish()
		
		createScene("main2")
		scene = builder("main2").createScene(DKRTransform(scaleX: Float(self.frame.width),
															   y: Float(self.frame.height)))
		spriteMaterial = scene.addMaterial(DKRSpriteMaterial())
		
		builder().newTexture("box", fileName: "box", fileExtension: ".jpg")
		spriteMaterial.setTexture("box")
		
		spriteMaterial.createDrawable("quad", drawable: DKRQuad(), size: xUnits * yUnits)
		
		for x in 0..<xUnits {
			for y in 0..<yUnits {
				transform.position.x = -((Float(xUnits) * transform.scale.x)/2.0) + (Float(x) * transform.scale.x)
				transform.position.y = -((Float(yUnits) * transform.scale.y)/2.0) + (Float(y) * transform.scale.y)
				
				spriteMaterial.addDrawableInstance("quad", transform: transform)
			}
		}
		scene.finish()
	}
}