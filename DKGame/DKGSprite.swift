//
//  DKGSprite.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 08/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import CoreGraphics

public class DKGSprite {
	internal var texture: DKRTexture
	internal var name: String
	
	internal var material: DKRSpriteMaterial
	internal var drawable: DKRDrawable
	
	public init(name: String, fileName: String, fileExtension ext: String) {
		//Create texture on texture manager
		texture = DKRTexture(name: fileName, fileName: fileName, fileExtension: ext)
		
		self.name = name
		
		material = DKRSpriteMaterial()
		drawable = DKRQuad()
		
		material.createDrawable(name, drawable: self.drawable)
		material.setTexture(fileName)
	}
	
	internal func addInstance(transform: DKRTransform) {
		material.addInstance(name, transform: transform)
	}
}