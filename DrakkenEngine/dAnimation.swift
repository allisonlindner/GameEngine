//
//  dAnimation.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 01/09/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//


public class dAnimation {
	internal var name: String
	internal var sequence: [(frame: Int32, time: Float)]
	internal var repeatX: Int
	
	public init(name: String, repeatX: Int, sequence: (frame: Int32, time: Float)...) {
		self.name = name
		self.repeatX = repeatX
		self.sequence = sequence
	}
}
