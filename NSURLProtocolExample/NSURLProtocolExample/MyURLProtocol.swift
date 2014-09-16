//
//  MyURLProtocol.swift
//  NSURLProtocolExample
//
//  Created by Hector Enrique Gomez Morales on 9/15/14.
//  Copyright (c) 2014 Zedenem. All rights reserved.
//

import UIKit

var requestCount = 0

class MyURLProtocol: NSURLProtocol {
  override class func canInitWithRequest(request: NSURLRequest) -> Bool {
    println("Request #\(requestCount++): URL = \(request.URL.absoluteString)")
    return false
  }
}
