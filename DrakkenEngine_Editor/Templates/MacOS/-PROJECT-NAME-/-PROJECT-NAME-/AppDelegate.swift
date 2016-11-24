//
//  AppDelegate.swift
//  PROJECT_NAME
//
//  Created by Allison Lindner on 22/11/16.
//  Copyright © 2016 ORGANIZATION_NAME. All rights reserved.
//

import Cocoa
import DrakkenEngine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        DrakkenEngine.Init()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

