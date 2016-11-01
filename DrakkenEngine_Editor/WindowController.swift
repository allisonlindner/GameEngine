//
//  WindowController.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 10/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    var sceneBackupJSON: JSON!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        appDelegate.editorViewController?.playButton.isEnabled = false
        appDelegate.editorViewController?.pauseButton.isEnabled = false
    }
    
    @IBAction internal func newScene(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if self.contentViewController is EditorViewController {
                let editorVC = self.contentViewController as! EditorViewController
                editorVC.create(scene: "scene01")
            }
        }
    }
    
    @IBAction internal func togglePlay(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if appDelegate.editorViewController?.playButton.state == NSOnState {
                self.sceneBackupJSON = appDelegate.editorViewController?.editorView.scene.root.toJSON()
                
                appDelegate.editorViewController?.gameView.Init()
                appDelegate.editorViewController?.gameView.state = .PLAY
                appDelegate.editorViewController?.editorGameTabView.selectTabViewItem(at: 1)
                
                appDelegate.editorViewController?.pauseButton.state = NSOffState
                appDelegate.editorViewController?.pauseButton.isEnabled = true
            } else if appDelegate.editorViewController?.playButton.state == NSOffState {
                appDelegate.editorViewController?.gameView.state = .STOP
                
                appDelegate.editorViewController?.editorView.scene.root.reloadWithoutScript(from: sceneBackupJSON)
                appDelegate.editorViewController?.editorView.state = .PAUSE
                appDelegate.editorViewController?.editorGameTabView.selectTabViewItem(at: 0)
                
                appDelegate.editorViewController?.pauseButton.state = NSOffState
                appDelegate.editorViewController?.pauseButton.isEnabled = false
                
                dCore.instance.allDebugLogs.removeAll()
            }
            
            appDelegate.editorViewController?.consoleView.reloadData()
        }
    }
    
    @IBAction internal func togglePause(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if appDelegate.editorViewController?.pauseButton.state == NSOnState {
                appDelegate.editorViewController?.gameView.state = .PAUSE
            } else if appDelegate.editorViewController?.pauseButton.state == NSOffState {
                appDelegate.editorViewController?.gameView.state = .PLAY
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
                            
                            if let jsonData: Data = editorVC.editorView.scene.toJSON() {
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
                            let spritesURL = assetsURL.appendingPathComponent("sprites", isDirectory: true)
                            let prefabsURL = assetsURL.appendingPathComponent("prefabs", isDirectory: true)
                            
                            try fileManager.createDirectory(at: imagesURL,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                            try fileManager.createDirectory(at: scenesURL,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                            try fileManager.createDirectory(at: scriptsURL,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                            try fileManager.createDirectory(at: spritesURL,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                            try fileManager.createDirectory(at: prefabsURL,
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
                                
                                //LOAD ALL TEXTURES
                                let imageFolderContent = try fileManager.contentsOfDirectory(at: dCore.instance.IMAGES_PATH!, includingPropertiesForKeys: nil,
                                                                                             options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
                                                                                                .union(FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants))
                                
                                for imageURL in imageFolderContent {
                                    if imageURL.isFileURL && NSImage(contentsOf: imageURL) != nil {
                                        _ = dTexture(imageURL.lastPathComponent)
                                    }
                                }
                                
                                let spritesFolderContent = try fileManager.contentsOfDirectory(at: dCore.instance.SPRITES_PATH!, includingPropertiesForKeys: nil,
                                                                                               options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
                                                                                                .union(FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants))
                                
                                //LOAD ALL SPRITES
                                for spriteURL in spritesFolderContent {
                                    if spriteURL.isFileURL && spriteURL.pathExtension == "dksprite" {
                                        var fileString: String = ""
                                        do {
                                            fileString = try String(contentsOf: spriteURL)
                                            if let dataFromString = fileString.data(using: String.Encoding.utf8) {
                                                let json = JSON(data: dataFromString)
                                                
                                                let name = json["name"].stringValue
                                                let columns = json["columns"].intValue
                                                let lines = json["lines"].intValue
                                                let texture = json["texture"].stringValue
                                                
                                                print("SPRITE - name: \(name), c: \(columns), l: \(lines), texture: \(texture)")
                                                
                                                let spriteDef = dSpriteDef(name, columns: columns, lines: lines, texture: texture)
                                                DrakkenEngine.Register(sprite: spriteDef)
                                            }
                                        } catch {
                                            fatalError("Scene file error")
                                        }
                                    }
                                }
                                DrakkenEngine.Init()
                                
                                let sceneURL = try fileManager.contentsOfDirectory(at: dCore.instance.SCENES_PATH!, includingPropertiesForKeys: nil,
                                                                                   options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
                                                                                        .union(FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)).first
                                
                                if sceneURL != nil {
                                    if let editorVC = self.appDelegate.editorViewController {
                                        editorVC.editorView.scene.load(url: sceneURL!)
                                        self.sceneBackupJSON = editorVC.editorView.scene.root.toJSON()
                                        editorVC.editorView.Init()
                                        
                                        editorVC.editorGameTabView.selectTabViewItem(at: 0)
                                        
                                        editorVC.playButton.isEnabled = true
                                        editorVC.pauseButton.isEnabled = false
                                        
                                        editorVC.inspectorView.reloadData()
                                    }
                                }
                            } catch let error {
                                fatalError("Fail while get first scene URL: \(error)")
                            }
                            
                            if let editorVC = self.appDelegate.editorViewController {
                                editorVC.fileViewer.loadData(for: dCore.instance.ROOT_PATH!)
                                editorVC.transformsView.reloadData()
                            }
                        }
                    }
                }
            })
        }
    }
}
