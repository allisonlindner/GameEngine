//
//  TransformMenu.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 10/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class TransformMenu: NSMenu {

    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    internal var selectedTransform: dTransform!
    
    @IBAction func deleteTransform(_ sender: Any) {
        selectedTransform.removeFromParent()
        
        appDelegate.editorViewController?.transformsView.reloadData()
        appDelegate.editorViewController?.editorView.Reload()
    }
}
