//
//  DKGActorBuilder.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//


public class DKGActorBuilder {
	private var _actor: DKGActor?
	
	public init() {
		
	}
	
	public func new(_ name: String, label: String? = nil, tag: String? = nil) -> Self {
		_actor = DKGActor(name: name, label: label, tag: tag)
		
		_actor!.id = DKGGameManager.instance.cManager.addComponent(_actor!)
		
		return self
	}
	
	public func setSprite(_ sprite: DKGSprite) -> Self {
		guard let actor = _actor else {
			fatalError("You must use 'new' function before this")
		}
		
		actor.sprite = sprite
		actor.sprite.addInstance(actor.transform)
		
		return self
	}
	
	public func create() -> DKGActor {
		if _actor == nil {
			fatalError("You must use 'new' function before creating actor")
		}
		
		return _actor!
	}
}
