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
    
    var timeToCheckChanges: Double = 1.0
    var changed = false
    
    override func Init() {
        self.changed = false
        self.state = .PAUSE
        self.type = .EDITOR
        super.Init()
    }
    
    override func internalUpdate() {
        checkChanges()
        
        if appDelegate.editorViewController?.lastLogCount != dCore.instance.allDebugLogs.count {
            appDelegate.editorViewController?.consoleView.reloadData()
        }
    }
    
    private func checkChanges() {
        changed = false
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
