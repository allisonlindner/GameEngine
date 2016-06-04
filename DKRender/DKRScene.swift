//
//  DKRScene.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 12/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import DKMath

public class DKRScene {
	internal var materiables: [Int : DKRMateriable]
	private var _cameras: [String : DKRCamera]
	private var _currentCamera: String
	
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
	
	internal init() {
		materiables = [:]
		_cameras = [:]
		
		let camera = DKRCamera(
			name: "default",
			cameraPosition: (x: 0.0, y: 0.0, z: 200.0)
		)
		
		_currentCamera = "default"
		
		addCamera("default", camera: camera)
	}
	
	internal func addCamera(name: String, camera: DKRCamera) {
		_cameras[name] = camera
	}
}
