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
	private var _renderer: DKRGraphRenderer!
	private var _sceneManager: DKRSceneManager!
	
	private var _firstStep: Bool = true
	
	func start() {
		_renderer = DKRSimpleRenderer()
		_sceneManager = DKRSceneManager(mainScene: "main")
	}
	
	func drawInMTKView(view: MTKView) {
		if view.device == nil {
			view.device =  DKRCore.instance.device
		}
		
		if _firstStep {
			_sceneManager.changeSize(Float(view.frame.width), Float(view.frame.height))
			
			_firstStep = false
		}
		
		if _sceneManager.sceneGraphs[_sceneManager.currentScene]!.scenes.count > 0 {
			if let currentDrawable = view.currentDrawable {
				DKRCore.instance.tManager.screenTexture = currentDrawable.texture
				
				_renderer.draw(_sceneManager.sceneGraphs[_sceneManager.currentScene]!)
				
				DKRCore.instance.renderer.present(currentDrawable)
			}
		}
	}
	
	func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
		_sceneManager.changeSize(Float(size.width), Float(size.height))
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
		
		_gameView = DKRGameView()
		_gameView.start()
		
		self.start()
		self.delegate = _gameView
	}
	
	public func start() {
		
	}
	
	public func createScene(name: String) {
		_gameView._sceneManager.sceneGraphs[name] = DKRSceneGraph()
	}
	
	public func builder(sceneName: String = "main") -> DKBSceneBuilder {
		let builder = DKBSceneBuilder(sceneGraph: &_gameView._sceneManager.sceneGraphs[sceneName]!)
		
		return builder
	}
	
	public func changeScene(name: String) {
		if _gameView._sceneManager.sceneGraphs[name] != nil {
			_gameView._firstStep = true
			_gameView._sceneManager.currentScene = name
		}
	}
}