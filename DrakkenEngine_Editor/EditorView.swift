//
//  ViewController.swift
//  DrakkenEngine_Editor
//
//  Created by Allison Lindner on 10/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

internal class EditorView: dGameView {
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    override func Init() {
        self.state = .PAUSE
        super.Init()
    }
    
    override func update() {
        appDelegate.editorViewController?.fileViewer.checkFolder()
    }
}
