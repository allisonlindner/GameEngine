//
//  DKGComponentManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//



public class DKGComponentManager {
	internal var components: [Int : DKGComponent]
	
	private var _nextComponentIndex: Int
	
	internal init() {
		self.components = [:]
		
		self._nextComponentIndex = 0
	}
	
	internal func addComponent(component: DKGComponent) -> Int {
		let index = self._nextComponentIndex
		self.components[index] = component
		self._nextComponentIndex += 1
		
		return index
	}
	
	internal func getComponents(label label: String) -> [DKGComponent]? {
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
	
	internal func getComponents(tag tag: String) -> [DKGComponent]? {
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