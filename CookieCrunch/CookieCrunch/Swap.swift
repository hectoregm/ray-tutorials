//
//  Swap.swift
//  CookieCrunch
//
//  Created by Hector Enrique Gomez Morales on 7/22/14.
//  Copyright (c) 2014 Hector Enrique Gomez Morales. All rights reserved.
//

class Swap: Printable {
    var cookieA: Cookie
    var cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie) {
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var description: String {
       return "swap \(cookieA) with \(cookieB)"
    }
}
