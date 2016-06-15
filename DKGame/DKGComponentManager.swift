//
//  DKGComponentManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//



public class DKGComponentManager {
	internal var components: [Int : DKGComponent]
	
	public var allComponents: [DKGComponent] {
		get {
			return components.map({ (comp) -> DKGComponent in
				return comp.1
			})
		}
	}
	
	public var allActors: [DKGActor] {
		get {
			return components.flatMap({ (comp) -> DKGActor? in
				if comp.1 is DKGActor {
					return comp.1 as? DKGActor
				}
				
				return nil
			})
		}
	}
	
	private var _nextComponentIndex: Int
	
	internal init() {
		self.components = [:]
		
		self._nextComponentIndex = 0
	}
	
	internal func addComponent(_ component: DKGComponent) -> Int {
		let index = self._nextComponentIndex
		self.components[index] = component
		self._nextComponentIndex += 1
		
		return index
	}
	
	public func getComponents(label: String) -> [DKGComponent]? {
		let flatComponents = components.flatMap { (component) -> DKGComponent? in
			if component.1.label == label {
				return component.1
			} else {
				return nil
			}
		}
		
		if flatComponents.count > 0 {
			return flatComponents
		}
		return nil
	}
	
	public func getComponents(tag: String) -> [DKGComponent]? {
		let flatComponents = components.flatMap { (component) -> DKGComponent? in
			if component.1.tag == tag {
				return component.1
			} else {
				return nil
			}
		}
		
		if flatComponents.count > 0 {
			return flatComponents
		}
		return nil
	}
}
