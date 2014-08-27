//
//  ViewController.swift
//  DynamicsDemo
//
//  Created by Hector Enrique Gomez Morales on 8/20/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
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
    
    collision = UICollisionBehavior(items: [square])
    collision.addBoundaryWithIdentifier("barrier", forPath: UIBezierPath(rect: barrier.frame))
    collision.translatesReferenceBoundsIntoBoundary = true
    
//    collision.action = {
//      println("\(NSStringFromCGAffineTransform(square.transform)) \(NSStringFromCGPoint(square.center))")
//    }
    collision.collisionDelegate = self
    animator.addBehavior(collision)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func collisionBehavior(behavior: UICollisionBehavior!, beganContactForItem item: UIDynamicItem!, withBoundaryIdentifier identifier: NSCopying!, atPoint p: CGPoint) {
    println("Boundary contact occurred - \(identifier)")
    let collidingView = item as UIView
    collidingView.backgroundColor = UIColor.yellowColor()
    UIView.animateWithDuration(0.3) {
      collidingView.backgroundColor = UIColor.grayColor()
    }
  }

}

