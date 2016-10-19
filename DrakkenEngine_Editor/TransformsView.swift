//
//  InspectorView.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 14/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

class TransformsView: NSOutlineView, NSOutlineViewDataSource, NSOutlineViewDelegate {

    let appDelegate = NSApplication.shared().delegate as! AppDelegate
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.dataSource = self
        self.delegate = self
        
//        doubleAction = #selector(self.doubleActionSelector)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
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
            return editorVC.editorView.scene.transforms.sorted(by: { (t1, t2) -> Bool in
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
            return editorVC.editorView.scene.transforms.sorted(by: { (t1, t2) -> Bool in
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
            
            if let cell = outlineView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = text
                return cell
            }
        }
        
        return nil
    }
}
