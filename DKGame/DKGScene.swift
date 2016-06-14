//
//  DKGScene.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKRender

public class DKGScene {
	public var transform: DKRTransform
	public var name: String
	
	internal var sceneGraph: DKRSceneGraph
	internal var components: [DKGComponent]
	
	internal init(name: String) {
		self.transform = DKRTransform()
		self.components = []
		self.sceneGraph = DKRSceneGraph()
		
		self.name = name
	}
	
	public func start() {
		for component in components {
			component.start()
		}
	}
	
	public func update() {
		for component in components {
			component.update()
		}
	}
}