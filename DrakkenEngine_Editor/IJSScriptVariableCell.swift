//
//  IJSScriptVariableCell.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 28/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class IJSScriptVariableCell: NSTableCellView {

    @IBOutlet weak var varNameLB: NSTextField!
    @IBOutlet weak var varValueTF: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
