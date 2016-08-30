//
//  DKError.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 13/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

//MARK: Errors
public class dError: Error {
	public var description: String
	public var cause: Error?
	
	internal init(description: String, cause: Error? = nil) {
		self.description = description
		self.cause = cause
	}
}

//MARK: Shader not found error
public class dShaderNotFoundError: dError {
	internal init(name: String) {
		super.init(description: "Shader with name: \(name) was not found!")
	}
}

//MARK: Invalid argument error
public class dInvalidArgumentError: dError {}

//MARK: Invalid texture name
public class dInvalidTextureNameError: dError {
	internal init(textureName: String) {
		super.init(description: "\(textureName): Invalid testure name")
	}
}
