//
//  ViewController.swift
//  DynamicsDemo
//
//  Created by Hector Enrique Gomez Morales on 8/20/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var animator: UIDynamicAnimator!
  var gravity: UIGravityBehavior!
  var collision: UICollisionBehavior!
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    let square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    square.backgroundColor = UIColor.grayColor()
    view.addSubview(square)
    
    let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
    barrier.backgroundColor = UIColor.redColor()
    view.addSubview(barrier)
    
    animator = UIDynamicAnimator(referenceView: view)
    gravity = UIGravityBehavior(items: [square])
    animator.addBehavior(gravity)
    
    collision = UICollisionBehavior(items: [square, barrier])
    collision.translatesReferenceBoundsIntoBoundary = true
    animator.addBehavior(collision)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

