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
    
    var lastUpdate = NSDate().timeIntervalSince1970
    var deltaTime: Double = 0.016
    
    var timeToCheckChanges: Double = 1.0
    
    override func Init() {
        self.state = .PAUSE
        super.Init()
    }
    
    override func internalUpdate() {
        deltaTime = NSDate().timeIntervalSince1970 - lastUpdate
        lastUpdate = NSDate().timeIntervalSince1970
        
        if timeToCheckChanges <= 0.0 {
            appDelegate.editorViewController?.fileViewer.checkFolder()
            checkChanges()
            
            timeToCheckChanges = 1.0
        }
        
        timeToCheckChanges -= deltaTime
        
        if appDelegate.editorViewController?.lastLogCount != dCore.instance.allDebugLogs.count {
            appDelegate.editorViewController?.consoleView.reloadData()
        }
    }
    
    private func checkChanges() {
        var changed = false
        for transform in scene.root.childrenTransforms {
            for component in transform.value.components {
                switch component {
                case is dJSScript:
                    let c = component as! dJSScript
                    changed = c.checkNeedReload()
                default:
                    break
                }
            }
        }
        
        if changed {
            appDelegate.editorViewController?.inspectorView.reloadData()
        }
    }
}
