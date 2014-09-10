//
//  TipInCellAnimator.swift
//  CardTilt
//
//  Created by Hector Enrique Gomez Morales on 9/1/14.
//  Copyright (c) 2014 RayWenderlich.com. All rights reserved.
//

import UIKit

class TipInCellAnimator {
  class func animate(cell:UITableViewCell) {
    let view = cell.contentView
    view.layer.opacity = 0.1
    UIView.animateWithDuration(1.4) {
      view.layer.opacity = 1
    }
  }
}