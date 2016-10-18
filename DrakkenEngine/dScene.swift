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
	internal var transforms: [dTransform] = []
	
	public func add(transform: dTransform) {
		self.transforms.append(transform)
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
    
    private func load(json: String) {
        self.clear()
        
        if let dataFromString = json.data(using: String.Encoding.utf8) {
            let json = JSON(data: dataFromString)
            
            self.name = json["name"].stringValue
            
            print("----------------------------------------------")
            print("name: \(name)")
            print("----------------------------------------------")
            print("-----------------  SETUP  --------------------")
            print("----------------------------------------------")
            
            load(setupJSON: json)
            
            let transforms = json["transforms"].arrayValue
            
            for t in transforms {
                print("----------------------------------------------")
                
                let position = t["position"].dictionaryValue
                print("position - x: \(position["x"]!.floatValue), y: \(position["y"]!.floatValue), z: \(position["z"]!.floatValue)")
                
                let rotation = t["rotation"].dictionaryValue
                print("rotation - x: \(rotation["x"]!.floatValue), y: \(rotation["y"]!.floatValue), z: \(rotation["z"]!.floatValue)")
                
                let scale = t["scale"].dictionaryValue
                print("scale - w: \(scale["w"]!.floatValue), h: \(scale["h"]!.floatValue)")
                
                let transformObj = dTransform(position: (x: position["x"]!.floatValue, y: position["y"]!.floatValue, z: position["z"]!.floatValue),
                                              rotation: (x: rotation["x"]!.floatValue, y: rotation["x"]!.floatValue, z: rotation["x"]!.floatValue),
                                              scale: (x: scale["w"]!.floatValue, y: scale["h"]!.floatValue),
                                              parent: nil)
                
                let components = t["components"].arrayValue
                for c in components {
                    let type = c["type"].stringValue
                    
                    switch type {
                    case "SPRITE":
                        let name = c["name"].stringValue
                        let frame = c["frame"].int32Value
                        
                        print("\(type) - name: \(name), frame: \(frame)")
                        
                        let sprite = dSprite(sprite: name, frame: frame)
                        transformObj.add(component: sprite)
                        
                        break
                    case "SCRIPT":
                        let filename = c["filename"].stringValue
                        
                        print("\(type) - filename: \(filename)")
                        
                        transformObj.add(script: filename)
                        
                        break
                    default:
                        break
                    }
                }
                
                self.add(transform: transformObj)
                
                print("----------------------------------------------")
            }
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
        
        var transforms: [JSON] = []
        
        for t in self.transforms {
            var dict = [String: JSON]()
            var position = [String: JSON]()
            
            position["x"] = JSON(t.Position.x)
            position["y"] = JSON(t.Position.y)
            position["z"] = JSON(t.Position.z)
            
            dict["position"] = JSON(position)
            
            var rotation = [String: JSON]()
            
            rotation["x"] = JSON(t.Rotation.x)
            rotation["y"] = JSON(t.Rotation.y)
            rotation["z"] = JSON(t.Rotation.z)
            
            dict["rotation"] = JSON(rotation)
            
            var scale = [String: JSON]()
            
            scale["w"] = JSON(t.Scale.width)
            scale["h"] = JSON(t.Scale.height)
            
            dict["scale"] = JSON(scale)
            
            var components = [JSON]()
            for c in t.components {
                if c.toDict().count > 0 {
                    components.append(JSON(c.toDict()))
                }
            }
            
            dict["components"] = JSON(components)
            
            transforms.append(JSON(dict))
        }
        
        jsonDict["transforms"] = JSON(transforms)
        
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
        self.transforms.removeAll()
    }
}
