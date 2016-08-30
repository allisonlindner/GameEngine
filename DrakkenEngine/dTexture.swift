//
//  DKRTextureManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 18/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import MetalKit

public class dTexture {
	private var _name: String
	private var _id: Int
	
	public var name: String {
		get {
			return self._name
		}
	}
	
	public var id: Int {
		get {
			return self._id
		}
	}
	
	public init(name: String, fileName: String, fileExtension ext: String = ".png") {
		self._name = name
		
		self._id = dCore.instance.tManager.create(name, fileName: fileName, fileExtension: ext)
	}
	
	public init(name: String) {
		self._name = name
		
		self._id = dCore.instance.tManager.getID(name)
	}
	
	public init(name: String, width: Int, height: Int) {
		self._name = name
		
		self._id = dCore.instance.tManager.createRenderTarget(name, width: width, height: height)
	}
	
	internal func getTexture() -> MTLTexture {
		return dCore.instance.tManager.getTexture(_id)
	}
}
