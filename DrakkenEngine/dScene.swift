//
//  dScene.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 26/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import simd

public class dScene {
	public var size: float2 = float2(1920.0, 1080.0)
	
	internal var transforms: [dTransform] = []
	
	public func add(transform: dTransform) {
		self.transforms.append(transform)
	}
}
