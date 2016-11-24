//
//  AppDelegate.swift
//  DrakkenEngine_Editor
//
//  Created by Allison Lindner on 10/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa
import DrakkenEngine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    internal var editorViewController: EditorViewController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        DrakkenEngine.Init()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

