//
//  DKGActor.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 07/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Foundation
import CoreGraphics

public class DKGActor: NSObject, DKGComponent, DKSActorExports {
	public var name: String
	public var label: String?
	public var tag: String?
	
	public var transform: DKMTransform
	
	public var id: Int!
	
	internal var behaviors: [DKGBehavior]
	public var sprite: DKGSprite!
	
	public var position: CGPoint {
		get {
			return CGPointMake(CGFloat(transform.position.x),
			                   CGFloat(transform.position.y))
		}
	}
	
	public var size: CGPoint {
		get {
			return CGPointMake(CGFloat(transform.scale.x),
			                   CGFloat(transform.scale.y))
		}
	}
	
	internal init(name: String, label: String? = nil, tag: String? = nil) {
		self.name = name
		self.behaviors = []
		self.transform = DKMTransform()
		
		self.label = label
		self.tag = tag
	}
	
	public func set(position position: CGPoint) {
		transform.position.x = Float(position.x)
		transform.position.y = Float(position.y)
	}
	
	public func set(zPosition z: Float) {
		transform.position.z = z
	}
	
	public func set(size scale: CGSize) {
		transform.scale.x = Float(scale.width)
		transform.scale.y = Float(scale.height)
	}
	
	public func set(zRotation z: Float) {
		transform.rotation.z = z
	}
	
	public func setPosition(x: NSNumber, _ y: NSNumber) {
		self.set(position: CGPoint(x: CGFloat(x.floatValue), y: CGFloat(y.floatValue)))
	}
	
	public func setZ(z: NSNumber) {
		self.set(zPosition: z.floatValue)
	}
	
	public func setSize(width: NSNumber, height: NSNumber) {
		self.set(size: CGSize(width: CGFloat(width.floatValue),
							 height: CGFloat(height.floatValue)))
	}
	
	public func setZRotation(z: NSNumber) {
		self.set(zRotation: z.floatValue)
	}
	
	public func addBehavior(behavior: DKGBehavior) {
		behavior.internalActor = self
		self.behaviors.append(behavior)
	}
	
	public func start() {
		for behavior in behaviors {
			behavior.start()
		}

		if let scripts = DKSScriptManager.instance.scripts[self.id] {
			for script in scripts {
				script.call(function: "start")
			}
		}
	}
	
	public func update() {
		for behavior in behaviors {
			behavior.update()
		}
		
		if let scripts = DKSScriptManager.instance.scripts[self.id] {
			for script in scripts {
				script.call(function: "update")
			}
		}
	}
}
