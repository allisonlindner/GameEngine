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
    
    @IBAction internal func newProject(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            let fileManager = FileManager()
            let savePanel = NSSavePanel()
            
            savePanel.begin(completionHandler: { (result) in
                if result == NSFileHandlingPanelOKButton {
                    if let url = savePanel.url {
                        do {
                            try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
                            
                            let assetsURL = url.appendingPathComponent("Assets", isDirectory: true)
                            let imagesURL = assetsURL.appendingPathComponent("images", isDirectory: true)
                            let scenesURL = assetsURL.appendingPathComponent("scenes", isDirectory: true)
                            let scriptsURL = assetsURL.appendingPathComponent("scripts", isDirectory: true)
                            
                            try fileManager.createDirectory(at: imagesURL,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                            try fileManager.createDirectory(at: scenesURL,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                            try fileManager.createDirectory(at: scriptsURL,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                            
                            var dictProject = [String: JSON]()
                            
                            dictProject["ROOT_PATH"] = JSON(url.path)
                            
                            let json = JSON(dictProject)
                            do {
                                let data = try json.rawData(options: JSONSerialization.WritingOptions.prettyPrinted)
                                let string = String(data: data, encoding: String.Encoding.utf8)
                                NSLog(string!)
                                
                                let projectSettingsFileURL = url.appendingPathComponent("project").appendingPathExtension("dksettings")
                                
                                if !fileManager.createFile(atPath: projectSettingsFileURL.path, contents: data, attributes: nil) {
                                    NSLog("Project file setting creation fail!")
                                    return
                                }
                                
                                dCore.instance.loadRootPath(url: url)
                                
                            } catch let error {
                                NSLog("JSON conversion FAIL!! \(error)")
                            }
                            
                        } catch let error {
                            NSLog("Project folders creationg fail: \(error)")
                        }
                    }
                }
            })
        }
    }
    
    @IBAction internal func openProject(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if self.contentViewController is EditorViewController {
                let editorVC = self.contentViewController as! EditorViewController
                let fileManager = FileManager()
                let openPanel = NSOpenPanel()
                
                openPanel.canChooseDirectories = true
                openPanel.canChooseFiles = false
                
                openPanel.begin(completionHandler: { (result) in
                    if result == NSFileHandlingPanelOKButton {
                        if let url = openPanel.urls.first {
                            
                            let projectSettingsFileURL = url.appendingPathComponent("project").appendingPathExtension("dksettings")
                            
                            if fileManager.displayName(atPath: projectSettingsFileURL.path) == "project.dksettings" {
                                NSLog("Is a project foldes")
                                dCore.instance.loadRootPath(url: url)
                                
                                do {
                                    let sceneURL = try fileManager.contentsOfDirectory(at: dCore.instance.SCENES_PATH!, includingPropertiesForKeys: nil,
                                                                                       options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
                                                                                            .union(FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)).first
                                    
                                    if sceneURL != nil {
                                        editorVC.editorView.scene.load(url: sceneURL!)
                                        editorVC.editorView.Init()
                                    }
                                } catch let error {
                                    NSLog("Fail while get first scene URL: \(error)")
                                }
                                
                                editorVC.fileViewer.setCurrentDirectory(url: dCore.instance.ROOT_PATH!)
                                editorVC.fileViewer.reloadPathData()
                            }
                        }
                    }
                })
            }
        }
    }
}
