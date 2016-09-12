//
//  DKRGameView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 25/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Foundation
import Metal
import MetalKit

internal class dGameViewDelegate: NSObject, MTKViewDelegate {
	typealias updateFunction = () -> Void
	
	private var _firstStep: Bool = true
	
	fileprivate var _updateFunction: updateFunction?
	fileprivate var _scene: dScene = dScene()
	
	private var simpleRender: dSimpleSceneRender!
	
	func start() {
		simpleRender = dSimpleSceneRender(scene: _scene)
	}
	
	func draw(in view: MTKView) {
		if view.device == nil {
			view.device =  dCore.instance.device
		}
		
		if _firstStep {
			self.mtkView(view, drawableSizeWillChange: view.drawableSize)
			_firstStep = false
		}
		
		if _updateFunction != nil {
			_updateFunction!()
		}
		
		if let currentDrawable = view.currentDrawable {
			if _scene.transforms.count > 0 {
				simpleRender.draw(drawable: currentDrawable)
			} else {
				let id = dCore.instance.renderer.startFrame(currentDrawable.texture)
				dCore.instance.renderer.endFrame(id)
				dCore.instance.renderer.present(currentDrawable)
			}
		}
	}
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		#if os(tvOS)
			self._scene.size = float2(1920.0, 1080.0)
		#else
			self._scene.size.x = Float(size.width)
			self._scene.size.y = Float(size.height)
		#endif
	}
}

open class dGameView: MTKView {
	private var _gameView: dGameViewDelegate!
	
	public var scene: dScene {
		get {
			return self._gameView._scene
		}
	}
	
	override public init(frame frameRect: CGRect, device: MTLDevice?) {
		super.init(frame: frameRect, device: dCore.instance.device)
		self._start()
	}
	
	required public init(coder: NSCoder) {
		super.init(coder: coder)
		self._start()
	}
	
	private func _start() {
		self.device = dCore.instance.device
		self.sampleCount = 4
		
		#if os(iOS) || os(watchOS) || os(tvOS)
			if #available(iOS 10.0, *) {
				self.colorPixelFormat = .bgra10_XR_sRGB
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#elseif os(OSX)
			if #available(OSX 10.12, *) {
				self.colorPixelFormat = .bgra8Unorm_srgb
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#else
			println("OMG, it's that mythical new Apple product!!!")
		#endif
		
		_gameView = dGameViewDelegate()
		_gameView._updateFunction = self.update
		
		self.start()
		_gameView.start()
		self.delegate = _gameView
	}
	
	open func update() {
		
	}
	
	open func start() {
		//Override this method to create your scene on startup
	}
}
