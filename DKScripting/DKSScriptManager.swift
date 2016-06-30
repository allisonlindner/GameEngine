//
// Created by Allison Lindner on 30/06/16.
// Copyright (c) 2016 Allison Lindner. All rights reserved.
//

import Foundation
import JavaScriptCore

internal class DKSScriptManager {
	internal static let instance = DKSScriptManager()

	internal var scripts: [Int : [DKSScriptJS]]

	internal init () {
		scripts = [:]
	}

	internal func add(scriptJS script: DKSScriptJS, actor: DKGActor) {
		script.set(object: actor, name: "actor")
		if scripts[actor.id] == nil {
			scripts[actor.id] = []
		}
		scripts[actor.id]!.append(script)
	}
}