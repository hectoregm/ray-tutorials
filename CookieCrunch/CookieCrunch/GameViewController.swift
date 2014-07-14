//
//  GameViewController.swift
//  CookieCrunch
//
//  Created by Hector Enrique Gomez Morales on 7/14/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController : UIViewController {
    var scene: GameScene!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }
}