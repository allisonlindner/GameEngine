//
//  dVector3D.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 04/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import simd

public class dVector3D {
    private var data: float3 = float3(0.0)
    
    public var x: Float {
        get {
            return data.x
        }
    }
    
    public var y: Float {
        get {
            return data.y
        }
    }
    
    public var z: Float {
        get {
            return data.z
        }
    }
    
    public init(_ data: float3) {
        self.data = data
    }
    
    public init(_ x: Float, _ y: Float, _ z: Float) {
        data.x = x
        data.y = y
        data.z = z
    }
    
    public func Set(_ x: Float, _ y: Float, _ z: Float) {
        data.x = x
        data.y = y
        data.z = z
    }
    
    public func Get() -> float3 {
        return data;
    }
}
