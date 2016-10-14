//
//  FileViewerController.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 14/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Cocoa

internal struct Directory {
    var icon: NSImage
    var name: String
    var url: URL
}

class FileViewerController: NSTableView, NSTableViewDelegate, NSTableViewDataSource {
    var items: [Directory] = []
    private var currentDirectory: URL?
    private var stackOfDirectories: [URL] = []
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.delegate = self
        self.dataSource = self
        doubleAction = #selector(self.doubleActionSelector)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.delegate = self
        self.dataSource = self
        doubleAction = #selector(self.doubleActionSelector)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image:NSImage?
        var text:String = ""
        var cellIdentifier: String = ""
        
        let item = items[row]
        
        if tableColumn == tableView.tableColumns[0] {
            image = item.icon
            text = item.name
            cellIdentifier = "FileCellID"
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        
        return nil
    }
    
    internal func doubleActionSelector() {
        let url = items[clickedRow].url
        
        if url.hasDirectoryPath {
            if clickedRow == 0 && items[selectedRow].name == "../" {
                stackOfDirectories.removeLast()
            }
            
            self.setCurrentDirectory(url: url)
            self.reloadPathData()
        } else {
            if NSApplication.shared().mainWindow!.contentViewController is EditorViewController {
                let editorVC = NSApplication.shared().mainWindow!.contentViewController as! EditorViewController
                if url.pathExtension == "dkscene" {
                    editorVC.editorView.scene.load(url: url)
                    editorVC.editorView.Init()
                }
            }
        }
    }
    
    internal func setCurrentDirectory(url: URL) {
        if currentDirectory != nil && url != dCore.instance.ROOT_PATH! {
            stackOfDirectories.append(currentDirectory!)
        }
        
        currentDirectory = url
    }
    
    internal func reloadPathData() {
        items.removeAll()
        
        if stackOfDirectories.count > 0 {
            let directory = Directory(icon: NSImage(), name: "../", url: stackOfDirectories.last!)
            items.append(directory)
        }
        
        if let url = currentDirectory {
            let fileManager = FileManager()
            
            let enumerator = fileManager.enumerator(at: url,
                                                    includingPropertiesForKeys: [URLResourceKey.effectiveIconKey,URLResourceKey.localizedNameKey],
                                                    options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
                                                                .union(FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants),
                                                    errorHandler: { (u, error) -> Bool in
                                                        NSLog("URL: \(u.path) - Error: \(error)")
                                                        return false
                                                    })
            
            while let u = enumerator?.nextObject() as? URL {
                do{
                    
                    let properties = try u.resourceValues(forKeys: [URLResourceKey.effectiveIconKey,URLResourceKey.localizedNameKey]).allValues
                    
                    let icon = properties[URLResourceKey.effectiveIconKey] as? NSImage ?? NSImage()
                    let name = properties[URLResourceKey.localizedNameKey] as? String ?? " "
                    
                    let directory = Directory(icon: icon, name: name, url: u)
                    
                    items.append(directory)
                }
                catch {
                    NSLog("Error reading file attributes")
                }
            }
            
            self.reloadData()
        }
    }
}
