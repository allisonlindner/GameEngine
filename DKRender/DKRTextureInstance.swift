//
//  DKRTextureInstance.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 19/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

public class DKRTextureInstance {
	internal var index: Int
	internal var texture: DKRTexture
	
	init(index: Int, texture: DKRTexture) {
		self.index = index
		self.texture = texture
	}
}