//
//  dComponent.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 22/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import JavaScriptCore

public class dComponent: NSObject {
    private var _parentTransform: dTransform?
	internal var parentTransform: dTransform? {
		return _parentTransform
	}
	
	private var _dependences: [dComponent] = []
	
	internal func set(parent: dTransform) {
		self._parentTransform = parent
		
		for dependence in _dependences {
			parent.add(component: dependence)
		}
	}
	
	internal func add(dependence: dComponent) -> dComponent {
		if dependence === dMeshRender.self {
			for d in _dependences {
				if d === dMeshRender.self {
					return d
				}
			}
		}
		
		self._dependences.append(dependence)
		return dependence
	}
    
    internal func toDict() -> [String: JSON] {
        return [:]
    }
}
