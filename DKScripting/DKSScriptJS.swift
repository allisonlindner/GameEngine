//
//  DKSScriptJS.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 29/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Foundation
import JavaScriptCore

internal struct DKSScriptJS {
	private var _context: JSContext
	internal var name: String

	internal init(name: String) {
		self._context = JSContext()
		self.name = name
		self._context.name = name
	}
	
	internal func evaluate(script script: String) {
		self._context.evaluateScript(script)
	}

	internal func evaluate(script script: NSURL) {
		do {
			let fileString = try String(contentsOfURL: script)
			
			self.evaluate(script: fileString)
		} catch {
			NSLog("Script file error")
		}
	}

	internal func evaluate(filePath filePath: String) {
		let fileURL = NSURL(fileURLWithPath: filePath)
		
		self.evaluate(script: fileURL)
	}

	internal func call(function function: String, arguments: AnyObject...) {
		let function = self._context.objectForKeyedSubscript(function)
		
		function.callWithArguments(arguments)
	}

	internal func set(object obj: AnyObject, name: String) {
		self._context.setObject(obj, forKeyedSubscript: name)
	}

	internal func function(name: String, _ function: Any) {
		self._context.setObject(
				unsafeBitCast(function, AnyObject.self),
				forKeyedSubscript: name
		)
	}
}