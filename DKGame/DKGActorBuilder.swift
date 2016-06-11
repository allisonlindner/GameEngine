//
//  DKGActorBuilder.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import DKRender

public class DKGActorBuilder {
	private var _actor: DKGActor?
	
	public func new(label: String? = nil, tag: String? = nil) -> Self {
		_actor = DKGActor(label: label, tag: tag)
		
		_actor!.id = DKGGameManager.instance.cManager.addComponent(_actor!)
		
		return self
	}
	
	public func setSprite(name: String, texture: String) -> Self {
		guard let actor = _actor else {
			fatalError("You must use 'new' function before this")
		}
		
		actor.sprite = DKGSprite(name: name, texture: texture)
		
		return self
	}
	
	public func create() -> DKGActor {
		if _actor == nil {
			fatalError("You must use 'new' function before creating actor")
		}
		
		return _actor!
	}
}