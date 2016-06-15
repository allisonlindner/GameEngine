//
//  DKError.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 13/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

//MARK: Errors
public class DKError: ErrorProtocol {
	public var description: String
	public var cause: ErrorProtocol?
	
	internal init(description: String, cause: ErrorProtocol? = nil) {
		self.description = description
		self.cause = cause
	}
}

//MARK: Shader not found error
public class DKShaderNotFoundError: DKError {
	internal init(name: String) {
		super.init(description: "Shader with name: \(name) was not found!")
	}
}

//MARK: Invalid argument error
public class DKInvalidArgumentError: DKError {}

//MARK: Invalid texture name
public class DKInvalidTextureNameError: DKError {
	internal init(textureName: String) {
		super.init(description: "\(textureName): Invalid testure name")
	}
}
