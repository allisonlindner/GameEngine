//
//  DKRSimpleRenderer.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

internal class DKRSimpleRenderer: DKRGraphRenderer {
	func draw(_ graph: inout DKRSceneGraph) {
		var ids: [Int] = []
		
		if graph.screenChange {
			let scene = graph.scene
			scene.currentCamera.changeSize(Float(graph.size.width), Float(graph.size.height))
			graph.screenChange = false
		}
		
		let scene = graph.scene
		guard let renderTexture = scene.renderTexture else {
			print("No render texture found on scene")
			return
		}
		
		let id = DKRCore.instance.renderer.startFrame(texture: renderTexture)
		ids.append(id)
		for materiable in scene.materials {
			let rcState = materiable.1.shader.rpState!
			
			let renderer = DKRCore.instance.renderer!
			
			renderer.encoder(withID: id).setRenderPipelineState(rcState)
			
			renderer.bind(buffer: scene.currentCamera.uCameraBuffer, encoderID: id)
			
			guard let materialUniformBuffer = materiable.1.getUniformBuffers() else {
				fatalError("Uniform buffer of material is nil")
			}
			
			for buffer in materialUniformBuffer {
				renderer.bind(buffer: buffer, encoderID: id)
			}
			
			for drawableInstance in materiable.1.drawables {
				guard let uModelBuffer = drawableInstance.1.uModelBuffer else {
					fatalError("Model buffer for drawable instance is nil")
				}
				
				renderer.bind(buffer: uModelBuffer, encoderID: id)
				
				for buffer in drawableInstance.1.drawable.getBuffers() {
					renderer.bind(buffer: buffer, encoderID: id)
				}
				
				for textureInstance in materiable.1.textureInstances {
					let index = textureInstance.1.index
					let texture = textureInstance.1.texture.getTexture()
					
					renderer.encoder(withID: id).setFragmentTexture(texture, at: index)
				}
				
				renderer.encoder(withID: id).drawIndexedPrimitives(
						.triangle,
						indexCount: drawableInstance.1.drawable.getIndicesBuffer().count,
						indexType: .uInt32,
						indexBuffer: drawableInstance.1.drawable.getIndicesBuffer().buffer,
						indexBufferOffset: 0,
						instanceCount: uModelBuffer.count
				)
			}
		}
		
		for id in ids {
			DKRCore.instance.renderer.endFrame(id: id)
		}
	}
}
