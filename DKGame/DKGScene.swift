//
//  DKGScene.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKRender

public class DKGScene: DKGComponent {
	public var label: String?
	public var tag: String?
	
	public var transform: DKRTransform
	
	public var id: Int!
	
	internal var sceneGraph: DKRSceneGraph
	internal var components: [DKGComponent]
	
	internal init(label: String? = nil, tag: String? = nil) {
		self.transform = DKRTransform()
		self.components = []
		self.sceneGraph = DKRSceneGraph()
		
		self.label = label
		self.tag = tag
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