//
//  dSpriteDef.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 23/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import simd

public class dDiffuseDef: dMaterialDef {
	internal var columns: Int
	internal var lines: Int
	
	public init(name: String, columns: Int = 1, lines: Int = 1) {
		self.columns = columns
		self.lines = lines
		
		super.init(name: name, shader: "diffuse")
		
		self.set(light: dLight(color: float3(1.0, 1.0, 1.0), intensity: 1.0))
	}
	
	public func set(albedo texture: dTexture) {
		self.set(texture: "albedo", texture, 0)
		self.set(columns: self.columns, lines: self.lines)
	}
	
	public func set(light: dLight) {
		let buffer = dBuffer(data: light, index: 0, preAllocateSize: 1, bufferType: .fragment)
		self.set(buffer: "uLight", buffer)
	}
	
	public func set(columns: Int, lines: Int) {
		self.columns = columns
		self.lines = lines
		
		if let texture = self.get(texture: "albedo") {
			let tW: Float = Float(texture.getTexture().width)
			let tH: Float = Float(texture.getTexture().height)
			
			let sW: Float = tW / Float(self.columns)
			let sH: Float = tH / Float(self.lines)
			
			var texCoords: [float2] = []
			
			for c in 0..<columns {
				let _c = Float(c)
				for l in 0..<lines {
					let _l = Float(l)
					texCoords.append(float2( (_c * sW) / tW			 , ((_l + 1.0) * sH) / tH	))
					texCoords.append(float2( (_c * sW) / tW			 , (_l * sH) / tH			))
					texCoords.append(float2( ((_c + 1.0) * sW) / tW	 , (_l * sH) / tH			))
					texCoords.append(float2( ((_c + 1.0) * sW) / tW	 , ((_l + 1.0) * sH) / tH	))
				}
			}
			
			let texCoordsBuffer = dBuffer<float2>(data: texCoords, index: 5)
			self.set(buffer: "texcoords", texCoordsBuffer)
		}
	}
}
