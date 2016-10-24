//
//  GameView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 21/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class GameView: dGameView {
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    override func Init() {
        self.scene.load(data: appDelegate.editorViewController!.editorView.scene.toJSON()!)
        self.state = .STOP
        super.Init()
    }
}
