
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

internal class DKRSceneGraph {
	internal var scenes: [Int : DKRScene]
	internal var mainScene: Int?
	
	internal var screenChange: Bool = false
	internal var size: CGSize
	
	internal var nodeCount: Int
	
	internal init() {
		scenes = [:]
		size = CGSizeMake(1920.0, 1080.0)
		nodeCount = 0
	}
	
	internal func changeSize(width: Float, _ height: Float) {
		self.size.width = CGFloat(width)
		self.size.height = CGFloat(height)
		self.screenChange = true
	}
}