//
//  DKGSprite.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 08/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKRender

public class DKGSprite {
	internal var transform: DKRTransform
	
	private var _material: DKRSpriteMaterial
	private var _drawable: DKRQuad
	
	public init(name: String, texture: String) {
		//Create texture on texture manager
		_ = DKRTexture(name: texture)
		
		self.transform = DKRTransform()
		
		_material = DKRSpriteMaterial()
		_drawable = DKRQuad()
		
		_material.createDrawable(name, drawable: _drawable)
		
		_material.setTexture(texture)
	}
}