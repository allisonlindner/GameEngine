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
    @IBOutlet weak var gameView: GameView!
    @IBOutlet weak var fileViewer: ProjectFolderView!
    @IBOutlet weak var transformsView: TransformsView!
    @IBOutlet weak var inspectorView: InspectorView!
    @IBOutlet weak var consoleView: ConsoleView!
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var editorGameTabView: NSTabView!
    
    internal var currentSceneURL: URL!
    
    internal var selectedFolderItem: FolderItem?
    internal var selectedTransform: dTransform?
    internal var selectedSpriteDef: URL?
    
    internal var lastLogCount = 0
    
    internal var draggedTransform: dTransform?
    internal var draggedScript: String?
    internal var draggedImage: String?
    internal var draggedSpriteDef: dSpriteDef?
    
    override func viewDidLoad() {
        (NSApplication.shared().delegate as! AppDelegate).editorViewController = self
        
        super.viewDidLoad()
        
        self.create(scene: "scene")
    }
    
    internal func create(scene: String) {
        editorView.scene = dScene()
        editorView.scene.name = scene
    }
    
    @IBAction func newTransform(_ sender: AnyObject?) {
        let transform = dTransform()
        transform.name = "GameObject"
        
        editorView.scene.add(transform: transform)
        
        transformsView.reloadData()
    }
    
    @IBAction func newScript(_ sender: AnyObject?) {
        let content = "function Start() {\n    \n}\n\nfunction Update() {\n    \n}"
        let fileManager = FileManager()
        
        if fileManager.createFile(atPath: dCore.instance.SCRIPTS_PATH!.appendingPathComponent("newScript.js").path,
                               contents: content.data(using: .utf8),
                               attributes: nil) {
            NSLog("New script created")
            fileViewer.reloadData()
        }
    }
    
    @IBAction func newSpriteDef(_ sender: AnyObject?) {
        if selectedFolderItem != nil {
            if NSImage(contentsOf: selectedFolderItem!.url) != nil {
                let spriteDef = dSpriteDef.init(selectedFolderItem!.name, columns: 1, lines: 1, texture: selectedFolderItem!.url.lastPathComponent)
                
                let fileManager = FileManager()
                
                let fileName = selectedFolderItem!.url.deletingPathExtension().lastPathComponent
                
                if let jsonData: Data = spriteDef.toData() {
                    fileManager.createFile(atPath: dCore.instance.SPRITES_PATH!.appendingPathComponent(fileName).appendingPathExtension("dksprite").path,
                                           contents: jsonData,
                                           attributes: nil)
                }
                
                self.fileViewer.reloadData()
                
                NSLog("Sprite save with success on path: \(dCore.instance.SPRITES_PATH!.appendingPathComponent(fileName).appendingPathExtension("dksprite").path)")
            }
        }
    }
}
