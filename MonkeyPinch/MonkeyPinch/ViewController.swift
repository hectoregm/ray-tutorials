//
//  ViewController.swift
//  MonkeyPinch
//
//  Created by Hector Enrique Gomez Morales on 8/8/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {
  @IBOutlet var monkeyPan: UIPanGestureRecognizer!
  @IBOutlet var bananaPan: UIPanGestureRecognizer!
  var chompPlayer: AVAudioPlayer? = nil
  
  func loadSound(filename: NSString) -> AVAudioPlayer {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: "caf")
    var error: NSError? = nil
    let player = AVAudioPlayer(contentsOfURL: url, error: &error)
    if player == nil {
      println("Error loading \(url): \(error?.localizedDescription)")
    } else {
      player.prepareToPlay()
    }
    
    return player
  }
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let filteredSubviews = self.view.subviews.filter {
      $0.isKindOfClass(UIImageView)
    }
    
    for view in filteredSubviews {
      let recognizer = UITapGestureRecognizer(target:self, action:Selector("handleTap:"))
      
      recognizer.delegate = self
      view.addGestureRecognizer(recognizer)
      
      recognizer.requireGestureRecognizerToFail(monkeyPan)
      recognizer.requireGestureRecognizerToFail(bananaPan)
    }
    self.chompPlayer = self.loadSound("chomp")
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
  
  @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale)
    recognizer.scale = 1
  }
  
  @IBAction func handleRotate(recognizer: UIRotationGestureRecognizer) {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation)
    recognizer.rotation = 0
  }
  
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
    return true
  }
  
  func handleTap(recognizer: UITapGestureRecognizer) {
    self.chompPlayer?.play()
  }
}

