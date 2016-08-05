//
//  DKRCamera.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 12/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import simd

internal class DKRCamera {
	internal var transform: DKMTransform
	internal var fovy: Float
	
	private var width: Float
	private var height: Float
	
	private var _uCamera: DKCameraUniform!
	private var _uCameraBuffer: DKRBuffer<DKCameraUniform>!
	
	internal var uCameraBuffer: DKRBuffer<DKCameraUniform> {
		get {
			return _uCameraBuffer
		}
	}
	
	private var _renderTargetID: Int?
	
	internal var renderTexture: MTLTexture? {
		get {
			if let renderTargetID = _renderTargetID {
				return DKRCore.instance.tManager.getRenderTargetTexture(renderTargetID)
			} else {
				return DKRCore.instance.tManager.screenTexture
			}
		}
	}
	
	internal init(name: String,
	              cameraPosition: (x: Float, y: Float, z: Float),
	              fovy: Float = 60,
	              width: Float = 1920,
	              height: Float = 1080)
	{
		
		self.transform = DKMTransform()
		self.transform.position.x = cameraPosition.x
		self.transform.position.y = cameraPosition.y
		self.transform.position.z = cameraPosition.z
		
		self.fovy = fovy
		
		self.width = width
		self.height = height
		
		self._updateBuffer()
	}
	
	internal func changeSize(_ width: Float, _ height: Float) {
		self.width = width
		self.height = height
		
		_updateBuffer()
	}
	
	private func _updateBuffer() {
		//CAMERA UNIFORM CREATION
		let mView: float4x4 = DKMath.newTranslation(self.transform.position)
		
		let mProjection: float4x4 = DKMath.newOrtho(
					-self.width/2.0,
			right:	 self.width/2.0,
			bottom: -self.height/2.0,
			top:	 self.height/2.0,
			near:	-1000,
			far:	 1000
		)
		
		self._uCamera = DKCameraUniform(viewMatrix: mView, projectionMatrix: mProjection)
		self._uCameraBuffer = DKRBuffer(
			data: _uCamera,
			index: 0,
			bufferType: DKRBufferType.vertex,
			staticMode: false,
			offset: 0
		)
	}
}
