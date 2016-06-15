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
	
	private var _fileName: String
	public var fileName: String {
		get {
			return self._fileName
		}
	}
	
	private var _fileExtension: String
	public var fileExtension: String {
		get {
			return self._fileExtension
		}
	}
	
	public init(name: String, fileName: String, fileExtension ext: String) {
		//Create texture on texture manager
		texture = DKRTexture(name: fileName, fileName: fileName, fileExtension: ext)
		
		self._fileName = fileName
		self._fileExtension = ext
		
		self.name = name
		
		material = DKRSpriteMaterial()
		drawable = DKRQuad()
		
		material.createDrawable(name: name, drawable: self.drawable)
		material.setTexture(name: fileName)
	}
	
	internal func addInstance(transform: DKRTransform) {
		material.addInstance(name: name, transform: transform)
	}
}
