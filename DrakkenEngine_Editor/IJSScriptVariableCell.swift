//
//  IJSScriptVariableCell.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 28/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class IJSScriptVariableCell: NSTableCellView, NSTextFieldDelegate {

    @IBOutlet weak var varNameLB: NSTextField!
    @IBOutlet weak var varValueTF: NSTextField!
    
    internal var variableKey: String!
    internal var script: dJSScript!
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        varValueTF.delegate = self
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        let fieldEditor = obj.object as! NSTextField
        
        let numFormatter = NumberFormatter()
        
        if let float = numFormatter.number(from: fieldEditor.stringValue)?.floatValue {
            script.set(float: float, for: variableKey)
        } else {
            script.set(string: fieldEditor.stringValue, for: variableKey)
        }
    }
}
