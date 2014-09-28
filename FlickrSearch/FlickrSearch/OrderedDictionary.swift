//
//  OrderedDictionary.swift
//  FlickrSearch
//
//  Created by Hector Enrique Gomez Morales on 9/27/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation

struct OrderedDictionary<KeyType: Hashable, ValueType> {
  typealias ArrayType  = [KeyType]
  typealias DictionaryType = [KeyType: ValueType]
  
  var array = ArrayType()
  var dictionary = DictionaryType()
}
