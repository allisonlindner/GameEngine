//
//  DKGGameManager.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//



public class DKGGameManager {
	public static let instance = DKGGameManager()
	
	public var sManager: DKGSceneManager
	public var cManager: DKGComponentManager
	
	internal init() {
		self.sManager = DKGSceneManager()
		self.cManager = DKGComponentManager()
	}
}