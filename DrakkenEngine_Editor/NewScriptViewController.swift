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
    
    @IBOutlet weak var startCB: NSButton!
    @IBOutlet weak var updateCB: NSButton!
    @IBOutlet weak var rightClickCB: NSButton!
    @IBOutlet weak var leftClickCB: NSButton!
    @IBOutlet weak var touchCB: NSButton!
    @IBOutlet weak var keyDownCB: NSButton!
    @IBOutlet weak var keyUpCB: NSButton!
    @IBOutlet weak var receiveMessageCB: NSButton!

    @IBAction func newScript(_ sender: Any) {
        if !scriptNameTF.stringValue.isEmpty {
            var content = ""
        
            if startCB.state == NSOnState {
                content += "function Start() {\n    //Call once on start game\n}\n"
            }
            
            if updateCB.state == NSOnState {
                content += "\nfunction Update() {\n    //Call every frame\n}\n"
            }
            
            if rightClickCB.state == NSOnState {
                content += "\nfunction RightClick(x, y) {\n    \n}\n"
            }
            
            if leftClickCB.state == NSOnState {
                content += "\nfunction LeftClick(x, y) {\n    \n}\n"
            }
            
            if touchCB.state == NSOnState {
                content += "\nfunction Touch(x, y) {\n    \n}\n"
            }
            
            if keyDownCB.state == NSOnState {
                content += "\nfunction KeyDown(keycode, modifier) {\n    \n}\n"
            }
            
            if keyUpCB.state == NSOnState {
                content += "\nfunction KeyUp(keycode, modifier) {\n    \n}\n"
            }
            
            if receiveMessageCB.state == NSOnState {
                content += "\nfunction ReceiveMessage(message) {\n    \n}\n"
            }
            
            let fileManager = FileManager()
            
            if fileManager.createFile(atPath: dCore.instance.SCRIPTS_PATH!.appendingPathComponent("\(scriptNameTF.stringValue).js").path,
                                      contents: content.data(using: .utf8),
                                      attributes: nil) {
                NSLog("New script created")
            }
            self.dismiss(self)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(self)
    }
}
