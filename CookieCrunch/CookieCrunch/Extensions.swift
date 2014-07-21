//
//  Extensions.swift
//  CookieCrunch
//
//  Created by Hector Enrique Gomez Morales on 7/21/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//
import Foundation

extension Dictionary {
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json")
        if !path {
            println("Could not find level file: \(filename)")
            return nil
        }
        
        var error: NSError?
        let data: NSData? = NSData(contentsOfFile: path, options: NSDataReadingOptions(), error: &error)
        
        if !data {
            println("Could not load level file: \(filename), error: \(error!)")
            return nil
        }
        
        let dictionary: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
        
        if !dictionary {
            println("Level file '\(filename)' is not valid JSON: \(error!)")
            return nil
        }
        
        return dictionary as? Dictionary<String, AnyObject>
    }
}