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
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var pauseButton: NSButton!
    @IBOutlet weak var editorGameTabView: NSTabView!
    
    internal var selectedTransform: dTransform?
    
    override func viewDidLoad() {
        (NSApplication.shared().delegate as! AppDelegate).editorViewController = self
        
        super.viewDidLoad()
        
        self.create(scene: "scene")
    }
    
    internal func create(scene: String) {
        editorView.scene = dScene()
        editorView.scene.name = scene
    }
}
