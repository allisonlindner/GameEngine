//
//  dSSize2D.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 04/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import JavaScriptCore
import simd

@objc internal protocol dSSize2DExport: JSExport {
    var width: NSNumber { get }
    var height: NSNumber { get }
    
    func Set(_ w: NSNumber, _ h: NSNumber)
}

internal class dSSize2D: NSObject, dSSize2DExport {
    private var size: dSize2D
    
    public var width: NSNumber {
        get {
            return NSNumber(value: size.width)
        }
    }
    
    public var height: NSNumber {
        get {
            return NSNumber(value: size.height)
        }
    }
    
    public init(_ data: dSize2D) {
        self.size = data
    }
    
    public func Set(_ w: NSNumber, _ h: NSNumber) {
        self.size.Set(w.floatValue, h.floatValue)
    }
    
    public func Get() -> dSize2D {
        return self.size
    }
}
