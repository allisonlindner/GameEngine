//
//  DKRTextureManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 19/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import MetalKit

internal class DKRTextureManager {
	private var _mtkTextureLoaderInternal: MTKTextureLoader!
	
	private var _mtkTextureLoader: MTKTextureLoader {
		get {
			if _mtkTextureLoaderInternal == nil {
				_mtkTextureLoaderInternal = MTKTextureLoader(device: DKRCore.instance.device)
			}
			
			return self._mtkTextureLoaderInternal
		}
	}
	
	private var _textures: [Int : MTLTexture]
	private var _renderTargetTextures: [Int : MTLTexture]
	
	private var _namedTextures: [String : Int]
	private var _namedRenderTargetTextures: [String : Int]
	
	private var _nextTextureIndex: Int
	private var _nextRenderTargetIndex: Int
	
	internal var screenTexture: MTLTexture?
	
	internal init() {
		_textures = [:]
		_renderTargetTextures = [:]
		
		_namedTextures = [:]
		_namedRenderTargetTextures = [:]
		
		_nextTextureIndex = 0
		_nextRenderTargetIndex = 0
	}
	
	internal func create(name: String, fileName: String, fileExtension ext: String = ".png") -> Int {
		let texture = self.loadImage(fileName, ext)
		
		guard let indexed = _namedTextures[name] else {
			let _index = _nextTextureIndex
			_textures[_index] = texture
			_nextTextureIndex += 1
			
			_namedTextures[name] = _index
			
			return _index
		}
		
		_textures[indexed] = texture
		return indexed
	}
	
	internal func createRenderTarget(name: String, width: Int, height: Int) -> Int {
		let textureDesc = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(
			.BGRA8Unorm,
			width: width,
			height: height,
			mipmapped: false
		)
		textureDesc.usage.insert(.RenderTarget)
		
		let texture = DKRCore.instance.device.newTextureWithDescriptor(textureDesc)
		
		guard let indexed = _namedRenderTargetTextures[name] else {
			let _index = _nextRenderTargetIndex
			_renderTargetTextures[_index] = texture
			_nextRenderTargetIndex += 1
			
			_namedRenderTargetTextures[name] = _index
			
			return _index
		}
		
		_renderTargetTextures[indexed] = texture
		
		return indexed
	}
	
	internal func getTexture(id: Int) -> MTLTexture {
		return _textures[id]!
	}
	
	internal func getRenderTargetTexture(id: Int) -> MTLTexture {
		return _renderTargetTextures[id]!
	}
	
	internal func getTexture(name: String) -> MTLTexture {
		return getTexture(_namedTextures[name]!)
	}
	
	internal func getRenderTargetTexture(name: String) -> MTLTexture {
		return getRenderTargetTexture(_namedRenderTargetTextures[name]!)
	}
	
	internal func getID(name: String) -> Int{
		return _namedTextures[name]!
	}
	
	internal func getRenderTargetID(name: String) -> Int{
		return _namedRenderTargetTextures[name]!
	}
	
	private func loadImage(name: String, _ ext: String = ".png") -> MTLTexture {
		var _textureURL: NSURL?
		
		do {
			if let textureURL = NSBundle(identifier: "drakken.DrakkenKit")!.URLForResource(
											"Assets/" + name, withExtension: ext) {
				
				_textureURL = textureURL
			} else if let textureURL = NSBundle.mainBundle().URLForResource(
											"Assets/" + name, withExtension: ext) {
				
				_textureURL = textureURL
			}
			
			if _textureURL != nil {
				let texture = try _mtkTextureLoader.newTextureWithContentsOfURL(_textureURL!, options: nil)
				return texture
			} else {
				assert(false, "Fail load image with name: \(name) of extension: \(ext)")
			}
			
		} catch {
			assert(false, "Fail load image with name: \(name) of extension: \(ext)")
		}
	}
}