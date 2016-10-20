//
//  InspectorView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 20/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class InspectorView: NSTableView {

    override func draw(_ dirtyRect: NSRect) {
        if self.tableColumns[0].width != superview!.frame.width - 2 {
            self.tableColumns[0].minWidth = superview!.frame.width - 2
            self.tableColumns[0].maxWidth = superview!.frame.width - 2
            self.tableColumns[0].width = superview!.frame.width - 2
        }
        
        super.draw(dirtyRect)
    }
}
