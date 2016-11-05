//
//  IJSScriptCellID.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class IJSScriptCell: NSTableCellView {

    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    internal var script: dJSScript!
    
    @IBOutlet weak var jsFileNameTF: NSTextField!
    @IBOutlet weak var variablesTableView: JSScriptCellVariablesView!
    
    @IBAction func removeComponent(_ sender: Any) {
        script.removeFromParent()
        appDelegate.editorViewController?.inspectorView.reloadData()
        appDelegate.editorViewController!.editorView.Reload()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}
