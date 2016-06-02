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
	private var _renderGraph: DKRRenderGraph!
	
	private var _firstStep: Bool = true
	
	func start() {
		_renderer = DKRSimpleRenderer()
		_renderGraph = DKRRenderGraph()
	}
	
	func drawInMTKView(view: MTKView) {
		if view.device == nil {
			view.device =  DKRCore.instance.device
		}
		
		if _firstStep {
			_renderGraph.screenChange = true
			_renderGraph.screenSize = view.frame.size
			
			_firstStep = false
		}
		
		if _renderGraph.scenes.count > 0 {
			if let currentDrawable = view.currentDrawable {
				DKRCore.instance.tManager.screenTexture = currentDrawable.texture
				
				_renderer.draw(_renderGraph)
				
				DKRCore.instance.renderer.present(currentDrawable)
			}
		}
	}
	
	func mtkView(view: MTKView, drawableSizeWillChange size: CGSize) {
		_renderGraph.screenChange = true
		_renderGraph.screenSize = size
	}
}

public class DKGameView: MTKView {
	private var _gameView: DKRGameView!
	
	public var builder: DKSceneBuilder!
	
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
		
		builder = DKBSceneBuilder(renderGraph: _gameView._renderGraph)
		
		self.start()
		self.delegate = _gameView
	}
	
	public func start() {
		
	}
}