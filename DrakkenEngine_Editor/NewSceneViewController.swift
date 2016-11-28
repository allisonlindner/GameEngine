//
//  NewSceneViewController.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 25/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class NewSceneViewController: NSViewController {

    @IBOutlet weak var sceneNameTF: NSTextField!
    internal var jsonData: Data?
    
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    @IBAction func saveScene(_ sender: Any) {
        let fileManager = FileManager()
        
        if !sceneNameTF.stringValue.isEmpty {
            if jsonData != nil {
                let url = dCore.instance.SCENES_PATH!.appendingPathComponent("\(sceneNameTF.stringValue).dkscene")
                fileManager.createFile(atPath: url.path,
                                       contents: jsonData,
                                       attributes: nil)
                NSLog("Scene save with success on path: \(url.path)")
                
                appDelegate.editorViewController?.currentSceneURL = url
                appDelegate.editorViewController?.editorView.scene.load(jsonFile: url.deletingPathExtension().lastPathComponent)
                
                self.dismiss(self)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(self)
    }
}
