//
//  DKTextField.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 10/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class DKTextField: NSTextField {
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        NSLog("\(event?.buttonNumber)")
        
        return true
    }
    
    override func textShouldBeginEditing(_ textObject: NSText) -> Bool {
        return true
    }
}
