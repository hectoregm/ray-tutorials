//
//  RWTPageViewController.m
//  NarratedBookUsingAVSpeech
//
//  Created by Republic of Apps, LLC on 2/1/14.
//  Copyright (c) 2014 RepublicOfApps, LLC. All rights reserved.
//

#import "RWTPageViewController.h"
#import "RWTBook.h"
#import "RWTPage.h"

#pragma mark - Class Extension

@interface RWTPageViewController ()
@property (nonatomic, strong) RWTBook *book;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@end

@implementation RWTPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self setupBook:[RWTBook testBook]];

  UISwipeGestureRecognizer *swipeNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)];
  swipeNext.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:swipeNext];

  UISwipeGestureRecognizer *swipePrevious = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPreviousPage)];
  swipePrevious.direction = UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer:swipePrevious];
}

#pragma mark - Private

- (RWTPage*)currentPage
{
  return [self.book.pages objectAtIndex:self.currentPageIndex];
}

- (void)setupBook:(RWTBook*)newBook
{
  self.book = newBook;
  self.currentPageIndex = 0;

  [self setupForCurrentPage];
}

- (void)setupForCurrentPage
{
  self.pageTextLabel.text = [self currentPage].displayText;
  self.pageImageView.image = [self currentPage].backgroundImage;
}

- (void)gotoNextPage
{
  if ([self.book.pages count] == 0 || self.currentPageIndex == [self.book.pages count] - 1) {
    return;
  }

  self.currentPageIndex += 1;
  [self setupForCurrentPage];
}

- (void)gotoPreviousPage
{
  if (self.currentPageIndex == 0) {
    return;
  }

  self.currentPageIndex -= 1;
  [self setupForCurrentPage];
}

@end
