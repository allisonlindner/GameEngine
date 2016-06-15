//
//  DKRScene.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 12/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

public class DKRScene {
	internal var materials: [Int : DKRMaterial]
	internal var transform: DKRTransform?
	
	private var _cameras: [String : DKRCamera]
	private var _currentCamera: String
	
	private var _nextMaterialIndex: Int
	
	internal var currentCameraName: String {
		get {
			return self._currentCamera
		}
		set (cName) {
			if _cameras[cName] == nil {
				print("Camera with name '\(cName)' was not found!")
			} else {
				_currentCamera = cName
			}
		}
	}
	
	internal var currentCamera: DKRCamera {
		get {
			return _cameras[self.currentCameraName]!
		}
	}
	
	internal var renderTexture: MTLTexture? {
		get {
			return _cameras[_currentCamera]!.renderTexture
		}
	}
	
	internal func addMaterial(_ material: DKRMaterial) -> Int {
		if material.id == nil {
			let index = _nextMaterialIndex
			materials[index] = material
			_nextMaterialIndex += 1
			
			material.id = index
			return index
		}
		
		return material.id!
	}
	
	internal init() {
		materials = [:]
		_cameras = [:]
		
		_nextMaterialIndex = 0
		
		let camera = DKRCamera(
			name: "default",
			cameraPosition: (x: 0.0, y: 0.0, z: 200.0)
		)
		
		_currentCamera = "default"
		
		self.addCamera(name: "default", camera: camera)
	}
	
	internal func addCamera(name: String, camera: DKRCamera) {
		_cameras[name] = camera
	}
}
