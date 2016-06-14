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
	
	func drawInMTKView(view: MTKView) {
		if view.device == nil {
			view.device =  DKRCore.instance.device
		}
		
		if _firstStep {
			DKRCore.instance.sManager.changeSize(Float(view.frame.width), Float(view.frame.height))
			
			_firstStep = false
		}
		
		if _updateFunction != nil {
			_updateFunction!()
		}
		
		if DKRCore.instance.sManager.sceneGraphs[DKRCore.instance.sManager.currentScene!] != nil {
			if let currentDrawable = view.currentDrawable {
				DKRCore.instance.tManager.screenTexture = currentDrawable.texture
				
				_renderer.draw(&DKRCore.instance.sManager.sceneGraphs[DKRCore.instance.sManager.currentScene!]!)
				
				DKRCore.instance.renderer.present(currentDrawable)
			}
		}
	}
	
	func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
		DKRCore.instance.sManager.changeSize(Float(size.width), Float(size.height))
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

public class DKGameRender: MTKView {
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
		
		_gameView = DKRGameView()
		_gameView.start()
		
		self.start()
		self.delegate = _gameView
	}
	
	public func start() {
		//Override this method to create your scene on startup
	}
	
	public func createScene(name: String) {
		var sceneGraph = DKRSceneGraph()
		DKRCore.instance.sManager.addScene(name, sceneGraph: &sceneGraph)
	}
	
	public func builder(sceneName: String) -> DKRSceneBuilder {
		let builder = DKRSceneBuilder(sceneGraph: &DKRCore.instance.sManager.sceneGraphs[sceneName]!, name: sceneName)
		
		return builder
	}
	
	public func changeScene(name: String) {
		if DKRCore.instance.sManager.sceneGraphs[name] != nil {
			_gameView._firstStep = true
			DKRCore.instance.sManager.currentScene = name
		}
	}
}