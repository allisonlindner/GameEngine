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
import Foundation

fileprivate class dMaterialMeshBind {
	fileprivate var material: dMaterialData!
	fileprivate var mesh: dMeshData!
	fileprivate var instanceTransforms: [dTransform] = []
	fileprivate var instanceTexCoordIDs: [Int32] = []
}

internal class dSimpleSceneRender {
	private var renderGraph: [String : [String : dMaterialMeshBind]] = [:]
	
	private var _animatorToBeUpdated: [(materialMeshBind: dMaterialMeshBind, index: Int, animator: dAnimator)] = []
	
	private var ids: [Int] = []
	private var _scene: dScene!
	
	internal init(scene: dScene) {
		self._scene = scene
		self.process(transforms: scene.transforms)
	}
	
	private func process(transforms: [dTransform]) {
		for transform in transforms {
			self.process(components: transform.components)
			self.process(transforms: transform.childrenTransforms)
		}
	}
	
	private func process(components: [dComponent]) {
		var materialMeshBind: dMaterialMeshBind? = nil
		var animatorToBeProcess: dAnimator? = nil
		var spriteToBeProcess: dSprite? = nil
		
		var hasSprite: Bool = false
		var hasAnimator: Bool = false
		
		for component in components {
			switch component.self {
			case is dMeshRender:
				let meshRender = component as! dMeshRender
				if meshRender.material != nil {
					if meshRender.mesh != nil {
						materialMeshBind = process(mesh: meshRender.mesh!,
						                           with: meshRender.material!,
						                           transform: meshRender.parentTransform!)
					}
				}
				break
			case is dSprite:
				hasSprite = true
				spriteToBeProcess = component as? dSprite
				break
			case is dAnimator:
				hasAnimator = true
				let animator = component as! dAnimator
				if materialMeshBind == nil {
					animatorToBeProcess = animator
				} else {
					self.process(animator: animator, materialMeshBind: materialMeshBind!)
					animatorToBeProcess = nil
				}
				break
			default:
				break
			}
			
			if component is dAnimator {
				if materialMeshBind != nil && animatorToBeProcess != nil {
					self.process(animator: component as! dAnimator, materialMeshBind: materialMeshBind!)
				}
			}
		}
		
		if hasSprite && !hasAnimator {
			if materialMeshBind != nil && spriteToBeProcess != nil {
				self.process(sprite: spriteToBeProcess!, materialMeshBind: materialMeshBind!)
			}
		}
	}
	
	private func process(mesh: String, with material: String, transform: dTransform) -> dMaterialMeshBind {
		if renderGraph[material] != nil {
			if let materialMeshBind = renderGraph[material]![mesh] {
				materialMeshBind.instanceTransforms.append(transform)
				return materialMeshBind
			} else {
				let materialMeshBind = dMaterialMeshBind()
				materialMeshBind.material = dCore.instance.mtManager.get(material: material)
				materialMeshBind.mesh = dCore.instance.mshManager.get(mesh: mesh)
				materialMeshBind.instanceTransforms.append(transform)
				
				renderGraph[material]![mesh] = materialMeshBind
				return materialMeshBind
			}
		} else {
			renderGraph[material] = [:]
			let materialMeshBind = dMaterialMeshBind()
			materialMeshBind.material = dCore.instance.mtManager.get(material: material)
			materialMeshBind.mesh = dCore.instance.mshManager.get(mesh: mesh)
			materialMeshBind.instanceTransforms.append(transform)
			
			renderGraph[material]![mesh] = materialMeshBind
			return materialMeshBind
		}
	}
	
	private func generateBufferOf(transforms: [dTransform]) -> dBufferable {
		var matrixArray: [float4x4] = []
		for transform in transforms {
			matrixArray.append(transform.worldMatrix4x4)
		}
		
		return dBuffer<float4x4>(data: matrixArray, index: 1)
	}
	
	private func process(animator: dAnimator, materialMeshBind: dMaterialMeshBind) {
		let index = materialMeshBind.instanceTexCoordIDs.count
		materialMeshBind.instanceTexCoordIDs.append(animator.frame)
		
		_animatorToBeUpdated.append((materialMeshBind: materialMeshBind,
		                             index: index,
		                             animator: animator))
	}
	
	private func process(sprite: dSprite, materialMeshBind: dMaterialMeshBind) {
		materialMeshBind.instanceTexCoordIDs.append(sprite.frame)
	}
	
	internal func update(deltaTime: Float) {
		for value in _animatorToBeUpdated {
			#if os(iOS)
				if #available(iOS 10, *) {
					let thread = Thread(block: {
						value.animator.update(deltaTime: deltaTime)
						value.materialMeshBind.instanceTexCoordIDs[value.index] = value.animator.frame
						return
					})
					thread.start()
				} else {
					value.animator.update(deltaTime: deltaTime)
					value.materialMeshBind.instanceTexCoordIDs[value.index] = value.animator.frame
				}
			#endif
			#if os(tvOS)
				if #available(tvOS 10, *) {
					let thread = Thread(block: {
						value.animator.update(deltaTime: deltaTime)
						value.materialMeshBind.instanceTexCoordIDs[value.index] = value.animator.frame
						return
					})
					thread.start()
				} else {
					value.animator.update(deltaTime: deltaTime)
					value.materialMeshBind.instanceTexCoordIDs[value.index] = value.animator.frame
				}
			#endif
			#if os(OSX)
				if #available(OSX 10.12, *) {
					let thread = Thread(block: {
						value.animator.update(deltaTime: deltaTime)
						value.materialMeshBind.instanceTexCoordIDs[value.index] = value.animator.frame
						return
					})
					thread.start()
				} else {
					value.animator.update(deltaTime: deltaTime)
					value.materialMeshBind.instanceTexCoordIDs[value.index] = value.animator.frame
				}
			#endif
		}
	}
	
	internal func draw(drawable: CAMetalDrawable) {
		
		// ######################## //
		// ######## UPDATE ######## //
		// ######################## //
		self.update(deltaTime: 0.016)
		// ######################## //
		// ######################## //
		
		
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
				let texCoordIDs = dBuffer<Int32>(data: materialMeshBind.value.instanceTexCoordIDs, index: 6)
				
				renderer?.bind(materialMeshBind.value.material, encoderID: id)
				renderer?.bind(texCoordIDs, encoderID: id)
				renderer?.draw(materialMeshBind.value.mesh, encoderID: id, modelMatrixBuffer: transformBuffer)
			}
		}
		
		renderer?.endFrame(id)
		renderer?.present(drawable)
	}
}
