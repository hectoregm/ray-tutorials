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
    
    if recognizer.state == .Ended {
      let velocity = recognizer.velocityInView(self.view)
      let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
      let slideMultiplier = magnitude / 200
      println("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
      
      let slideFactor = 0.1 * slideMultiplier
      var finalPoint = CGPoint(x: recognizer.view.center.x + (velocity.x * slideFactor),
        y: recognizer.view.center.y + (velocity.y * slideFactor))
      
      finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
      finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
      
      UIView.animateWithDuration(Double(slideFactor * 2),
        delay: 0,
        options: .CurveEaseOut,
        animations: {recognizer.view.center = finalPoint},
        completion: nil)
    }
  }
}

