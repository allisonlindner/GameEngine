//
//  InspectorView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 14/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

fileprivate let TRANSFORM_PASTEBOARD_TYPE = "drakkenengine.transforms_outline.transform_item"

class TransformsView: NSOutlineView, NSOutlineViewDataSource, NSOutlineViewDelegate, NSPasteboardItemDataProvider {

    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    var draggedTransform: dTransform?
    
    override func awakeFromNib() {
        setup()
    }
    
    private func setup() {
        self.dataSource = self
        self.delegate = self
        
        self.register(forDraggedTypes: [TRANSFORM_PASTEBOARD_TYPE])
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
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item != nil {
            if let i = item as? dTransform {
                return i.childrenTransforms.sorted(by: { (t1, t2) -> Bool in
                    if t1.key < t2.key {
                        return true
                    }
                    return false
                }).flatMap({ (transform) -> dTransform in
                    return transform.value
                }).count
            }
        }
        
        if let editorVC = appDelegate.editorViewController {
            return editorVC.editorView.scene.root.childrenTransforms.sorted(by: { (t1, t2) -> Bool in
                if t1.key < t2.key {
                    return true
                }
                return false
            }).flatMap({ (transform) -> dTransform in
                return transform.value
            }).count
        }
        
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item != nil {
            if let i = item as? dTransform {
                return i.childrenTransforms.sorted(by: { (t1, t2) -> Bool in
                    if t1.key < t2.key {
                        return true
                    }
                    return false
                }).flatMap({ (transform) -> dTransform in
                    return transform.value
                })[index]
            }
        }
        
        if let editorVC = appDelegate.editorViewController {
            return editorVC.editorView.scene.root.childrenTransforms.sorted(by: { (t1, t2) -> Bool in
                if t1.key < t2.key {
                    return true
                }
                return false
            }).flatMap({ (transform) -> dTransform in
                return transform.value
            })[index]
        }
        
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let i = item as? dTransform {
            return i.childrenTransforms.sorted(by: { (t1, t2) -> Bool in
                if t1.key < t2.key {
                    return true
                }
                return false
            }).flatMap({ (transform) -> dTransform in
                return transform.value
            }).count > 0
        }
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var text:String = ""
        var cellIdentifier: String = ""
        
        if let i = item as? dTransform {
            if tableColumn == outlineView.tableColumns[0] {
                text = i.name
                cellIdentifier = "TransformCellID"
            }
            
            if let cell = outlineView.make(withIdentifier: cellIdentifier, owner: nil) as? TTransformCell {
                cell.transform = i
                cell.textField?.stringValue = text
                return cell
            }
        }
        
        return nil
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        if let transform = item(atRow: selectedRow) as? dTransform {
            appDelegate.editorViewController?.selectedTransform = transform
            appDelegate.editorViewController?.inspectorView.reloadData()
        } else {
            appDelegate.editorViewController?.selectedTransform = nil
            appDelegate.editorViewController?.inspectorView.reloadData()
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, pasteboardWriterForItem item: Any) -> NSPasteboardWriting? {
        let pbItem = NSPasteboardItem()
        pbItem.setDataProvider(self, forTypes: [TRANSFORM_PASTEBOARD_TYPE])
        return pbItem
    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItems draggedItems: [Any]) {
        draggedTransform = draggedItems[0] as? dTransform
        session.draggingPasteboard.setData(Data(), forType: TRANSFORM_PASTEBOARD_TYPE)
    }
    
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        return .generic
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        if item == nil {
            draggedTransform!.parentTransform!.remove(child: draggedTransform!)
            appDelegate.editorViewController!.editorView.scene.add(transform: draggedTransform!)
            return true
        }
        
        if let transform = item as? dTransform {
            if draggedTransform!.has(child: transform) {
                return false
            }
            
            if draggedTransform != nil {
                if draggedTransform != transform {
                    if transform.parentTransform != nil {
                        draggedTransform!.parentTransform!.remove(child: draggedTransform!)
                        transform.add(child: draggedTransform!)
                        
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        draggedTransform = nil
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
    
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: String) {
        let s = "Outline Pasteboard Item"
        item.setString(s, forType: type)
    }
}
