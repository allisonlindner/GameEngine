//
//  ViewController.swift
//  -PROJECT-NAME-
//
//  Created by Allison Lindner on 24/11/16.
//  Copyright © 2016 -ORGANIZATION-NAME-. All rights reserved.
//

import UIKit
import DrakkenEngine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameView = self.view as! GameView
        
        gameView.load(projectURL: Bundle.main.url(forResource: "Assets",
                                                  withExtension: nil)!.deletingLastPathComponent())
        gameView.load(scene: "-SCENE-NAME-")
        gameView.state = .PLAY
        
        gameView.Init()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

