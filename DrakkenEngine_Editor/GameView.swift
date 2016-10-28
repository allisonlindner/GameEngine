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
//        self.scene.load(data: appDelegate.editorViewController!.editorView.scene.toJSON()!)
        self.scene = appDelegate.editorViewController!.editorView.scene
        self.scene.DEBUG_MODE = true
        self.state = .STOP
        super.Init()
    }
    
    override func internalUpdate() {
        appDelegate.editorViewController?.fileViewer.checkFolder()
        
        if appDelegate.editorViewController?.lastLogCount != dCore.instance.allDebugLogs.count {
            appDelegate.editorViewController?.consoleView.reloadData()
            appDelegate.editorViewController?.consoleView.scrollRowToVisible(dCore.instance.allDebugLogs.count - 1)
            appDelegate.editorViewController?.lastLogCount = dCore.instance.allDebugLogs.count
        }
    }
}
