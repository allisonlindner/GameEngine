//
//  InspectorCellView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 20/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa
import Foundation

class ITransformCell: NSTableCellView {

    @IBOutlet weak var transformNameLabel: NSTextField!
    @IBOutlet weak var xpTF: NSTextField!
    @IBOutlet weak var ypTF: NSTextField!
    @IBOutlet weak var zpTF: NSTextField!
    
    @IBOutlet weak var xrTF: NSTextField!
    @IBOutlet weak var yrTF: NSTextField!
    @IBOutlet weak var zrTF: NSTextField!
    
    @IBOutlet weak var wsTF: NSTextField!
    @IBOutlet weak var hsTF: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    @IBAction func xStepper(_ sender: NSStepper) {
        
    }
}
