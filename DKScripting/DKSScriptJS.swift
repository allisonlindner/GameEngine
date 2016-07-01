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

	internal init(name: String, script: String, actor: DKGActor) {
		self._context = JSContext()
		self.name = name
		self._context.name = name
		
		let consoleLog: @convention(block) String -> Void = { message in
			NSLog(message as String)
		}
		
		self.set(object: actor, name: "actor")
		DKSScriptManager.instance.add(scriptJS: self, actor: actor)
		self._context.setObject(unsafeBitCast(consoleLog, AnyObject.self), forKeyedSubscript: "consoleLog")
		
		evaluate(script: script)
		evaluate(script: "var script\(self.name) = new \(self.name)();")
	}
	
	internal init(name: String, script: NSURL, actor: DKGActor) {
		var fileString: String = ""
		
		do {
			fileString = try String(contentsOfURL: script)
		} catch {
			NSLog("Script file error")
		}
		
		self.init(name: name, script: fileString, actor: actor)
	}
	
	private func evaluate(script script: String) {
		self._context.evaluateScript(script)
	}

	private func evaluate(script script: NSURL) {
		do {
			let fileString = try String(contentsOfURL: script)
			
			self.evaluate(script: fileString)
		} catch {
			NSLog("Script file error")
		}
	}

	private func evaluate(filePath filePath: String) {
		let fileURL = NSURL(fileURLWithPath: filePath)
		
		self.evaluate(script: fileURL)
	}

	internal func call(function function: String, arguments: AnyObject...) {
		let classVar = self._context.objectForKeyedSubscript("script\(self.name)")
		classVar.invokeMethod(function, withArguments: arguments)
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