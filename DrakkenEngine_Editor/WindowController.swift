//
//  WindowController.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 10/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
    }
    
    @IBAction internal func newScene(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if self.contentViewController is EditorViewController {
                let editorVC = self.contentViewController as! EditorViewController
                editorVC.create(scene: "scene01")
            }
        }
    }
    
    @IBAction internal func openScene(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if self.contentViewController is EditorViewController {
                let editorVC = self.contentViewController as! EditorViewController
                let openPanel = NSOpenPanel()
            
                openPanel.begin(completionHandler: { (result) in
                    if result == NSFileHandlingPanelOKButton {
                        if let url = openPanel.urls.first {
                            if url.pathExtension == "dkscene" {
                                editorVC.editorView.scene.load(url: url)
                                editorVC.editorView.Init()
                            }
                        }
                    }
                })
            }
        }
    }
    
    @IBAction internal func saveScene(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if self.contentViewController is EditorViewController {
                let editorVC = self.contentViewController as! EditorViewController
                let fileManager = FileManager()
                let savePanel = NSSavePanel()
                
                savePanel.begin(completionHandler: { (result) in
                    if result == NSFileHandlingPanelOKButton {
                        
                        if var url = savePanel.url {
                            if url.pathExtension != "dkscene" ||
                                url.pathExtension.isEmpty {
                                
                                url.appendPathExtension("dkscene")
                            }
                            
                            if let jsonData = editorVC.editorView.scene.toJSON() {
                                fileManager.createFile(atPath: url.path,
                                                       contents: jsonData,
                                                       attributes: nil)
                            }
                            
                            NSLog("Scene save with success on path: \(url.path)")
                        }
                    }
                })
            }
        }
    }
}
