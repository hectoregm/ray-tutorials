//
//  RWTPage.m
//  NarratedBookUsingAVSpeech
//
//  Created by Republic of Apps, LLC on 2/1/14.
//  Copyright (c) 2014 RepublicOfApps, LLC. All rights reserved.
//

#import "RWTPage.h"

#pragma mark - External Constants

NSString* const RWTPageAttributesKeyUtterances = @"utterances";
NSString* const RWTPageAttributesKeyBackgroundImage = @"backgroundImage";

#pragma mark - Class Extension

@interface RWTPage ()
@property (nonatomic, strong, readwrite) NSString *displayText;
@property (nonatomic, strong, readwrite) UIImage *backgroundImage;
@end

@implementation RWTPage

#pragma mark - Public

+ (instancetype)pageWithAttributes:(NSDictionary*)attributes
{
  RWTPage *page = [[RWTPage alloc] init];

  page.displayText = [attributes objectForKey:RWTPageAttributesKeyUtterances];
  page.backgroundImage = [attributes objectForKey:RWTPageAttributesKeyBackgroundImage];

  return page;
}

@end
