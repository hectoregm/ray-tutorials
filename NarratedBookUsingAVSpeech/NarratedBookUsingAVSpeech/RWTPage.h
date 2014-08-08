//
//  RWTPage.h
//  NarratedBookUsingAVSpeech
//
//  Created by Republic of Apps, LLC on 2/1/14.
//  Copyright (c) 2014 RepublicOfApps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const RWTPageAttributesKeyUtterances;
extern NSString* const RWTPageAttributesKeyBackgroundImage;

@interface RWTPage : NSObject

@property (nonatomic, strong, readonly) NSString *displayText;
@property (nonatomic, strong, readonly) UIImage *backgroundImage;

+ (instancetype)pageWithAttributes:(NSDictionary*)attributes;

@end
