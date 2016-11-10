//
//  ImageMenu.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 09/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class ImageMenu: NSMenu {

    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    internal var selectedFolderItem: FolderItem!
    
    @IBAction func newSpriteDef(_ sender: Any) {
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
                
                appDelegate.editorViewController?.fileViewer.reloadData()
                
                NSLog("Sprite save with success on path: \(dCore.instance.SPRITES_PATH!.appendingPathComponent(fileName).appendingPathExtension("dksprite").path)")
            }
        }
    }
}
