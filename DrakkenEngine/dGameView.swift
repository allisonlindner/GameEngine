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

public enum LOOPSTATE {
    case PLAY
    case PAUSE
    case STOP
}

public enum VIEWTYPE {
    case EDITOR
    case GAME
}

internal class dGameViewDelegate: NSObject, MTKViewDelegate {
	typealias updateFunction = () -> Void
    
	private var _firstStep: Bool = true
	
	fileprivate var _updateFunction: updateFunction?
    fileprivate var _internalUpdateFunction: updateFunction?
	fileprivate var _scene: dScene = dScene()
	
    fileprivate var simpleRender = dSimpleSceneRender()
    
    public var state: LOOPSTATE = .STOP
    public var type: VIEWTYPE = .GAME
    
    private var lastUpdate: Double = 0.0
    
	func start() {
		simpleRender.load(scene: _scene)
        simpleRender.start()
        _firstStep = true
	}
    
    func reload() {
        simpleRender.process()
        simpleRender.start()
    }
	
	func draw(in view: MTKView) {
        if _firstStep {
            self.mtkView(view, drawableSizeWillChange: view.drawableSize)
            if type == .GAME {
                _scene.time.deltaTime = 0.016
                lastUpdate = Date().timeIntervalSince1970
            }
            _firstStep = false
        } else {
            if type == .GAME {
                let currentTime: Double = Date().timeIntervalSince1970
                _scene.time.deltaTime = currentTime - lastUpdate
                lastUpdate = currentTime
            }
        }
        
        if view.device == nil {
            view.device =  dCore.instance.device
        }
        
        if state == LOOPSTATE.PLAY {
            if _updateFunction != nil {
                _updateFunction!()
            }
        }
        
        if _internalUpdateFunction != nil {
            _internalUpdateFunction!()
        }
        
        if state != LOOPSTATE.STOP {
            if let currentDrawable = view.currentDrawable {
                if _scene.root.childrenTransforms.count > 0 {
                    if state == LOOPSTATE.PLAY {
                        simpleRender.update(deltaTime: 0.016)
                    }
                    simpleRender.draw(drawable: currentDrawable)
                } else {
                    let id = dCore.instance.renderer.startFrame(currentDrawable.texture)
                    dCore.instance.renderer.endFrame(id)
                    dCore.instance.renderer.present(currentDrawable)
                }
            }
            
            setupSize()
        }
        
        if state == LOOPSTATE.STOP {
            setupSize()
            
            if let currentDrawable = view.currentDrawable {
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
    
    private func setupSize() {
        #if os(iOS)
            if Float(UIScreen.main.scale) != self._scene.scale {
                self._scene.scale = Float(UIScreen.main.scale)
            }
        #endif
        #if os(tvOS)
            if Float(UIScreen.main.scale) != self._scene.scale {
                self._scene.scale = Float(UIScreen.main.scale)
            }
        #endif
        #if os(OSX)
            if let scale = NSScreen.main()?.backingScaleFactor {
                if Float(scale) != self._scene.scale {
                    self._scene.scale = Float(scale)
                }
            }
        #endif
    }
}

open class dGameView: MTKView {
    private var _gameView: dGameViewDelegate!
    
    public var state: LOOPSTATE {
        get {
            return _gameView.state
        }
        set {
            _gameView.state = newValue
        }
    }
    
    public var type: VIEWTYPE {
        get {
            return _gameView.type
        }
        set {
            _gameView.type = newValue
        }
    }
	
	internal(set) public var scene: dScene {
		get {
			return self._gameView._scene
		}
        set {
            self._gameView._scene = newValue
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
		
		#if os(iOS)
			if #available(iOS 10.0, *) {
				self.colorPixelFormat = .bgra10_XR_sRGB
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#endif
		#if os(tvOS)
			if #available(tvOS 10.0, *) {
				self.colorPixelFormat = .bgra10_XR_sRGB
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#endif
		#if os(OSX)
			if #available(OSX 10.12, *) {
				self.colorPixelFormat = .bgra8Unorm_srgb
			} else {
				self.colorPixelFormat = .bgra8Unorm
			}
		#endif
		
		_gameView = dGameViewDelegate()
		_gameView._updateFunction = self.update
        _gameView._internalUpdateFunction = self.internalUpdate
	}
	
    public func load(scene: String) {
        self._gameView._scene.load(jsonFile: scene)
    }
    
    public func load(sceneURL: URL) {
        self._gameView._scene.load(url: sceneURL)
    }
    
    public func load(projectURL: URL) {
        dCore.instance.loadRootPath(url: projectURL)
    }
    
    public func Init() {
        self.start()
        _gameView.start()
        self.delegate = _gameView
    }
    
    public func Reload() {
        self.start()
        _gameView.reload()
    }
    
    internal func internalUpdate() {
        
    }
    
	open func update() {
		
	}
	
	open func start() {
		//Override this method to create your scene on startup
	}
    
    open override func keyDown(with event: NSEvent) {
        if type == .GAME {
            if state != .STOP {
                if state == .PLAY {
                    var modifier: UInt16? = nil
                    
                    if event.modifierFlags.contains(.command) {
                        modifier = KeyCode["Command"]!
                    } else if event.modifierFlags.contains(.shift) {
                        modifier = KeyCode["Shift"]!
                    } else if event.modifierFlags.contains(.capsLock) {
                        modifier = KeyCode["CapsLock"]!
                    } else if event.modifierFlags.contains(.option) {
                        modifier = KeyCode["Option"]!
                    } else if event.modifierFlags.contains(.control) {
                        modifier = KeyCode["Control"]!
                    }
                    
                    self._gameView.simpleRender.keyDown(event.keyCode, modifier)
                }
            }
        }
    }
    
    open override func keyUp(with event: NSEvent) {
        if type == .GAME {
            if state != .STOP {
                if state == .PLAY {
                    var modifier: UInt16? = nil
                    
                    if event.modifierFlags.contains(.command) {
                        modifier = KeyCode["Command"]!
                    } else if event.modifierFlags.contains(.shift) {
                        modifier = KeyCode["Shift"]!
                    } else if event.modifierFlags.contains(.capsLock) {
                        modifier = KeyCode["CapsLock"]!
                    } else if event.modifierFlags.contains(.option) {
                        modifier = KeyCode["Option"]!
                    } else if event.modifierFlags.contains(.control) {
                        modifier = KeyCode["Control"]!
                    }
                    
                    self._gameView.simpleRender.keyUp(event.keyCode, modifier)
                }
            }
        }
    }
    
    open override func mouseDown(with event: NSEvent) {
        if type == .GAME {
            if state != .STOP {
                var locationInView = NSApplication.shared().mainWindow!.contentView!.convert(event.locationInWindow, to: self)
                locationInView.x = locationInView.x - (self.frame.width/2.0)
                locationInView.y = locationInView.y - (self.frame.height/2.0)
                
                if state == .PLAY {
                    self._gameView.simpleRender.leftClick(Float(locationInView.x), Float(locationInView.y))
                }
            }
        }
    }
    
    open override func rightMouseDown(with event: NSEvent) {
        if type == .GAME {
            if state != .STOP {
                var locationInView = NSApplication.shared().mainWindow!.contentView!.convert(event.locationInWindow, to: self)
                locationInView.x = locationInView.x - (self.frame.width/2.0)
                locationInView.y = locationInView.y - (self.frame.height/2.0)
                
                if state == .PLAY {
                    self._gameView.simpleRender.rightClick(Float(locationInView.x), Float(locationInView.y))
                }
            }
        }
    }
    
    open override func touchesBegan(with event: NSEvent) {
        if type == .GAME {
            if state != .STOP {
                var locationInView = NSApplication.shared().mainWindow!.contentView!.convert(event.locationInWindow, to: self)
                locationInView.x = locationInView.x - (self.frame.width/2.0)
                locationInView.y = locationInView.y - (self.frame.height/2.0)
                
                if state == .PLAY {
                    self._gameView.simpleRender.touch(Float(locationInView.x), Float(locationInView.y))
                }
            }
        }
    }
    
    open override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
}
