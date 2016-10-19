//
//  Serializable.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 19/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation

internal protocol Serializable {
    func toDict() -> [String: JSON]
}
