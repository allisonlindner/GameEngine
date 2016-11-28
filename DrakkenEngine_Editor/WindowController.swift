//
//  WindowController.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 10/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

internal enum dExportType {
    case MacOS
    case iOS
    case tvOS
}

class WindowController: NSWindowController {
    
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    var fileWatcher: SwiftFSWatcher!
    
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
                
                editorVC.transformsView.reloadData()
                editorVC.inspectorView.reloadData()
                editorVC.currentSceneURL = nil
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
                
                self.window?.makeFirstResponder(appDelegate.editorViewController?.gameView)
            } else if appDelegate.editorViewController?.playButton.state == NSOffState {
                appDelegate.editorViewController?.gameView.state = .STOP
                
                appDelegate.editorViewController?.editorView.scene.root.reloadWithoutScript(from: sceneBackupJSON)
                appDelegate.editorViewController?.editorView.state = .PAUSE
                appDelegate.editorViewController?.editorView.scene.DEBUG_MODE = false
                appDelegate.editorViewController?.editorGameTabView.selectTabViewItem(at: 0)
                
                appDelegate.editorViewController?.pauseButton.state = NSOffState
                appDelegate.editorViewController?.pauseButton.isEnabled = false
                
                dCore.instance.allDebugLogs.removeAll()
                
                appDelegate.editorViewController?.inspectorView.reloadData()
                
                self.window?.makeFirstResponder(self.window)
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
    
    @IBAction internal func newScript(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if self.contentViewController is EditorViewController {
                let storyboard = NSStoryboard.init(name: "Main", bundle: Bundle.main)
                let newSceneView = storyboard.instantiateController(withIdentifier: "NewScriptID") as! NewScriptViewController
                
                self.appDelegate.editorViewController?.presentViewControllerAsSheet(newSceneView as NSViewController)
            }
        }
    }
    
    @IBAction internal func saveSceneAs(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if self.contentViewController is EditorViewController {
                let editorVC = self.contentViewController as! EditorViewController
                
                if let jsonData: Data = editorVC.editorView.scene.toData() {
                    let storyboard = NSStoryboard.init(name: "Main", bundle: Bundle.main)
                    let newSceneView = storyboard.instantiateController(withIdentifier: "NewSceneID") as! NewSceneViewController
                    newSceneView.jsonData = jsonData
                    
                    self.appDelegate.editorViewController?.presentViewControllerAsSheet(newSceneView as NSViewController)
                }
            }
        }
    }
    
    @IBAction internal func saveScene(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            if self.contentViewController is EditorViewController {
                let editorVC = self.contentViewController as! EditorViewController
                let fileManager = FileManager()
                
                if let jsonData: Data = editorVC.editorView.scene.toData() {
                    if editorVC.currentSceneURL != nil {
                        fileManager.createFile(atPath: editorVC.currentSceneURL!.path,
                                               contents: jsonData,
                                               attributes: nil)
                        NSLog("Scene save with success on path: \(editorVC.currentSceneURL!.path)")
                    } else {
                        let storyboard = NSStoryboard.init(name: "Main", bundle: Bundle.main)
                        let newSceneView = storyboard.instantiateController(withIdentifier: "NewSceneID") as! NewSceneViewController
                        newSceneView.jsonData = jsonData
                        
                        appDelegate.editorViewController?.presentViewControllerAsSheet(newSceneView as NSViewController)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction internal func newProject(_ sender: AnyObject?) {
        if becomeFirstResponder() {
            let fileManager = FileManager()
            let savePanel = NSSavePanel()
            
            savePanel.beginSheetModal(for: self.window!, completionHandler: { (result) in
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
                                
                                if let editorVC = self.appDelegate.editorViewController {
                                    editorVC.editorView.scene.load(url: url)
                                    self.sceneBackupJSON = editorVC.editorView.scene.root.toJSON()
                                    editorVC.editorView.Init()
                                    
                                    editorVC.editorGameTabView.selectTabViewItem(at: 0)
                                    
                                    editorVC.playButton.isEnabled = true
                                    editorVC.pauseButton.isEnabled = false
                                    
                                    editorVC.inspectorView.reloadData()
                                }
                                
                                if let editorVC = self.appDelegate.editorViewController {
                                    editorVC.inspectorView.reloadData()
                                    editorVC.transformsView.reloadData()
                                    editorVC.editorView.Reload()
                                    editorVC.fileViewer.loadData(for: dCore.instance.ROOT_PATH!)
                                    editorVC.transformsView.reloadData()
                                }
                                
                                self.fileWatcher = SwiftFSWatcher([url.path])
                                self.fileWatcher.watch({ (fileEvent) in
                                    self.appDelegate.editorViewController?.fileViewer.loadData(for: dCore.instance.ROOT_PATH!)
                                    self.appDelegate.editorViewController?.editorView.checkChanges()
                                })
                                
                                self.appDelegate.editorViewController!.projectOpen = true
                                
                                DrakkenEngine.Setup()
                                
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
            
            openPanel.beginSheetModal(for: self.window!, completionHandler: { (result) in
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
                                    self.appDelegate.editorViewController!.currentSceneURL = sceneURL
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
                            
                            self.fileWatcher = SwiftFSWatcher([url.path])
                            self.fileWatcher.watch({ (fileEvent) in
                                self.appDelegate.editorViewController?.fileViewer.loadData(for: dCore.instance.ROOT_PATH!)
                                self.appDelegate.editorViewController?.editorView.checkChanges()
                            })
                            
                            self.appDelegate.editorViewController!.projectOpen = true
                        }
                    }
                }
            })
        }
    }
    
    @IBAction internal func exportProject_macOS(_ sender: AnyObject?) {
        let savePanel = NSSavePanel()
        
        savePanel.beginSheetModal(for: self.window!, completionHandler: { (result) in
            if result == NSFileHandlingPanelOKButton {
                if let url = savePanel.url {
                    self.exportProject(to: url, as: .MacOS)
                }
            }
        })
    }
    
    @IBAction internal func exportProject_iOS(_ sender: AnyObject?) {
        let savePanel = NSSavePanel()
        
        savePanel.beginSheetModal(for: self.window!, completionHandler: { (result) in
            if result == NSFileHandlingPanelOKButton {
                if let url = savePanel.url {
                    self.exportProject(to: url, as: .iOS)
                }
            }
        })
    }
    
    internal func exportProject(to url: URL, as type: dExportType) {
        let fileManager = FileManager()
        
        var templateURL: URL?
        
        if type == .MacOS {
            templateURL = Bundle.main.url(forResource: "Templates", withExtension: nil)!.appendingPathComponent("MacOS/-PROJECT-NAME-")
        } else if type == .iOS {
            templateURL = Bundle.main.url(forResource: "Templates", withExtension: nil)!.appendingPathComponent("iOS/-PROJECT-NAME-")
        } else {
            templateURL = nil
        }
        
        if templateURL != nil {
            do {
                if appDelegate.editorViewController!.currentSceneURL != nil {
                    try fileManager.copyItem(at: templateURL!, to: url)
                    
                    try fileManager.moveItem(at: url.appendingPathComponent("-PROJECT-NAME-"),
                                             to: url.appendingPathComponent(url.lastPathComponent))
                    
                    try fileManager.moveItem(at: url.appendingPathComponent("-PROJECT-NAME-").appendingPathExtension("xcodeproj"),
                                             to: url.appendingPathComponent(url.lastPathComponent).appendingPathExtension("xcodeproj"))
                    
                    try fileManager.copyItem(at: dCore.instance.ROOT_PATH!,
                                             to: url.appendingPathComponent(url.lastPathComponent).appendingPathComponent("Assets"))
                    
                    let xcodeprojURL = url.appendingPathComponent(url.lastPathComponent).appendingPathExtension("xcodeproj")
                    var pbxprojString = try String(contentsOf: xcodeprojURL.appendingPathComponent("project.pbxproj"))
                    
                    var regex = try NSRegularExpression(pattern: "(-PROJECT-NAME-)", options: .caseInsensitive)
                    pbxprojString = regex.stringByReplacingMatches(in: pbxprojString,
                                                                   options: [],
                                                                   range: NSRange(0..<pbxprojString.utf8.count),
                                                                   withTemplate: url.lastPathComponent)
                    
                    try fileManager.removeItem(at: xcodeprojURL.appendingPathComponent("project.pbxproj"))
                    fileManager.createFile(atPath: xcodeprojURL.appendingPathComponent("project.pbxproj").path,
                                           contents: pbxprojString.data(using: .utf8), attributes: nil)
                    
                    var xcworkspacedataString = try String(contentsOf: xcodeprojURL.appendingPathComponent("project.xcworkspace/contents.xcworkspacedata"))
                    regex = try NSRegularExpression(pattern: "(location\\s\\=\\s\")(.*)(\")", options: .caseInsensitive)
                    
                    let matches = regex.matches(in: xcworkspacedataString, options: [], range: NSRange(0..<xcworkspacedataString.utf8.count))
                    
                    for m in matches {
                        xcworkspacedataString = String((xcworkspacedataString as NSString).replacingCharacters(in: m.rangeAt(2), with: xcodeprojURL.path))
                    }
                    
                    try fileManager.removeItem(at: xcodeprojURL.appendingPathComponent("project.xcworkspace/contents.xcworkspacedata"))
                    fileManager.createFile(atPath: xcodeprojURL.appendingPathComponent("project.xcworkspace/contents.xcworkspacedata").path,
                                           contents: xcworkspacedataString.data(using: .utf8), attributes: nil)
                    
                    try fileManager.moveItem(at: xcodeprojURL.appendingPathComponent("xcuserdata/username.xcuserdatad"),
                                             to: xcodeprojURL.appendingPathComponent("xcuserdata/\(NSUserName()).xcuserdatad"))
                    
                    try fileManager.moveItem(at: xcodeprojURL.appendingPathComponent("xcuserdata/\(NSUserName()).xcuserdatad/xcschemes/-PROJECT-NAME-.xcscheme"),
                                             to: xcodeprojURL.appendingPathComponent("xcuserdata/\(NSUserName()).xcuserdatad/xcschemes/\(url.lastPathComponent).xcscheme"))
                    
                    regex = try NSRegularExpression(pattern: "(-PROJECT-NAME-)", options: .caseInsensitive)
                    var schemeString = try String(contentsOf: xcodeprojURL.appendingPathComponent("xcuserdata/\(NSUserName()).xcuserdatad/xcschemes/\(url.lastPathComponent).xcscheme"))
                    schemeString = regex.stringByReplacingMatches(in: schemeString,
                                                                  options: [],
                                                                  range: NSRange(0..<schemeString.utf8.count),
                                                                  withTemplate: url.lastPathComponent)
                    
                    try fileManager.removeItem(at: xcodeprojURL.appendingPathComponent("xcuserdata/\(NSUserName()).xcuserdatad/xcschemes/\(url.lastPathComponent).xcscheme"))
                    fileManager.createFile(atPath: xcodeprojURL.appendingPathComponent("xcuserdata/\(NSUserName()).xcuserdatad/xcschemes/\(url.lastPathComponent).xcscheme").path,
                                           contents: schemeString.data(using: .utf8), attributes: nil)
                    
                    regex = try NSRegularExpression(pattern: "(-SCENE-NAME-)", options: .caseInsensitive)
                    var viewcontrollerString = try String(contentsOf: xcodeprojURL.deletingLastPathComponent().appendingPathComponent(url.lastPathComponent).appendingPathComponent("ViewController.swift"))
                    viewcontrollerString = regex.stringByReplacingMatches(in: viewcontrollerString,
                                                                          options: [],
                                                                          range: (viewcontrollerString as NSString).range(of: viewcontrollerString),
                                                                          withTemplate: appDelegate.editorViewController!.currentSceneURL!.deletingPathExtension().lastPathComponent)
                    
                    try fileManager.removeItem(at: xcodeprojURL.deletingLastPathComponent().appendingPathComponent(url.lastPathComponent).appendingPathComponent("ViewController.swift"))
                    fileManager.createFile(atPath: xcodeprojURL.deletingLastPathComponent().appendingPathComponent(url.lastPathComponent).appendingPathComponent("ViewController.swift").path,
                                           contents: viewcontrollerString.data(using: .utf8), attributes: nil)
                }
            } catch let error {
                NSLog("\(error)")
            }
        }
    }
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.title == "New Project" {
            return true
        }
        
        if menuItem.title == "Open Project" {
            return true
        }
            
        return appDelegate.editorViewController!.projectOpen
    }
}
