//
//  RWTBook.h
//  NarratedBookUsingAVSpeech
//
//  Created by Republic of Apps, LLC on 2/1/14.
//  Copyright (c) 2014 RepublicOfApps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTBook : NSObject

@property (nonatomic, copy, readonly) NSArray *pages;

+ (instancetype)bookWithPages:(NSArray*)pages;
+ (instancetype)testBook;

@end
