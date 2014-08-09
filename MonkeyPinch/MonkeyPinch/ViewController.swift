//
//  ViewController.swift
//  MonkeyPinch
//
//  Created by Hector Enrique Gomez Morales on 8/8/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
    let translation = recognizer.translationInView(self.view)
    recognizer.view.center = CGPoint(x: recognizer.view.center.x + translation.x,
      y: recognizer.view.center.y + translation.y)
    recognizer.setTranslation(CGPointZero, inView: self.view)
  }
}

