
//
//  DKRRenderGraph.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import MetalKit
import CoreGraphics

public class DKRSceneGraph {
	internal var scene: DKRScene
	
	internal var screenChange: Bool = false
	internal var size: CGSize
	
	public var nodeCount: Int
	
	public init() {
		scene = DKRScene()
		size = CGSizeMake(1920.0, 1080.0)
		nodeCount = 0
	}
	
	public func addMaterial(material: DKRMaterial) {
		scene.addMaterial(material)
	}
	
	public func changeSize(width: Float, _ height: Float) {
		scene.changeSize(width, height)
		
		self.size.width = CGFloat(width)
		self.size.height = CGFloat(height)
		self.screenChange = true
	}
}