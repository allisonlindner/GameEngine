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
        
        self.register(forDraggedTypes: [SCRIPT_PASTEBOARD_TYPE, IMAGE_PASTEBOARD_TYPE, SPRITEDEF_PASTEBOARD_TYPE])
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
        } else if appDelegate.editorViewController?.selectedSpriteDef != nil {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return appDelegate.editorViewController?.selectedTransform
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if row == 0 {
            if let transform = appDelegate.editorViewController?.selectedTransform {
                if let cell = tableView.make(withIdentifier: "ITransformCellID", owner: nil) as? ITransformCell {
                    cell.transformNameLabel.stringValue = transform.name
                    
                    cell.xpTF.floatValue = transform.position.x.floatValue
                    cell.ypTF.floatValue = transform.position.y.floatValue
                    cell.zpTF.floatValue = transform.position.z.floatValue
                    
                    cell.xrTF.floatValue = transform.rotation.x.floatValue
                    cell.yrTF.floatValue = transform.rotation.y.floatValue
                    cell.zrTF.floatValue = transform.rotation.z.floatValue
                    
                    cell.wsTF.floatValue = transform.scale.width.floatValue
                    cell.hsTF.floatValue = transform.scale.height.floatValue
                    
                    cell.transform = transform
                    
                    return cell
                }
            } else if let spriteDefURL = appDelegate.editorViewController?.selectedSpriteDef {
                if let cell = tableView.make(withIdentifier: "ISpriteDefCellID", owner: nil) as? ISpriteDefCell {
                    let spriteDef = dSpriteDef(json: spriteDefURL)
                    
                    cell.nameTF.stringValue = spriteDef.name
                    cell.columnsTF.integerValue = spriteDef.columns
                    cell.linesTF.integerValue = spriteDef.lines
                    cell.textureTF.stringValue = spriteDef.texture.name
                    
                    cell.scaleWTF.floatValue = spriteDef.scale.width
                    cell.scaleHTF.floatValue = spriteDef.scale.height
                    
                    let textureURL = dCore.instance.IMAGES_PATH?.appendingPathComponent(spriteDef.texture.name)
                    
                    cell.textureImage.image = NSImage(contentsOf: textureURL!)
                    
                    cell.spriteDef = spriteDef
                    cell.spriteDefURL = spriteDefURL
                    
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
                        
                        cell.script = component as! dJSScript
                        
                        return cell
                    }
                } else if component is dSprite {
                    if let cell = tableView.make(withIdentifier: "ISpriteCellID", owner: nil) as? ISpriteCell {
                        let sprite = (component as! dSprite)
                        
                        cell.sprite = sprite
                        
                        cell.spriteNameTF.stringValue = sprite.spriteName
                        
                        let spriteData = dCore.instance.spManager.get(sprite: sprite.spriteName)
                        let imageURL = dCore.instance.IMAGES_PATH!.appendingPathComponent(spriteData!.texture.name)
                        
                        cell.image.image = NSImage(contentsOf: imageURL)
                        cell.frameTF.intValue = (component as! dSprite).frame
                        
                        cell.wsTF.floatValue = sprite.meshRender.scale.width
                        cell.hsTF.floatValue = sprite.meshRender.scale.height
                        
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
            if appDelegate.editorViewController?.selectedTransform != nil {
                return 200
            } else if appDelegate.editorViewController?.selectedSpriteDef != nil {
                return 415
            }
        } else {
            if let transform = appDelegate.editorViewController?.selectedTransform {
                let component = transform.components[row-1]
                
                if component is dJSScript {
                    return 180
                } else if component is dSprite {
                    return 155
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
            } else if appDelegate.editorViewController!.draggedImage != nil {
                transform._scene.DEBUG_MODE = false
                
                transform.removeSprite()
                
                let spriteDef = dSpriteDef.init(appDelegate.editorViewController!.draggedImage!,
                                                texture: appDelegate.editorViewController!.draggedImage!)
                
                DrakkenEngine.Register(sprite: spriteDef)
                DrakkenEngine.Setup()
                
                transform.add(component: dSprite.init(
                    sprite: appDelegate.editorViewController!.draggedImage!,
                    scale: dSize2D(
                        Float(dTexture(appDelegate.editorViewController!.draggedImage!).getTexture().width),
                        Float(dTexture(appDelegate.editorViewController!.draggedImage!).getTexture().height))
                    )
                )
                
                endDragging()
                return true
            } else if let spriteDef = appDelegate.editorViewController!.draggedSpriteDef {
                transform._scene.DEBUG_MODE = false
                
                transform.removeSprite()
                
                DrakkenEngine.Register(sprite: spriteDef)
                DrakkenEngine.Setup()
                
                transform.add(component: dSprite(sprite: spriteDef.name, scale: spriteDef.scale, frame: 0))
                
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
        } else if appDelegate.editorViewController!.draggedImage != nil {
            appDelegate.editorViewController!.draggedImage = nil
            appDelegate.editorViewController?.inspectorView.reloadData()
        } else if appDelegate.editorViewController!.draggedSpriteDef != nil {
            appDelegate.editorViewController!.draggedSpriteDef = nil
            appDelegate.editorViewController?.inspectorView.reloadData()
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
