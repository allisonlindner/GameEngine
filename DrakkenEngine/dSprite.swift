//
//  dSprite.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 25/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//


public class dSprite : dComponent {
	internal var meshRender: dMeshRender!
	
	public init(mesh name: String = "quad") {
		super.init()
		
		let meshRender = dMeshRender()
		self.meshRender = self.add(dependence: meshRender) as! dMeshRender
		
		self.meshRender.mesh = name
	}
	
	public func set(material: String) {
		self.meshRender.material = material
	}
}
