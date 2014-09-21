//
//  MyURLProtocol.swift
//  NSURLProtocolExample
//
//  Created by Hector Enrique Gomez Morales on 9/15/14.
//  Copyright (c) 2014 Zedenem. All rights reserved.
//

import UIKit
import CoreData

var requestCount = 0

class MyURLProtocol: NSURLProtocol {
  var connection: NSURLConnection!
  var mutableData: NSMutableData!
  var response: NSURLResponse!
  
  func saveCachedResponse() {
    let delegate = UIApplication.sharedApplication().delegate as AppDelegate
    let context = delegate.managedObjectContext!
    
    let cachedResponse = NSEntityDescription.insertNewObjectForEntityForName("CachedURLResponse", inManagedObjectContext: context) as NSManagedObject
    
    cachedResponse.setValue(self.mutableData, forKey: "data")
    cachedResponse.setValue(self.request.URL.absoluteString, forKey: "url")
    cachedResponse.setValue(NSDate(), forKey: "timestamp")
    cachedResponse.setValue(self.response.MIMEType, forKey: "mimetype")
    cachedResponse.setValue(self.response.textEncodingName, forKey: "encoding")
    
    var error: NSError?
    let sucess = context.save(&error)
    if !sucess {
      println("Could not cached the response")
    }
  }
  
  override class func canInitWithRequest(request: NSURLRequest) -> Bool {
    println("Request #\(requestCount++): URL = \(request.URL.absoluteString)")
    
    if NSURLProtocol.propertyForKey("MyURLProtocolHandledKey", inRequest: request) != nil {
      return false
    }
    return true
  }
  
  override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
    return request
  }
  
  override class func requestIsCacheEquivalent(aRequest: NSURLRequest, toRequest bRequest: NSURLRequest) -> Bool {
    return super.requestIsCacheEquivalent(aRequest, toRequest: bRequest)
  }
  
  override func startLoading() {
    var newRequest = self.request.copy() as NSMutableURLRequest
    NSURLProtocol.setProperty(true, forKey: "MyURLProtocolHandledKey", inRequest: newRequest)

    self.connection = NSURLConnection(request: newRequest, delegate: self)
  }
  
  override func stopLoading() {
    if self.connection != nil {
      self.connection.cancel()
    }
    
    self.connection = nil
  }
  
  func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
    self.client!.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
    
    self.response = response
    self.mutableData = NSMutableData()
  }
  
  func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
    self.client!.URLProtocol(self, didLoadData: data)
    self.mutableData.appendData(data)
  }
  
  func connectionDidFinishLoading(connection: NSURLConnection!) {
    self.client!.URLProtocolDidFinishLoading(self)
    self.saveCachedResponse()
  }
  
  func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
    self.client!.URLProtocol(self, didFailWithError: error)
  }
}
