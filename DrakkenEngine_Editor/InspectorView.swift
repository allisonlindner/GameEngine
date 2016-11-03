//
//  InspectorView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 20/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class InspectorView: NSTableView, NSTableViewDataSource, NSTableViewDelegate {

    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        self.dataSource = self
        self.delegate = self
        
        self.selectionHighlightStyle = .none
        
        self.register(forDraggedTypes: [SCRIPT_PASTEBOARD_TYPE])
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
        if let transform = appDelegate.editorViewController?.selectedTransform {
            return 1 + transform.components.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return appDelegate.editorViewController?.selectedTransform
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if row == 0 {
            if let cell = tableView.make(withIdentifier: "ITransformCellID", owner: nil) as? ITransformCell {
                if let transform = appDelegate.editorViewController!.selectedTransform {
                    cell.transformNameLabel.stringValue = transform.name
                    
                    cell.xpTF.stringValue = transform.position.x.stringValue
                    cell.ypTF.stringValue = transform.position.y.stringValue
                    cell.zpTF.stringValue = transform.position.z.stringValue
                    
                    cell.xrTF.stringValue = transform.rotation.x.stringValue
                    cell.yrTF.stringValue = transform.rotation.y.stringValue
                    cell.zrTF.stringValue = transform.rotation.z.stringValue
                    
                    cell.wsTF.stringValue = transform.scale.width.stringValue
                    cell.hsTF.stringValue = transform.scale.height.stringValue
                    
                    cell.transform = transform
                    
                    return cell
                }
            }
        } else {
            if let transform = appDelegate.editorViewController?.selectedTransform {
                let component = transform.components[row-1]
                
                if component is dJSScript {
                    if let cell = tableView.make(withIdentifier: "IJSScriptCellID", owner: nil) as? IJSScriptCell {
                        cell.jsFileNameTF.stringValue = (component as! dJSScript).filename
                        cell.variablesTableView.script = component as? dJSScript
                        
                        cell.variablesTableView.reloadData()
                        
                        return cell
                    }
                } else if component is dSprite {
                    if let cell = tableView.make(withIdentifier: "ISpriteCellID", owner: nil) as? ISpriteCell {
                        cell.spriteNameTF.stringValue = (component as! dSprite).spriteName
                        
                        let sprite = dCore.instance.spManager.get(sprite: (component as! dSprite).spriteName)
                        let imageURL = dCore.instance.IMAGES_PATH!.appendingPathComponent(sprite!.texture.name)
                        
                        cell.image.image = NSImage(contentsOf: imageURL)
                        cell.frameTF.stringValue = "\((component as! dSprite).frame)"
                        
                        return cell
                    }
                } else if component is dMeshRender {
                    if let cell = tableView.make(withIdentifier: "IMeshRenderCellID", owner: nil) as? IMeshRenderCell {
                        cell.materialNameTF.stringValue = (component as! dMeshRender).material!
                        
                        return cell
                    }
                }
            }
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if row == 0 {
            return 200
        } else {
            if let transform = appDelegate.editorViewController?.selectedTransform {
                let component = transform.components[row-1]
                
                if component is dJSScript {
                    return 175
                } else if component is dSprite {
                    return 150
                } else if component is dMeshRender {
                    return 60
                }
            }
        }
        
        return 10
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        return .generic
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        if let transform = appDelegate.editorViewController!.selectedTransform {
            if appDelegate.editorViewController!.draggedScript != nil {
                transform._scene.DEBUG_MODE = false
                transform.add(script: appDelegate.editorViewController!.draggedScript!)
                endDragging()
                return true
            }
        }
        
        return false
    }
    
    private func endDragging() {
        appDelegate.editorViewController!.editorView.Reload()
        
        if appDelegate.editorViewController!.draggedScript != nil {
            appDelegate.editorViewController!.draggedScript = nil
            appDelegate.editorViewController!.inspectorView.reloadData()
        }
        
        reloadData()
        
        if self.tableColumns[0].headerCell.controlView != nil {
            if self.tableColumns[0].headerCell.controlView!.frame.width != superview!.frame.width - 5 {
                self.tableColumns[0].headerCell.controlView!.setFrameSize(
                    NSSize(width: superview!.frame.width - 5,
                           height: self.tableColumns[0].headerCell.controlView!.frame.size.height)
                )
                self.tableColumns[0].sizeToFit()
            }
        }
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        
    }
}
