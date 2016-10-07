//
//  dSceneManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 07/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation


internal class dSceneManager {
    
    internal init() {
        
    }
    
    internal func load(scene: String) -> dScene {
        let sceneObj = dScene()
        
        if let url = Bundle.main.url(forResource: scene, withExtension: "json", subdirectory: "Assets/scenes") {
            var fileString: String = ""
            
            do {
                fileString = try String(contentsOf: url)
                
                if let dataFromString = fileString.data(using: String.Encoding.utf8) {
                    let json = JSON(data: dataFromString)
                    
                    let name = json["name"].stringValue
                    let setup = json["setup"].stringValue
                    print("----------------------------------------------")
                    print("name: \(name)")
                    print("----------------------------------------------")
                    print("setup: \(setup)")
                    print("----------------------------------------------")
                    
                    load(setup: setup)
                    
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
                        
                        sceneObj.add(transform: transformObj)
                        
                        print("----------------------------------------------")
                    }
                }
            } catch {
                NSLog("Scene file error")
            }
        }
        
        return sceneObj
    }
    
    internal func load(setup: String) {
        if let url = Bundle.main.url(forResource: setup, withExtension: "json", subdirectory: "Assets/scenes") {
            var fileString: String = ""
            
            do {
                fileString = try String(contentsOf: url)
                
                if let dataFromString = fileString.data(using: String.Encoding.utf8) {
                    let json = JSON(data: dataFromString)
                    
                    let textures = json["textures"].arrayValue
                    for t in textures {
                        let file = t["file"].stringValue
                        
                        print("TEXTURE - file: \(file)")
                        
                        _ = dTexture(file)
                    }
                    
                    let sprites = json["sprites"].arrayValue
                    for s in sprites {
                        let name = s["name"].stringValue
                        let columns = s["columns"].intValue
                        let lines = s["lines"].intValue
                        let texture = s["texture"].stringValue
                        
                        print("SPRITE - name: \(name), c: \(columns), l: \(lines), texture: \(texture)")
                        
                        let spriteDef = dSpriteDef(name, columns: columns, lines: lines, texture: texture)
                        DrakkenEngine.Register(sprite: spriteDef)
                    }
                }
                
                DrakkenEngine.Init()
            } catch {
                NSLog("Scene setup file error")
            }
        }
    }
}
