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
	
    internal var name: String = "scene"
    internal var root: dTransform = dTransform(name: "root")
	
	public func add(transform: dTransform) {
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
        
        let json = JSON(data: data)
        
        self.name = json["name"].stringValue
        
        print("----------------------------------------------")
        print("name: \(name)")
        print("----------------------------------------------")
        print("-----------------  SETUP  --------------------")
        print("----------------------------------------------")
        
        load(setupJSON: json)
        
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
    
    private func load(setupJSON: JSON) {
        let json = setupJSON
        
        let setup = json["setup"].dictionaryValue
        
        let textures = setup["textures"]!.arrayValue
        for t in textures {
            let file = t["file"].stringValue
            
            print("TEXTURE - file: \(file)")
            
            _ = dTexture(file)
        }
        
        let sprites = setup["sprites"]!.arrayValue
        for s in sprites {
            let name = s["name"].stringValue
            let columns = s["columns"].intValue
            let lines = s["lines"].intValue
            let texture = s["texture"].stringValue
            
            print("SPRITE - name: \(name), c: \(columns), l: \(lines), texture: \(texture)")
            
            let spriteDef = dSpriteDef(name, columns: columns, lines: lines, texture: texture)
            DrakkenEngine.Register(sprite: spriteDef)
        }
        
        DrakkenEngine.Init()
    }
    
    internal func toJSON() -> Data? {
        var jsonDict = [String: JSON]()
        
        jsonDict["name"] = JSON(self.name)
        jsonDict["setup"] = JSON(DrakkenEngine.toDict())
        
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
    
    internal func clear() {
        self.root.removeAll()
    }
}
