//
//  InspectorVariableView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 28/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa
import JavaScriptCore

class JSScriptCellVariablesView: NSTableView, NSTableViewDelegate, NSTableViewDataSource {

    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    var script: dJSScript?
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        self.dataSource = self
        self.delegate = self
        
        self.selectionHighlightStyle = .none
    }
    
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
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if script != nil {
            return script!.publicVariables.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return appDelegate.editorViewController?.selectedTransform
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if script != nil {
            let variable = script!.publicVariables.map({ (variable) -> (String, JSValue?) in
                return (variable.key, variable.value)
            })[row]
            
            if let cell = tableView.make(withIdentifier: "IJSScriptVariableCellID", owner: nil) as? IJSScriptVariableCell {
                cell.varNameLB.stringValue = "\(variable.0):"
                cell.varValueTF.stringValue = variable.1!.toString()
                
                cell.variableKey = variable.0
                cell.script = script!
                
                return cell
            }
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
}
