//
//  RWTPage.m
//  NarratedBookUsingAVSpeech
//
//  Created by Republic of Apps, LLC on 2/1/14.
//  Copyright (c) 2014 RepublicOfApps, LLC. All rights reserved.
//

#import "RWTPage.h"
@import AVFoundation;

#pragma mark - External Constants

NSString* const RWTPageAttributesKeyUtterances = @"utterances";
NSString* const RWTPageAttributesKeyBackgroundImage = @"backgroundImage";
NSString* const RWTUtteranceAttributesKeyUtteranceString = @"utteranceString";
NSString* const RWTUtteranceAttributesKeyUtteranceProperties = @"utteranceProperties";

#pragma mark - Class Extension

@interface RWTPage ()
@property (nonatomic, strong, readwrite) NSString *displayText;
@property (nonatomic, strong, readwrite) NSArray *utterances;
@property (nonatomic, strong, readwrite) UIImage *backgroundImage;
@end

@implementation RWTPage

#pragma mark - Public

+ (instancetype)pageWithAttributes:(NSDictionary*)attributes
{
  RWTPage *page = [[RWTPage alloc] init];

  if ([[attributes objectForKey:RWTPageAttributesKeyUtterances] isKindOfClass:[NSString class]]) {
    // 1
    page.displayText = [attributes objectForKey:RWTPageAttributesKeyUtterances];
    page.backgroundImage = [attributes objectForKey:RWTPageAttributesKeyBackgroundImage];
    
    page.utterances = @[[[AVSpeechUtterance alloc] initWithString:page.displayText]];
  } else if ([[attributes objectForKey:RWTPageAttributesKeyUtterances] isKindOfClass:[NSArray class]]) {
    // 2
    NSMutableArray *utterances = [NSMutableArray arrayWithCapacity:31];
    NSMutableString *displayText = [NSMutableString stringWithCapacity:101];
    
    // 3
    for (NSDictionary *utteranceAttributes in [attributes objectForKey:RWTPageAttributesKeyUtterances]) {
      // 4
      NSString *utteranceString =
      [utteranceAttributes objectForKey:RWTUtteranceAttributesKeyUtteranceString];
      NSDictionary *utteranceProperties =
      [utteranceAttributes objectForKey:RWTUtteranceAttributesKeyUtteranceProperties];
      
      // 5
      AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:utteranceString];
      // 6
      [utterance setValuesForKeysWithDictionary:utteranceProperties];
      
      if (utterance) {
        // 7
        [utterances addObject:utterance];
        [displayText appendString:utteranceString];
      }
    }
    
    // 8
    page.displayText = displayText;
    page.backgroundImage = [UIImage imageNamed:[attributes objectForKey:RWTPageAttributesKeyBackgroundImage]];
    page.utterances = [utterances copy];
  }

  return page;
}

@end
