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
  var connection: NSURLConnection!
  
  override class func canInitWithRequest(request: NSURLRequest) -> Bool {
    println("Request #\(requestCount++): URL = \(request.URL.absoluteString)")
    return true
  }
  
  override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
    return request
  }
  
  override class func requestIsCacheEquivalent(aRequest: NSURLRequest, toRequest bRequest: NSURLRequest) -> Bool {
    return super.requestIsCacheEquivalent(aRequest, toRequest: bRequest)
  }
  
  override func startLoading() {
    self.connection = NSURLConnection(request: self.request, delegate: self)
  }
  
  override func stopLoading() {
    if self.connection != nil {
      self.connection.cancel()
    }
    
    self.connection = nil
  }
}
