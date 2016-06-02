
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

internal class DKRRenderGraph {
	internal var scenes: [Int : DKRScene]
	internal var mainScene: Int?
	internal var screenSize: CGSize
	
	internal var screenChange: Bool
	
	internal init() {
		scenes = [:]
		screenChange = true
		screenSize = CGSizeMake(1920, 1080)
	}
}