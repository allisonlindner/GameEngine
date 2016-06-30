//
//  DKSActorExports.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 30/06/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc public protocol DKSActorExports: JSExport {
	func setPosition(_ x: NSNumber, _ y: NSNumber)
	func setZ(_ z: NSNumber)
	func setSize(_ width: NSNumber, height: NSNumber)
	func setZRotation(_ z: NSNumber)
}