//
//  InspectorCellView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 20/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa
import Foundation

class ITransformCell: NSTableCellView, NSTextFieldDelegate {

    @IBOutlet weak var transformNameLabel: NSTextField!
    @IBOutlet weak var xpTF: NSTextField!
    @IBOutlet weak var ypTF: NSTextField!
    @IBOutlet weak var zpTF: NSTextField!
    
    @IBOutlet weak var xrTF: NSTextField!
    @IBOutlet weak var yrTF: NSTextField!
    @IBOutlet weak var zrTF: NSTextField!
    
    @IBOutlet weak var wsTF: NSTextField!
    @IBOutlet weak var hsTF: NSTextField!
    
    internal var transform: dTransform!
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        self.xpTF.delegate = self
        self.ypTF.delegate = self
        self.zpTF.delegate = self
        self.xrTF.delegate = self
        self.yrTF.delegate = self
        self.zrTF.delegate = self
        self.wsTF.delegate = self
        self.hsTF.delegate = self
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    @IBAction func xStepper(_ sender: NSStepper) {
        
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        let fieldEditor = obj.object as! NSTextField
        
        if fieldEditor.identifier == "posXID" {
            let x = fieldEditor.floatValue
            transform.Position.Set(x, transform.Position.y, transform.Position.z)
        } else if fieldEditor.identifier == "posYID" {
            let y = fieldEditor.floatValue
            transform.Position.Set(transform.Position.x, y, transform.Position.z)
        } else if fieldEditor.identifier == "posZID" {
            let z = fieldEditor.floatValue
            transform.Position.Set(transform.Position.x, transform.Position.y, z)
        } else if fieldEditor.identifier == "rotXID" {
            let x = fieldEditor.floatValue
            transform.Rotation.Set(x, transform.Rotation.y, transform.Rotation.z)
        } else if fieldEditor.identifier == "rotYID" {
            let y = fieldEditor.floatValue
            transform.Rotation.Set(transform.Rotation.x, y, transform.Rotation.z)
        } else if fieldEditor.identifier == "rotZID" {
            let z = fieldEditor.floatValue
            transform.Rotation.Set(transform.Rotation.x, transform.Rotation.y, z)
        } else if fieldEditor.identifier == "scaleWID" {
            let w = fieldEditor.floatValue
            transform.Scale.Set(w, transform.Scale.height)
        } else if fieldEditor.identifier == "scaleHID" {
            let h = fieldEditor.floatValue
            transform.Scale.Set(transform.Scale.width, h)
        }
    }
}
