//
//  EditorViewController.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 10/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa
import Foundation

class EditorViewController: NSViewController {

    @IBOutlet weak var editorView: EditorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.create(scene: "scene")
    }
    
    @IBAction internal func newScene(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            self.create(scene: "scene")
        }
    }
    
    @IBAction internal func openScene(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            let openPanel = NSOpenPanel()
            
            openPanel.begin(completionHandler: { (result) in
                if result == NSFileHandlingPanelOKButton {
                    
                    if let url = openPanel.urls.first {
                        if url.pathExtension == "dkscene" {
                            self.editorView.load(sceneURL: url)
                        }
                    }
                }
            })
        }
    }
    
    @IBAction internal func saveScene(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            let fileManager = FileManager()
            let savePanel = NSSavePanel()
            
            savePanel.begin(completionHandler: { (result) in
                if result == NSFileHandlingPanelOKButton {
                    
                    if var url = savePanel.url {
                        if url.pathExtension != "dkscene" ||
                            url.pathExtension.isEmpty {
                            
                            url.appendPathExtension("dkscene")
                        }
                        
                        if let jsonData = dCore.instance.scManager.toJSON(scene: self.editorView.scene) {
                        
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
    
    internal func create(scene: String) {
        editorView.scene = dScene()
        editorView.scene.name = scene
    }
}
