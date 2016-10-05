//
//  dSVector3D.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 04/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import JavaScriptCore
import simd

@objc internal protocol dSVector3DExport: JSExport {
    var x: NSNumber { get }
    var y: NSNumber { get }
    var z: NSNumber { get }
    
    func Set(_ x: NSNumber, _ y: NSNumber, _ z: NSNumber)
}

internal class dSVector3D: NSObject, dSVector3DExport {
    private var vec: dVector3D
    
    public var x: NSNumber {
        get {
            return NSNumber(value: vec.x)
        }
    }
    
    public var y: NSNumber {
        get {
            return NSNumber(value: vec.y)
        }
    }
    
    public var z: NSNumber {
        get {
            return NSNumber(value: vec.z)
        }
    }
    
    public init(_ data: dVector3D) {
        self.vec = data
    }
    
    public func Set(_ x: NSNumber, _ y: NSNumber, _ z: NSNumber) {
        self.vec.Set(x.floatValue, y.floatValue, z.floatValue)
    }
    
    public func Get() -> dVector3D {
        return self.vec;
    }
}
