//
//  RWTBook.m
//  NarratedBookUsingAVSpeech
//
//  Created by Republic of Apps, LLC on 2/1/14.
//  Copyright (c) 2014 RepublicOfApps, LLC. All rights reserved.
//

#import "RWTBook.h"
#import "RWTPage.h"

#pragma mark - Class Extension

@interface RWTBook ()
@property (nonatomic, copy, readwrite) NSArray *pages;
@end


@implementation RWTBook

#pragma mark - Public

+ (instancetype)bookWithPages:(NSArray*)pages
{
  RWTBook *book = [[RWTBook alloc] init];

  book.pages = pages;

  return book;
}

+ (instancetype)testBook
{
  RWTPage *page1 = [RWTPage pageWithAttributes:@{ RWTPageAttributesKeyUtterances :
                                                    @"Whisky, frisky, hippidity hop.\nUp he goes to the tree top.",
                                                  RWTPageAttributesKeyBackgroundImage :
                                                    [UIImage imageNamed:@"PageBackgroundImage.jpg"] }];
  RWTPage *page2 = [RWTPage pageWithAttributes:@{ RWTPageAttributesKeyUtterances :
                                                    @"Whirly, twirly round and round.\nDown he scampers to the ground.",
                                                  RWTPageAttributesKeyBackgroundImage :
                                                    [UIImage imageNamed:@"PageBackgroundImage.jpg"] }];

  return [self bookWithPages:@[page1, page2]];
}

@end