//
//  dTime.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 18/11/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc public protocol dTimeExport: JSExport {
    var DeltaTime: NSNumber { get }
}

public class dTime: NSObject, dTimeExport {
    internal var deltaTime: Double = 0.0
    
    public var DeltaTime: NSNumber {
        get { return NSNumber(value: deltaTime) }
    }
}
