//
//  dSceneController.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 01/09/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//


internal class dSceneController {
	private var _scene: dScene
	
	internal init(scene: dScene) {
		self._scene = scene
		self.process(transforms: scene.transforms)
	}
	
    private func process(transforms: [Int: dTransform]) {
		for transform in transforms {
			self.process(components: transform.value.components)
			self.process(transforms: transform.value.childrenTransforms)
		}
	}
	
	private func process(components: [dComponent]) {
		for component in components {
			switch component.self {
			case is dComponent:
				break
			default:
				break
			}
		}
	}
}
