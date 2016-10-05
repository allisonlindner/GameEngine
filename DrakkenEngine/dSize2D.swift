//
//  dSize2D.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 04/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import simd

public class dSize2D {
    private var data: float2 = float2(1.0)
    
    public var width: Float {
        get {
            return data.x
        }
    }
    
    public var height: Float {
        get {
            return data.y
        }
    }
    
    public init(_ data: float2) {
        self.data = data
    }
    
    public init(_ w: Float, _ h: Float) {
        data.x = w
        data.y = h
    }
    
    public func Set(_ w: Float, _ h: Float) {
        data.x = w
        data.y = h
    }
    
    public func Get() -> float2 {
        return data
    }
}
