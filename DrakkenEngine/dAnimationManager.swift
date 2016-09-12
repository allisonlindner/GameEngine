//
//  dAnimationManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 01/09/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//


internal class dAnimationManager {
	private var _animations: [String: [String: dAnimation]] = [:]
	
	internal func create(animation name: String, _ data: dAnimation, on sprite: dSprite) {
		if sprite.parentTransform != nil {
			if var animations = _animations[sprite.spriteName] {
				animations[name] = data
			} else {
				_animations[sprite.spriteName] = [:]
				_animations[sprite.spriteName]![name] = data
			}
		}
	}
	
	internal func get(animation name: String, from sprite: dSprite) -> dAnimation? {
		if sprite.parentTransform != nil {
			return _animations[sprite.spriteName]?[name]
		} else {
			return nil
		}
	}
}
