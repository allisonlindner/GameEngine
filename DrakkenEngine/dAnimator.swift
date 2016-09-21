//
//  dAnimator.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 01/09/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

fileprivate class dAnimationState {
	internal var currentFrameId: Int = 0
	internal var timeStamp: Float = 0.0
}

public class dAnimator: dComponent {
	private var _sprite: dSprite
	private var _states: [String : dAnimationState] = [:]
	private var _defaultAnimation: String
	private var _currentAnimation: String
	private var _currentIndex: Int = 0
	
	internal var playing: Bool = false
	internal var frame: Int32 = 0
	
	internal init(sprite: dSprite, defaultAnimation: String) {
		self._sprite = sprite
		self._defaultAnimation = defaultAnimation
		self._currentAnimation = defaultAnimation
		
		for animation in self._sprite.animations {
			self._states[animation.key] = dAnimationState()
		}
		
		let sequence = _sprite.animations[_currentAnimation]!.sequence
		frame = sequence[_currentIndex].frame
		
		super.init()
	}
	
	internal func play() {
		playing = true
	}
	
	internal func stop() {
		playing = false
	}
	
	internal func update(deltaTime: Float) {
		if playing {
			let state = _states[_currentAnimation]
			let sequence = _sprite.animations[_currentAnimation]!.sequence
			
			state!.timeStamp += deltaTime
			
			if state!.timeStamp >= sequence[_currentIndex].time {
				_currentIndex += 1
				
				if _currentIndex >= sequence.count {
					_currentIndex = 0
				}
				
				state!.timeStamp = 0.0
			}
			
			frame = sequence[_currentIndex].frame
		} else {
			frame = _sprite.frame
		}
	}
	
	internal func set(animation name: String) {
		if _sprite.animations[name] != nil {
			self._currentAnimation = name
		} else {
			self._currentAnimation = _defaultAnimation
		}
	}
}
