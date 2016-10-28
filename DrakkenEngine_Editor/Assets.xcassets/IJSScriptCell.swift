//
//  IJSScriptCellID.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class IJSScriptCell: NSTableCellView {

    @IBOutlet weak var jsFileNameTF: NSTextField!
    @IBOutlet weak var variablesTableView: JSScriptCellVariablesView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}
