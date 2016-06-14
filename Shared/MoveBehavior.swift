//
//  MoveBehavior.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 13/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import CoreGraphics
import DKGame

class MoveBehavior: DKGBehavior {
	var position: CGPoint!
	var direction: Int!
	
	override func start() {
		position = CGPointZero
		direction = 1
	}
	
	override func update() {
		position.x += CGFloat(direction)
		
		if position.x >= 100 {
			direction = -1
		}
		
		if position.x <= -100 {
			direction = 1
		}
		
		actor.set(position: position)
	}
}