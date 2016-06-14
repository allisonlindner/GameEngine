//
//  DKGActor.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 07/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import CoreGraphics
import DKMath
import DKRender

public class DKGActor: DKGComponent {
	public var label: String?
	public var tag: String?
	
	public var transform: DKRTransform
	
	public var id: Int!
	
	internal var behaviors: [DKGBehavior]
	internal var sprite: DKGSprite!
	
	internal init(label: String? = nil, tag: String? = nil) {
		self.behaviors = []
		self.transform = DKRTransform()
		
		self.label = label
		self.tag = tag
	}
	
	public func set(position position: CGPoint) {
		sprite.set(position: position)
	}
	
	public func set(zPosition z: Float) {
		sprite.set(zPosition: z)
	}
	
	public func set(scale scale: CGSize) {
		sprite.set(scale: scale)
	}
	
	public func set(zRotation z: Float) {
		sprite.set(zRotation: z)
	}
	
	public func addBehavior(behavior: DKGBehavior) {
		behavior.internalActor = self
		self.behaviors.append(behavior)
	}
	
	public func start() {
		for behavior in behaviors {
			behavior.start()
		}
	}
	
	public func update() {
		for behavior in behaviors {
			behavior.update()
		}
	}
}
