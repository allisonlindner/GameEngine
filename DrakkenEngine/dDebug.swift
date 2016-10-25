//
//  dDebug.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 25/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc public protocol dDebugExport: JSExport {
    func log(_ content: String)
}

public class dLog {
    public var transformName: String
    public var date: Date
    public var content: String
    
    public init(_ transformName: String, _ date: Date, _ content: String) {
        self.transformName = transformName
        self.date = date
        self.content = content
    }
    
    public func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd - HH:mm:ss:SSSS"
        let dateString = dateFormatter.string(from: date)
        return "\(dateString) - \(transformName) - \(content)"
    }
}

public class dDebug: NSObject, dDebugExport {
    private var logs: [dLog] = []
    internal var transform: dTransform
    
    public init(_ transform: dTransform) {
        self.transform = transform
    }
    
    public func log(_ content: String) {
        if transform._scene.DEBUG_MODE {
            let l = dLog(transform.name, Date(), String(content))
            
            logs.append(l)
            dCore.instance.allDebugLogs.append(l)
        }
    }
}
