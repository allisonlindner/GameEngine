//
//  DrakkenEngine.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation

fileprivate struct dShaderRegister {
	var name: String
	var vertexFunctionName: String
	var fragmentFunctionName: String
}

public class DrakkenEngine {
	private static var _toBeRegisteredShaders: [dShaderRegister] = []
	private static var _toBeRegisteredMeshs: [dMeshDef] = []
	private static var _toBeRegisteredMaterials: [dMaterialDef] = []
	private static var _toBeRegisteredSprites: [dSpriteDef] = []
    
    private static var _registeredTexture: [dTexture] = []
    private static var _registeredSprites: [dSpriteDef] = []
    
    public static func Init() {
		DrakkenEngine.InitInternalShaders()
		DrakkenEngine.InitInternalMeshs()
		DrakkenEngine.InitInternalMaterial()
        
        DrakkenEngine.Setup()
	}
    
    public static func Setup() {
        DrakkenEngine.SetupShaders()
        DrakkenEngine.SetupSprites()
        DrakkenEngine.SetupMeshs()
        DrakkenEngine.SetupMaterials()
    }
	
	public static func Register(shader name: String, vertexFunc: String, fragmentFunc: String) {
		let register = dShaderRegister(name: name,
		                               vertexFunctionName: vertexFunc,
		                               fragmentFunctionName: fragmentFunc)
		
		DrakkenEngine._toBeRegisteredShaders.append(register)
	}
	
	public static func Register(mesh def: dMeshDef) {
		DrakkenEngine._toBeRegisteredMeshs.append(def)
	}
	
	public static func Register(material def: dMaterialDef) {
		DrakkenEngine._toBeRegisteredMaterials.append(def)
	}
	
	public static func Register(sprite def: dSpriteDef) {
		DrakkenEngine._toBeRegisteredSprites.append(def)
        DrakkenEngine._registeredSprites.append(def)
	}
    
    internal static func Register(texture: dTexture) {
        DrakkenEngine._registeredTexture.append(texture)
    }
	
	private static func SetupShaders() {
		for shaderToRegister in DrakkenEngine._toBeRegisteredShaders {
			dCore.instance.shManager.register(shader: shaderToRegister.name,
			                                  vertexFunc: shaderToRegister.vertexFunctionName,
			                                  fragmentFunc: shaderToRegister.fragmentFunctionName)
		}
	}
	
	private static func SetupMeshs() {
		for meshToRegister in DrakkenEngine._toBeRegisteredMeshs {
			let mesh = dMesh(meshDef: meshToRegister)
			mesh.build()
		}
        DrakkenEngine._toBeRegisteredMeshs.removeAll()
	}
	
	private static func SetupMaterials() {
		for materialToRegister in DrakkenEngine._toBeRegisteredMaterials {
			let material = dMaterial(materialDef: materialToRegister)
			material.build()
        }
        DrakkenEngine._toBeRegisteredMaterials.removeAll()
	}
	
	private static func SetupSprites() {
		for spriteToRegister in DrakkenEngine._toBeRegisteredSprites {
			_ = dCore.instance.spManager.create(sprite: spriteToRegister)
        }
        DrakkenEngine._toBeRegisteredSprites.removeAll()
	}
	
	private static func InitInternalShaders() {
		DrakkenEngine.Register(shader: "diffuse",
		                       vertexFunc: "diffuse_vertex",
		                       fragmentFunc: "diffuse_fragment")
	}
	
	private static func InitInternalMeshs() {
		DrakkenEngine.Register(mesh: dQuad(name: "quad"))
		DrakkenEngine.Register(mesh: dSpriteQuad(name: "spritequad"))
	}
	
	private static func InitInternalMaterial() {
		
	}
    
    internal static func toDict() -> [String: JSON] {
        var dict = [String: JSON]()
        
        var textures = [JSON]()
        for t in _registeredTexture {
            textures.append(JSON(t.toDict()))
        }
        
        var sprites = [JSON]()
        for s in _registeredSprites {
            sprites.append(JSON(s.toDict()))
        }
        
        dict["textures"] = JSON(textures)
        dict["sprites"] = JSON(sprites)
        
        return dict
    }
}
