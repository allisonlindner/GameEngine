//
//  GameViewTest.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 03/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Cocoa

class GameViewTestOSX: GameViewTest {
	
	var sceneToggle = true
	
	override func mouseDown(theEvent: NSEvent) {
		if sceneToggle {
			changeScene("main2")
			sceneToggle = !sceneToggle
		} else {
			changeScene("main")
			sceneToggle = !sceneToggle
		}
	}
}