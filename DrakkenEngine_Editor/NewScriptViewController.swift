//
//  NewScriptViewController.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 26/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class NewScriptViewController: NSViewController {
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    @IBOutlet weak var scriptNameTF: NSTextField!

    @IBAction func newScript(_ sender: Any) {
        let content = "function Start() {\n    \n}\n\nfunction Update() {\n    \n}"
        let fileManager = FileManager()
        
        if fileManager.createFile(atPath: dCore.instance.SCRIPTS_PATH!.appendingPathComponent("\(scriptNameTF.stringValue).js").path,
                                  contents: content.data(using: .utf8),
                                  attributes: nil) {
            NSLog("New script created")
        }
        self.dismiss(self)
    }
}
