//
//  DKGSprite.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 08/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKRender
import CoreGraphics

public class DKGSprite {
	internal var transform: DKRTransform
	internal var texture: DKRTexture
	internal var name: String
	
	internal var material: DKRSpriteMaterial
	internal var drawable: DKRDrawable
	
	public init(name: String, size: CGSize, fileName: String, fileExtension ext: String) {
		//Create texture on texture manager
		let transform = DKRTransform(scaleX: Float(size.width), y: Float(size.height))
		
		texture = DKRTexture(name: fileName, fileName: fileName, fileExtension: ext)
		
		self.name = name
		self.transform = transform
		
		material = DKRSpriteMaterial()
		drawable = DKRQuad()
		
		material.createDrawable(name, drawable: self.drawable)
		material.addInstance(name, transform: self.transform)
		material.setTexture(fileName)
	}
	
	public func set(position position: CGPoint) {
		transform.position.x = Float(position.x)
		transform.position.y = Float(position.y)
	}
	
	public func set(zPosition z: Float) {
		transform.position.z = z
	}
	
	public func set(scale scale: CGSize) {
		transform.scale.x = Float(scale.width)
		transform.scale.y = Float(scale.height)
	}
	
	public func set(zRotation z: Float) {
		transform.rotation.z = z
	}
}