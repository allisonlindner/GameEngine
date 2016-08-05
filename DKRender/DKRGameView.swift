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

internal class DKRGameView: NSObject, MTKViewDelegate {
	typealias updateFunction = () -> Void
	
	private var _renderer: DKRGraphRenderer!
	private var _firstStep: Bool = true
	
	private var _updateFunction: updateFunction?
	
	func start() {
		_renderer = DKRSimpleRenderer()
	}
	
	func draw(in view: MTKView) {
		if view.device == nil {
			view.device =  DKRCore.instance.device
		}
		
		if _firstStep {
			self.mtkView(view, drawableSizeWillChange: view.drawableSize)
			_firstStep = false
		}
		
		if _updateFunction != nil {
			_updateFunction!()
		}
		
		if let currentScene = DKRCore.instance.sManager.currentScene {
			if DKRCore.instance.sManager.sceneGraphs[currentScene] != nil {
				if let currentDrawable = view.currentDrawable {
					DKRCore.instance.tManager.screenTexture = currentDrawable.texture
					
					_renderer.draw(&DKRCore.instance.sManager.sceneGraphs[DKRCore.instance.sManager.currentScene!]!)
					
					DKRCore.instance.renderer.present(currentDrawable)
				}
			}
		}
	}
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		#if os(tvOS)
			DKRCore.instance.sManager.changeSize(1920.0, 1080.0)
		#else
			DKRCore.instance.sManager.changeSize(Float(size.width), Float(size.height))
		#endif
	}
}

public class DKGameView: MTKView {
	private var _gameView: DKRGameView!
	
	override public init(frame frameRect: CGRect, device: MTLDevice?) {
		super.init(frame: frameRect, device: DKRCore.instance.device)
		self._start()
	}
	
	required public init(coder: NSCoder) {
		super.init(coder: coder)
		self._start()
	}
	
	private func _start() {
		self.device = DKRCore.instance.device
		self.sampleCount = 4
		
		#if os(iOS) || os(watchOS) || os(tvOS)
			if #available(iOS 10.0, *) {
				self.colorPixelFormat = .bgra10_XR_sRGB
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#elseif os(OSX)
			if #available(OSX 10.12, *) {
				self.colorPixelFormat = .bgra8Unorm_sRGB
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#else
			println("OMG, it's that mythical new Apple product!!!")
		#endif
		
		_gameView = DKRGameView()
		_gameView.start()
		_gameView._updateFunction = self.update
		
		self.start()
		self.delegate = _gameView
	}
	
	public func update() {
		
	}
	
	public func start() {
		//Override this method to create your scene on startup
	}
}
