//
//  ISpriteCell.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class ISpriteCell: NSTableCellView, NSTextFieldDelegate {

    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var spriteNameTF: NSTextField!
    @IBOutlet weak var frameTF: NSTextField!
    
    @IBOutlet weak var wsTF: NSTextField!
    @IBOutlet weak var hsTF: NSTextField!
    
    internal var sprite: dSprite!
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        self.wsTF.delegate = self
        self.hsTF.delegate = self
        self.frameTF.delegate = self
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        let fieldEditor = obj.object as! NSTextField
        
        if fieldEditor.identifier == "scaleWID" {
            let w = NSString(string: fieldEditor.stringValue).floatValue
            sprite.meshRender.scale.Set(w, sprite.meshRender.scale.height)
        } else if fieldEditor.identifier == "scaleHID" {
            let h = NSString(string: fieldEditor.stringValue).floatValue
            sprite.meshRender.scale.Set(sprite.meshRender.scale.width, h)
        } else if fieldEditor.identifier == "frameID" {
            let frame = NSString(string: fieldEditor.stringValue).intValue
            sprite.set(frame: Int32(frame))
            
            appDelegate.editorViewController!.editorView.Reload()
        }
    }
}
