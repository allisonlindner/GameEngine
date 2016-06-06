//
//  DKRSimpleRenderer.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

internal class DKRSimpleRenderer: DKRGraphRenderer {
	func draw(graph: DKRSceneGraph) {
		var ids: [Int] = []
		
		if graph.screenChange {
			if let scene = graph.scene {
				scene.currentCamera.changeSize(Float(graph.size.width), Float(graph.size.height))
				graph.screenChange = false
			}
		}
		
		if let scene = graph.scene {
			guard let renderTexture = scene.renderTexture else {
				print("No render texture found on scene")
				return
			}
			
			let id = DKRCore.instance.renderer.startFrame(texture: renderTexture)
			ids.append(id)
			for materiable in scene.materiables {
				let rcState = materiable.1.shader.rpState
				
				let renderer = DKRCore.instance.renderer
				
				renderer.encoder(withID: id).setRenderPipelineState(rcState)
				
				renderer.bind(scene.currentCamera.uCameraBuffer, encoderID: id)
				
				for buffer in materiable.1.getUniformBuffers() {
					renderer.bind(buffer, encoderID: id)
				}
				
				for drawableInstance in materiable.1.drawables {
					guard let uModelBuffer = drawableInstance.1.uModelBuffer else {
						return print("Model buffer for drawable instance is nil")
					}
					
					renderer.bind(uModelBuffer, encoderID: id)
					
					for buffer in drawableInstance.1.drawable.getBuffers() {
						renderer.bind(buffer, encoderID: id)
					}
					
					for textureInstance in materiable.1.textureInstances {
						let index = textureInstance.index
						let texture = textureInstance.texture.getTexture()
						
						renderer.encoder(withID: id).setFragmentTexture(texture, atIndex: index)
					}
					
					renderer.encoder(withID: id).drawIndexedPrimitives(
							.Triangle,
							indexCount: drawableInstance.1.drawable.getIndicesBuffer().count,
							indexType: .UInt32,
							indexBuffer: drawableInstance.1.drawable.getIndicesBuffer().buffer,
							indexBufferOffset: 0,
							instanceCount: uModelBuffer.count
					)
				}
			}
		}
		
		for id in ids {
			DKRCore.instance.renderer.endFrame(id)
		}
	}
}