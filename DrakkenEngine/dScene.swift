//
//  dScene.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 26/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import simd

public class dScene {
	public var size: float2 = float2(1920.0, 1080.0)
    public var scale: Float = 1.0
	
    internal var time: dTime = dTime()
    
    internal var name: String = "scene"
    internal var root: dTransform = dTransform(name: "root")
    
    internal var DEBUG_MODE = false
	
    public func add(transform: dTransform) {
        if transform._scene == nil {
            transform.set(scene: self)
        }
        
        root.add(child: transform)
	}
    
    public func remove(transform: dTransform) {
        root.remove(child: transform)
    }
    
    internal func load(url: URL) {
        var fileString: String = ""
        
        do {
            fileString = try String(contentsOf: url)
            
            load(json: fileString)
        } catch {
            NSLog("Scene file error")
        }
    }
    
    internal func load(jsonFile: String) {
        if let url = dCore.instance.SCENES_PATH?.appendingPathComponent(jsonFile).appendingPathExtension("dkscene") {
            self.load(url: url)
        }
    }
    
    internal func load(data: Data) {
        self.clear()
        self.root._scene = self
        
        let json = JSON(data: data)
        
        self.name = json["name"].stringValue
        
        print("----------------------------------------------")
        print("name: \(name)")
        print("----------------------------------------------")
        print("-----------------  SETUP  --------------------")
        print("----------------------------------------------")
        
        let transforms = json["transforms"].arrayValue
        
        for t in transforms {
            let transform = dTransform(json: t)
            self.add(transform: transform)
        }
    }
    
    private func load(json: String) {
        if let dataFromString = json.data(using: String.Encoding.utf8) {
            self.load(data: dataFromString)
        }
    }
    
    internal func toData() -> Data? {
        var jsonDict = [String: JSON]()
        
        jsonDict["name"] = JSON(self.name)
        
        var transformsArray: [JSON] = []
        for t in self.root.childrenTransforms {
            transformsArray.append(JSON(t.value.toDict()))
        }
        
        jsonDict["transforms"] = JSON(transformsArray)
        
        let json = JSON(jsonDict)
        do {
            let data = try json.rawData(options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = String(data: data, encoding: String.Encoding.utf8)
            NSLog(string!)
            
            return data
        } catch let error {
            NSLog("JSON conversion FAIL!! \(error)")
        }
        
        return nil
    }
    
    internal func toJSON() -> JSON? {
        var jsonDict = [String: JSON]()
        
        jsonDict["name"] = JSON(self.name)
        jsonDict["setup"] = JSON(DrakkenEngine.toDict())
        
        var transformsArray: [JSON] = []
        for t in self.root.childrenTransforms {
            transformsArray.append(JSON(t.value.toDict()))
        }
        
        jsonDict["transforms"] = JSON(transformsArray)
        
        let json = JSON(jsonDict)
        
        return json
    }
    
    internal func clear() {
        self.root.removeAll()
    }
}
