//
//  ISpriteDefCellID.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 07/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class ISpriteDefCell: NSTableCellView {

    @IBOutlet weak var nameTF: NSTextField!
    @IBOutlet weak var columnsTF: NSTextField!
    @IBOutlet weak var linesTF: NSTextField!
    @IBOutlet weak var textureTF: NSTextField!
    @IBOutlet weak var textureImage: NSImageView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
