//
//  ISpriteCell.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class ISpriteCell: NSTableCellView {

    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var spriteNameTF: NSTextField!
    @IBOutlet weak var frameTF: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
