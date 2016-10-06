//
//  dJSScript.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 03/10/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc internal protocol dJSScriptExport: JSExport {
    var transform: dTransformExport { get set }
}

public class dJSScript: dComponent, dJSScriptExport {
    internal var jsContext: JSContext
    internal var transform: dTransformExport!
    internal var script: String
    
    public init(script: String) {
        self.jsContext = JSContext()
        self.script = script
        
        super.init()
        
        let consoleLog: @convention(block) (String) -> Void = { message in
            NSLog(message as String)
        }
        
        self.jsContext.setObject(unsafeBitCast(consoleLog, to: AnyObject.self), forKeyedSubscript: NSString(string: "consoleLog"))
    }
    
    public convenience init(fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "js", subdirectory: "Assets/scripts") {
            var fileString: String = ""
            
            do {
                fileString = try String(contentsOf: url)
            } catch {
                NSLog("Script file error")
            }
            
            self.init(script: fileString)
        } else {
            self.init(script: " ")
        }
    }
    
    internal func set(transform: dTransform) {
        self.transform = transform
        
        self.jsContext.setObject(self, forKeyedSubscript: NSString(string: "$"))
        self.jsContext.evaluateScript(
            "var transform = $.transform;"
        )
        
        self.jsContext.evaluateScript(
            "\(script)"
        )
    }
    
    internal func run(function: String) {
        self.jsContext.evaluateScript(
            "\(function)();"
        )
    }
}
