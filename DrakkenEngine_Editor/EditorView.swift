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
        if appDelegate.editorViewController?.lastLogCount != dCore.instance.allDebugLogs.count {
            appDelegate.editorViewController?.consoleView.reloadData()
        }
    }
    
    internal func checkChanges() {
        changed = false
        check(children: scene.root.childrenTransforms)
        
        if changed {
            appDelegate.editorViewController?.inspectorView.reloadData()
        }
    }
    
    private func check(children: [Int: dTransform]) {
        for transform in children {
            for component in transform.value.components {
                switch component {
                case is dJSScript:
                    let c = component as! dJSScript
                    changed = c.checkNeedReload()
                default:
                    break
                }
            }
            
            check(children: transform.value.childrenTransforms)
        }
    }
}
