//
//  GameViewTestTvOS.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 03/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import UIKit

class GameViewTestTvOS: GameViewTest {
	
	var sceneToggle = true
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if sceneToggle {
			changeScene("main2")
			sceneToggle = !sceneToggle
		} else {
			changeScene("main")
			sceneToggle = !sceneToggle
		}
	}
}