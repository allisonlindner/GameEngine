//
//  DKRGraphRenderer.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

internal protocol DKRGraphRenderer {
	func draw(graph: DKRSceneGraph)
}