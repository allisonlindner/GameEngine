//
//  DKSScriptBuilder.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 30/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Foundation

public class DKSScriptBuilder {
	private var _script: DKSScriptJS!
	
	public init() {}
	
	public func new(name: String) -> Self {
		_script = DKSScriptJS(name: name)
		return self
	}
	
	public func add(script script: String) -> Self {
		_script.evaluate(script: script)
		return self
	}
	
	public func add(script script: NSURL) -> Self {
		_script.evaluate(script: script)
		return self
	}
	
	public func add(fileName name: String) -> Self {
		let url = NSBundle.mainBundle().URLForResource(name, withExtension: "js")
		if url != nil {
			add(script: url!)
		}
		return self
	}
	
	public func create(on actor: DKGActor) {
		DKSScriptManager.instance.add(scriptJS: _script, actor: actor)
	}
}