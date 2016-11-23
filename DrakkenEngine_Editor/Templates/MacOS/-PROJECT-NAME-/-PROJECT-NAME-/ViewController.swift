//
//  ViewController.swift
//  PROJECT_NAME
//
//  Created by Allison Lindner on 22/11/16.
//  Copyright © 2016 ORGANIZATION_NAME. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let gameView = self.view as! GameView
        
        gameView.load(projectURL: Bundle.main.url(forResource: "Assets", withExtension: nil)!.deletingLastPathComponent())
        gameView.load(scene: "-SCENE-NAME-")
        gameView.state = .PLAY
        
        gameView.Init()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

