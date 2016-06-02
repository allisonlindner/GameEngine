//
//  DKRMateriable.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 18/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

public protocol DKRMateriable {
	var shader: DKRShader! { get set }
	var drawables: [String : DKRDrawableInstance] { get set }
	var textureInstances: [DKRTextureInstance] { get set }
	
	func getUniformBuffers() -> [DKBuffer]
}