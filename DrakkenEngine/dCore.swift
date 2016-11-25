//
//  DKRCore.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import Foundation
import CoreGraphics

public class dCore {
	public static let instance: dCore = dCore()
	
	internal var device: MTLDevice
	internal var library: MTLLibrary!
	
	internal var cQueue: MTLCommandQueue
	
	internal var renderer: dRenderer!
	
	internal var bManager: dBufferManager
	internal var tManager: dTextureManager
	internal var trManager: dTransformManager
	internal var mtManager: dMaterialManager
	internal var shManager: dShaderManager
	internal var mshManager: dMeshManager
	internal var spManager: dSpriteManager
    internal var scManager: dSceneManager
    
    internal var allDebugLogs: [dLog] = []
    
    internal var ROOT_PATH: URL?
    internal var IMAGES_PATH: URL?
    internal var SCENES_PATH: URL?
    internal var SCRIPTS_PATH: URL?
    internal var SPRITES_PATH: URL?
    internal var PREFABS_PATH: URL?
	
	internal init() {
		self.device = MTLCreateSystemDefaultDevice()!
		self.cQueue = device.makeCommandQueue()
		
		self.bManager = dBufferManager()
		self.tManager = dTextureManager()
		self.trManager = dTransformManager()
		self.mtManager = dMaterialManager()
		self.shManager = dShaderManager()
		self.mshManager = dMeshManager()
		self.spManager = dSpriteManager()
        self.scManager = dSceneManager()

		self.renderer = dRenderer()
        
        self.ROOT_PATH = Bundle.main.url(forResource: "Assets", withExtension: nil)
        self.IMAGES_PATH = ROOT_PATH?.appendingPathComponent("images", isDirectory: true)
        self.SCENES_PATH = ROOT_PATH?.appendingPathComponent("scenes", isDirectory: true)
        self.SCRIPTS_PATH = ROOT_PATH?.appendingPathComponent("scripts", isDirectory: true)
        self.SPRITES_PATH = ROOT_PATH?.appendingPathComponent("sprites", isDirectory: true)
        self.PREFABS_PATH = ROOT_PATH?.appendingPathComponent("prefabs", isDirectory: true)
		
		let bundle = Bundle.init(identifier: "drakkenstudio.DrakkenEngine")
		
		if let path = bundle!.path(forResource: "default", ofType: "metallib") {
			do
			{
				library = try self.device.makeLibrary(filepath: path)
			}
			catch MTLLibraryError.internal
			{
				assert(false, "Bundle identifier incorrect!")
			}
			catch MTLLibraryError.compileFailure
			{
				assert(false, "Compile failure")
			}
			catch MTLLibraryError.compileWarning
			{
				assert(false, "Compile warning")
			}
			catch MTLLibraryError.unsupported
			{
				assert(false, "Unsupported")
			}
			catch
			{
				assert(false, "default.metallib error!")
			}
		}
	}
    
    internal func loadRootPath(path: String) {
        if let url = URL(string: path) {
            loadRootPath(url: url)
        }
    }
    
    internal func loadRootPath(url: URL) {
        self.ROOT_PATH = url.appendingPathComponent("Assets")
        self.IMAGES_PATH = ROOT_PATH?.appendingPathComponent("images", isDirectory: true)
        self.SCENES_PATH = ROOT_PATH?.appendingPathComponent("scenes", isDirectory: true)
        self.SCRIPTS_PATH = ROOT_PATH?.appendingPathComponent("scripts", isDirectory: true)
        self.SPRITES_PATH = ROOT_PATH?.appendingPathComponent("sprites", isDirectory: true)
        self.PREFABS_PATH = ROOT_PATH?.appendingPathComponent("prefabs", isDirectory: true)
        
        self.prepareFolderData()
    }
    
    internal func prepareFolderData() {
        let fileManager = FileManager()
        
        do {
            
            spManager.deleteAll()
            
            //LOAD ALL TEXTURES
            let imageFolderContent = try fileManager.contentsOfDirectory(at: dCore.instance.IMAGES_PATH!, includingPropertiesForKeys: nil,
                                                                         options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
                                                                            .union(FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants))
            
            for imageURL in imageFolderContent {
                if imageURL.isFileURL {
                    _ = dTexture(imageURL.lastPathComponent)
                    let spriteDef = dSpriteDef(imageURL.lastPathComponent, texture: imageURL.lastPathComponent)
                    DrakkenEngine.Register(sprite: spriteDef)
                }
            }
            
            let spritesFolderContent = try fileManager.contentsOfDirectory(at: dCore.instance.SPRITES_PATH!, includingPropertiesForKeys: nil,
                                                                           options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles
                                                                            .union(FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants))
            
            //LOAD ALL SPRITES
            for spriteURL in spritesFolderContent {
                if spriteURL.isFileURL && spriteURL.pathExtension == "dksprite" {
                    var fileString: String = ""
                    do {
                        fileString = try String(contentsOf: spriteURL)
                        if let dataFromString = fileString.data(using: String.Encoding.utf8) {
                            let json = JSON(data: dataFromString)
                            
                            let name = json["name"].stringValue
                            let columns = json["columns"].intValue
                            let lines = json["lines"].intValue
                            let texture = json["texture"].stringValue
                            
                            print("SPRITE - name: \(name), c: \(columns), l: \(lines), texture: \(texture)")
                            
                            let spriteDef = dSpriteDef(name, columns: columns, lines: lines, texture: texture)
                            DrakkenEngine.Register(sprite: spriteDef)
                        }
                    } catch {
                        fatalError("Sprite file error")
                    }
                }
            }
            DrakkenEngine.Setup()
        } catch let error {
            fatalError("Fail while get first scene URL: \(error)")
        }
    }
}
