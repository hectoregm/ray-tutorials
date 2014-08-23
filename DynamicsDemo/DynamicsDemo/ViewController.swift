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
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    let square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    square.backgroundColor = UIColor.grayColor()
    view.addSubview(square)
    
    animator = UIDynamicAnimator(referenceView: view)
    gravity = UIGravityBehavior(items: [square])
    animator.addBehavior(gravity)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

