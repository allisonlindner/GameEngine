//
//  PFolderItemCell.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 03/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class PFolderItemCell: NSTableCellView, NSTextFieldDelegate {
    
    internal var folderItem: FolderItem!
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        textField?.delegate = self
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            let fileManager = FileManager()
            
            var url = folderItem.url.deletingPathExtension().deletingLastPathComponent()
            url.appendPathComponent(textField.stringValue)
            
            do {
                try fileManager.moveItem(at: folderItem.url, to: url)
                folderItem.url = url
            } catch let error {
                NSLog("Renaming item fail. Error: \(error)")
            }
        }
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        if event?.buttonNumber == 1 {
            return true
        }
        return false
    }
}
