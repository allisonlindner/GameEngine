//
//  ISpriteDefCellID.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 07/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class ISpriteDefCell: NSTableCellView, NSTextFieldDelegate {

    @IBOutlet weak var nameTF: NSTextField!
    @IBOutlet weak var columnsTF: NSTextField!
    @IBOutlet weak var linesTF: NSTextField!
    @IBOutlet weak var textureTF: NSTextField!
    @IBOutlet weak var scaleWTF: NSTextField!
    @IBOutlet weak var scaleHTF: NSTextField!
    @IBOutlet weak var textureImage: NSImageView!
    
    internal var spriteDef: dSpriteDef!
    internal var spriteDefURL: URL!
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        self.columnsTF.delegate = self
        self.linesTF.delegate = self
        self.scaleWTF.delegate = self
        self.scaleHTF.delegate = self
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        let fieldEditor = obj.object as! NSTextField
        
        if fieldEditor.identifier == "columnsID" {
            spriteDef.columns = fieldEditor.integerValue
        } else if fieldEditor.identifier == "linesID" {
            spriteDef.lines = fieldEditor.integerValue
        } else if fieldEditor.identifier == "scaleWID" {
            spriteDef.scale.Set(fieldEditor.floatValue, spriteDef.scale.height)
        } else if fieldEditor.identifier == "scaleHID" {
            spriteDef.scale.Set(spriteDef.scale.width, fieldEditor.floatValue)
        }
    }
    
    @IBAction func saveSpriteDef(_ sender: Any) {
        let fileManager = FileManager()
        
        if let jsonData: Data = spriteDef.toData() {
            fileManager.createFile(atPath: spriteDefURL.path,
                                   contents: jsonData,
                                   attributes: nil)
        }
        
        NSLog("Sprite save with success on path: \(spriteDefURL.path)")
    }
}
