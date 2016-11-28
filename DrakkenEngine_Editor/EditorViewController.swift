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
    
    internal var currentSceneURL: URL?
    
    internal var selectedFolderItem: FolderItem?
    internal var selectedTransform: dTransform?
    internal var selectedSpriteDef: URL?
    
    internal var lastLogCount = 0
    
    internal var draggedTransform: dTransform?
    internal var draggedScript: String?
    internal var draggedImage: String?
    internal var draggedSpriteDef: dSpriteDef?
    
    internal var projectOpen: Bool = false
    
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
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.title == "New Project" {
            return true
        }
        
        if menuItem.title == "Open Project" {
            return true
        }
        
        return projectOpen
    }
}
