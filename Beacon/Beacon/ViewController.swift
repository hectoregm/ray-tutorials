//
//  ViewController.swift
//  Beacon
//
//  Created by Hector Enrique Gomez Morales on 8/3/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
  @IBOutlet weak var statusLabel: UILabel!
  var myBeaconRegion: CLBeaconRegion!
  var myBeaconData: [NSObject:AnyObject]!
  var peripheralManager: CBPeripheralManager!
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create a NSUUID object
    var uuid = NSUUID(UUIDString: "BD989F5B-E688-4852-9E8E-73008EB2D425")
    
    // Initialize the Beacon Region
    self.myBeaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 1, minor: 1, identifier: "com.hectoregm.testregion")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func buttonClicked(sender: AnyObject) {
    self.myBeaconData = self.myBeaconRegion.peripheralDataWithMeasuredPower(nil)
    self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
  }
  
  func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
    switch peripheral.state {
    case .PoweredOn:
      // Bluetooth is on
      self.statusLabel.text = "Broadcasting..."
      self.peripheralManager.startAdvertising(self.myBeaconData)
    case .PoweredOff:
      // Bluetooth is off
      self.statusLabel.text = "Stopped"
      self.peripheralManager .stopAdvertising()
    default:
      self.statusLabel.text = "Unsupported"
    }
  }
}

