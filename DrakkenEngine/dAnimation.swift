//
//  dAnimation.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 01/09/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//


public class dAnimation {
	internal var name: String
	internal var sequence: [Int]
	internal var repeatX: Int
	
	public init(name: String, repeatX: Int, sequence: Int...) {
		self.name = name
		self.repeatX = repeatX
		self.sequence = sequence
	}
}
