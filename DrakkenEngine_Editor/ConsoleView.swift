//
//  ConsoleView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 20/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class ConsoleView: NSTableView {

    override func draw(_ dirtyRect: NSRect) {
        if self.tableColumns[0].headerCell.controlView != nil {
            if self.tableColumns[0].headerCell.controlView!.frame.width != superview!.frame.width - 3 {
                self.tableColumns[0].headerCell.controlView!.setFrameSize(
                    NSSize(width: superview!.frame.width - 3,
                           height: self.tableColumns[0].headerCell.controlView!.frame.size.height)
                )
                self.tableColumns[0].sizeToFit()
            }
        }
        
        super.draw(dirtyRect)
    }
    
}
