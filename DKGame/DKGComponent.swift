//
//  DKGComponent.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 07/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//


public protocol DKGComponent {
	var name: String { get set }
	var label: String? { get set }
	var tag: String? { get set }
	var id: Int! { get set }
	
	var transform: DKMTransform { get set }

func start()
	func update()
}