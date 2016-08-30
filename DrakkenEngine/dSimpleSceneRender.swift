//
//  dSimpleSceneRender.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 26/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import simd
import Metal
import MetalKit

fileprivate class dMaterialMeshBind {
	fileprivate var material: dMaterialData!
	fileprivate var mesh: dMeshData!
	fileprivate var instanceTransforms: [dTransform] = []
	fileprivate var instanceTexCoordIDs: [Int] = []
}

internal class dSimpleSceneRender {
	private var renderGraph: [String : [String : dMaterialMeshBind]] = [:]
	private var ids: [Int] = []
	private var _scene: dScene!
	
	public init(scene: dScene) {
		self._scene = scene
		self.process(transforms: scene.transforms)
	}
	
	internal func process(transforms: [dTransform]) {
		for transform in transforms {
			self.process(components: transform.components)
			self.process(transforms: transform.childrenTransforms)
		}
	}
	
	internal func process(components: [dComponent]) {
		for component in components {
			switch component.self {
			case is dMeshRender:
				let meshRender = component as! dMeshRender
				if meshRender.material != nil {
					if meshRender.mesh != nil {
						process(mesh: meshRender.mesh!,
						        with: meshRender.material!,
						        transform: meshRender.parentTransform!)
					}
				}
				break
			default:
				break
			}
		}
	}
	
	internal func process(mesh: String, with material: String, transform: dTransform) {
		if dCore.instance.mshManager.get(mesh: mesh) != nil {
			//Link mesh with the same material
			
			if renderGraph[material] != nil {
				if let materialMeshBind = renderGraph[material]![mesh] {
					materialMeshBind.instanceTransforms.append(transform)
				} else {
					let materialMeshBind = dMaterialMeshBind()
					materialMeshBind.material = dCore.instance.mtManager.get(material: material)
					materialMeshBind.mesh = dCore.instance.mshManager.get(mesh: mesh)
					materialMeshBind.instanceTransforms.append(transform)
					materialMeshBind.instanceTexCoordIDs.append(0)
					
					renderGraph[material]![mesh] = materialMeshBind
				}
			} else {
				renderGraph[material] = [:]
				let materialMeshBind = dMaterialMeshBind()
				materialMeshBind.material = dCore.instance.mtManager.get(material: material)
				materialMeshBind.mesh = dCore.instance.mshManager.get(mesh: mesh)
				materialMeshBind.instanceTransforms.append(transform)
				materialMeshBind.instanceTexCoordIDs.append(0)
				
				renderGraph[material]![mesh] = materialMeshBind
			}
		}
	}
	
	internal func generateBufferOf(transforms: [dTransform]) -> dBufferable {
		var matrixArray: [float4x4] = []
		for transform in transforms {
			matrixArray.append(transform.worldMatrix4x4)
		}
		
		return dBuffer<float4x4>(data: matrixArray, index: 1)
	}
	
	internal func generateBufferOf(texCoordsIDs: [Int]) -> dBufferable {
		return dBuffer<Int>(data: texCoordsIDs, index: 5)
	}
	
	internal func draw(drawable: CAMetalDrawable) {
		let id = dCore.instance.renderer.startFrame(drawable.texture)
		self.ids.append(id)
		
		let renderer = dCore.instance.renderer
		
		let projectionMatrix = dMath.newOrtho(			-_scene.size.x/2.0,
											  right:		 _scene.size.x/2.0,
											  bottom:	-_scene.size.y/2.0,
											  top:		 _scene.size.y/2.0,
											  near:		-1000,
											  far:		 1000)
		
		let viewMatrix = dMath.newTranslation(float3(0.0, 0.0, -500.0))
		
		let uCamera = dCameraUniform(viewMatrix: viewMatrix, projectionMatrix: projectionMatrix)
		
		let uCameraBuffer = dBuffer<dCameraUniform>(data: uCamera, index: 0)
		
		renderer?.bind(uCameraBuffer, encoderID: id)
		
		for m in renderGraph {
			for materialMeshBind in m.value {
				let transformBuffer = generateBufferOf(transforms: materialMeshBind.value.instanceTransforms)
				let texCoordIDs = generateBufferOf(texCoordsIDs: materialMeshBind.value.instanceTexCoordIDs)
				
				renderer?.bind(materialMeshBind.value.material, encoderID: id)
				renderer?.bind(texCoordIDs, encoderID: id)
				renderer?.draw(materialMeshBind.value.mesh, encoderID: id, modelMatrixBuffer: transformBuffer)
			}
		}
		
		renderer?.endFrame(id)
		renderer?.present(drawable)
	}
}
