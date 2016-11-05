//
//  DKMTransform.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import simd
import JavaScriptCore

@objc internal protocol dTransformExport: JSExport {
    var position: dSVector3DExport { get }
    var rotation: dSVector3DExport { get }
    var scale: dSSize2DExport { get }
}

public class dTransform: NSObject, dTransformExport, Serializable {
	internal var _id: Int
    internal var _transformData: dTransformData!
    internal var _scene: dScene!
    
    private var _parentTransform: dTransform?
	internal var parentTransform: dTransform? {
		get { return self._parentTransform }
	}
	
    private var _childrenTransforms: [Int: dTransform] = [:]
	internal var childrenTransforms: [Int: dTransform] {
		get { return self._childrenTransforms }
	}
	
	private var _components: [dComponent] = []
	internal var components: [dComponent] {
		get { return self._components }
        set { _components = newValue }
	}
	
	public var localMatrix4x4: float4x4 {
		get { return self._transformData.localMatrix4x4 }
	}
	
	public var worldMatrix4x4: float4x4 {
		get { return self._transformData.worldMatrix4x4 }
	}
    
    public var name: String {
        get {
            return self._transformData.name
        }
        set {
            self._transformData.name = newValue
        }
    }
	
	public var Position: dVector3D {
		get { return self._transformData.position }
		set { self._transformData.position = newValue }
	}
	
	public var Rotation: dVector3D {
		get { return self._transformData.rotation }
		set { self._transformData.rotation = newValue }
	}
	
	public var Scale: dSize2D {
		get { return self._transformData.scale }
		set { self._transformData.scale = newValue }
	}
    
    @objc internal var position: dSVector3DExport {
        get { return dSVector3D(self._transformData.position) }
    }
    
    @objc internal var rotation: dSVector3DExport {
        get { return dSVector3D(self._transformData.rotation) }
    }
    
    @objc internal var scale: dSSize2DExport {
        get { return dSSize2D(self._transformData.scale) }
    }
    
    public init(id: Int) {
        self._id = id
        self._transformData = dCore.instance.trManager.getTransform(id)
    }
	
	public init(name: String,
	            position: (x: Float, y: Float, z: Float),
	            rotation: (x: Float, y: Float, z: Float),
				   scale: (x: Float, y: Float),
				   parent: dTransform?) {
		
		self._id = dCore.instance.trManager.create(name, position, rotation, scale)
		self._transformData = dCore.instance.trManager.getTransform(_id)
		
		self._parentTransform = parent
	}
    
    public init(name: String,
                position: (x: Float, y: Float, z: Float),
                rotation: (x: Float, y: Float, z: Float),
                scale: (x: Float, y: Float),
                parent: dTransform?, id: Int) {
        
        self._id = dCore.instance.trManager.create(name, position, rotation, scale, id)
        self._transformData = dCore.instance.trManager.getTransform(_id)
        
        self._parentTransform = parent
    }
	
    public convenience init(name: String, position x: Float, _ y: Float, _ z: Float) {
        self.init(name: name,
                  position: (x, y, z),
		          rotation: (0.0, 0.0, 0.0),
					 scale: (1.0, 1.0),
					 parent: nil)
	}
	
	public convenience init(name: String, x: Float, _ y: Float, _ z: Float) {
        self.init(name: name,
                  position: (0.0, 0.0, 0.0),
		          rotation: (x, y, z),
					 scale: (1.0, 1.0),
					parent: nil)
	}
	
	public convenience init(name: String, scale x: Float, _ y: Float) {
        self.init(name: name,
                  position: (0.0, 0.0, 0.0),
		          rotation: (0.0, 0.0, 0.0),
					 scale: (x, y),
					parent: nil)
	}
	
    public convenience init(name: String) {
        self.init(name: name,
                  position: (0.0, 0.0, 0.0),
		          rotation: (0.0, 0.0, 0.0),
					 scale: (1.0, 1.0),
					parent: nil)
	}
    
    public convenience override init() {
        self.init(name: "Transform",
                  position: (0.0, 0.0, 0.0),
                  rotation: (0.0, 0.0, 0.0),
                  scale: (1.0, 1.0),
                  parent: nil)
    }
    
    public convenience init(json: JSON) {
        print("----------------------------------------------")
        
        let name = json["name"].stringValue
        print("name: \(name)")
        
        let id = json["id"].int
        print("id: \(id)")
        
        let position = json["position"].dictionaryValue
        print("position - x: \(position["x"]!.floatValue), y: \(position["y"]!.floatValue), z: \(position["z"]!.floatValue)")
        
        let rotation = json["rotation"].dictionaryValue
        print("rotation - x: \(rotation["x"]!.floatValue), y: \(rotation["y"]!.floatValue), z: \(rotation["z"]!.floatValue)")
        
        let scale = json["scale"].dictionaryValue
        print("scale - w: \(scale["w"]!.floatValue), h: \(scale["h"]!.floatValue)")
        
        if id != nil {
            self.init(name: name,
                      position: (x: position["x"]!.floatValue, y: position["y"]!.floatValue, z: position["z"]!.floatValue),
                      rotation: (x: rotation["x"]!.floatValue, y: rotation["x"]!.floatValue, z: rotation["x"]!.floatValue),
                      scale: (x: scale["w"]!.floatValue, y: scale["h"]!.floatValue),
                      parent: nil, id: id!)
        } else {
            self.init(name: name,
                      position: (x: position["x"]!.floatValue, y: position["y"]!.floatValue, z: position["z"]!.floatValue),
                      rotation: (x: rotation["x"]!.floatValue, y: rotation["x"]!.floatValue, z: rotation["x"]!.floatValue),
                      scale: (x: scale["w"]!.floatValue, y: scale["h"]!.floatValue),
                      parent: nil)
        }
        
        let components = json["components"].arrayValue
        for c in components {
            let type = c["type"].stringValue
            
            switch type {
            case "SPRITE":
                let name = c["name"].stringValue
                let frame = c["frame"].int32Value
                let scaleDict = c["scale"].dictionaryValue
                
                let scale = dSize2D(scaleDict["w"]!.floatValue, scaleDict["h"]!.floatValue)
                
                print("\(type) - name: \(name), frame: \(frame)")
                
                let sprite = dSprite(sprite: name, scale: scale, frame: frame)
                self.add(component: sprite)
                
                break
            case "SCRIPT":
                let filename = c["filename"].stringValue
                
                print("\(type) - filename: \(filename)")
                
                self.add(script: filename)
                
                break
            default:
                break
            }
        }
        
        print("----------------------------------------------")
        
        if let children = json["children"].array {
            for c in children {
                let transformChild = dTransform(json: c)
                self.add(child: transformChild)
            }
        }
    }
    
    internal func reloadWithoutScript(from json: JSON) {
        let name = json["name"].stringValue
        print("name: \(name)")
        
        let id = json["id"].intValue
        print("id: \(id)")
        
        let position = json["position"].dictionaryValue
        print("position - x: \(position["x"]!.floatValue), y: \(position["y"]!.floatValue), z: \(position["z"]!.floatValue)")
        
        let rotation = json["rotation"].dictionaryValue
        print("rotation - x: \(rotation["x"]!.floatValue), y: \(rotation["y"]!.floatValue), z: \(rotation["z"]!.floatValue)")
        
        let scale = json["scale"].dictionaryValue
        print("scale - w: \(scale["w"]!.floatValue), h: \(scale["h"]!.floatValue)")
        
        self.Position.Set(position["x"]!.floatValue, position["y"]!.floatValue, position["z"]!.floatValue)
        self.Rotation.Set(rotation["x"]!.floatValue, rotation["y"]!.floatValue, rotation["z"]!.floatValue)
        self.Scale.Set(scale["w"]!.floatValue, scale["h"]!.floatValue)
        
        let components = json["components"].arrayValue
        for c in components {
            let type = c["type"].stringValue
            
            switch type {
            case "SPRITE":
                let name = c["name"].stringValue
                let frame = c["frame"].int32Value
                let scaleDict = c["scale"].dictionaryValue
                
                let scale = dSize2D(scaleDict["w"]!.floatValue, scaleDict["h"]!.floatValue)
                
                print("\(type) - name: \(name), frame: \(frame)")
                
                let sprite = dSprite(sprite: name, scale: scale, frame: frame)
                self.add(component: sprite)
                
                break
            default:
                break
            }
        }
        
        print("----------------------------------------------")
        
        if let children = json["children"].array {
            for c in children {
                let c_id = c["id"].intValue
                let c_t = dTransform(id: c_id)
                c_t.set(parent: self)
                c_t.reloadWithoutScript(from: c)
            }
        }
    }
	
    internal func set(scene: dScene) {
        self._scene = scene
        
        for child in _childrenTransforms {
            child.value._scene = self._scene
        }
    }
    
	internal func set(parent: dTransform) {
        if parent._scene != nil {
            self.set(scene: parent._scene)
        }
        
        self._parentTransform = parent
		self._transformData.parentTransform = parent._transformData
	}
	
    public func add(child: dTransform) {
        child.set(parent: self)
		self._childrenTransforms[child._id] = child
	}
	
	public func remove(child: dTransform) {
		self._childrenTransforms.removeValue(forKey: child._id)
	}
	
	public func add(component: dComponent) {
        switch component.self {
        case is dMeshRender:
            for c in _components {
                if c.self is dMeshRender {
                    return
                }
            }
            self._transformData.meshScale = (component as! dMeshRender).scale
            break
        case is dJSScript:
            let s = component as! dJSScript
            s.set(transform: self)
            break
        case is dSprite:
            let s = component as! dSprite
            self.add(component: s.meshRender)
            break
        default:
            break
        }
		
		component.set(parent: self)
		self._components.append(component)
        component.indexOnParent = self._components.index(of: component)
	}
    
    public func add(script: String) {
        let s = dJSScript(fileName: script)
        self.add(component: s)
    }
    
    internal func removeSprite() {
        for c in _components {
            if c.self is dMeshRender {
                _components.remove(at: _components.index(of: c)!)
            }
            
            if c.self is dSprite {
                _components.remove(at: _components.index(of: c)!)
            }
        }
    }
    
    internal func removeAll() {
        self._childrenTransforms.removeAll()
    }
    
    internal func toDict() -> [String: JSON] {
        var dict = [String: JSON]()
        
        dict["name"] = JSON(name)
        dict["id"] = JSON(_id)
        
        var position = [String: JSON]()
        
        position["x"] = JSON(Position.x)
        position["y"] = JSON(Position.y)
        position["z"] = JSON(Position.z)
        
        dict["position"] = JSON(position)
        
        var rotation = [String: JSON]()
        
        rotation["x"] = JSON(Rotation.x)
        rotation["y"] = JSON(Rotation.y)
        rotation["z"] = JSON(Rotation.z)
        
        dict["rotation"] = JSON(rotation)
        
        var scale = [String: JSON]()
        
        scale["w"] = JSON(Scale.width)
        scale["h"] = JSON(Scale.height)
        
        dict["scale"] = JSON(scale)
        
        var componentsArray = [JSON]()
        for c in components {
            if c.toDict().count > 0 {
                componentsArray.append(JSON(c.toDict()))
            }
        }
        
        dict["components"] = JSON(componentsArray)
        
        var childrenArray = [JSON]()
        for t in childrenTransforms {
            childrenArray.append(JSON(t.value.toDict()))
        }
        
        dict["children"] = JSON(childrenArray)
        
        return dict
    }
    
    internal func toJSON() -> JSON {
        var dict = [String: JSON]()
        
        dict["name"] = JSON(name)
        dict["id"] = JSON(_id)
        
        var position = [String: JSON]()
        
        position["x"] = JSON(Position.x)
        position["y"] = JSON(Position.y)
        position["z"] = JSON(Position.z)
        
        dict["position"] = JSON(position)
        
        var rotation = [String: JSON]()
        
        rotation["x"] = JSON(Rotation.x)
        rotation["y"] = JSON(Rotation.y)
        rotation["z"] = JSON(Rotation.z)
        
        dict["rotation"] = JSON(rotation)
        
        var scale = [String: JSON]()
        
        scale["w"] = JSON(Scale.width)
        scale["h"] = JSON(Scale.height)
        
        dict["scale"] = JSON(scale)
        
        var componentsArray = [JSON]()
        for c in components {
            if c.toDict().count > 0 {
                componentsArray.append(JSON(c.toDict()))
            }
        }
        
        dict["components"] = JSON(componentsArray)
        
        var childrenArray = [JSON]()
        for t in childrenTransforms {
            childrenArray.append(JSON(t.value.toDict()))
        }
        
        dict["children"] = JSON(childrenArray)
        
        return JSON(dict)
    }
    
    internal func has(child: dTransform) -> Bool {
        var result = false
        for t in childrenTransforms {
            if t.value == child {
                result = true
            } else {
                result = t.value.has(child: child)
            }
        }
        
        return result
    }
}
