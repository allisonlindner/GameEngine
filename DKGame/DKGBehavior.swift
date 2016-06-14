//
//  DKGBehavior.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 07/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//


public class DKGBehavior {
	internal var internalActor: DKGActor!
	public var actor: DKGActor! {
		get {
			return internalActor
		}
	}
	
	public init() {}
	
	public func start() {}
	public func update() {}
}