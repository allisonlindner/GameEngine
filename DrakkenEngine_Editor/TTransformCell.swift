//
//  TTransformCell.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 03/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class TTransformCell: NSTableCellView, NSTextFieldDelegate {
    
    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    internal var transform: dTransform!

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
            transform.name = textField.stringValue
        }
        
        appDelegate.editorViewController?.inspectorView.reloadData()
    }
}
