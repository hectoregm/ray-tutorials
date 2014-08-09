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
@import AVFoundation;

#pragma mark - Class Extension

@interface RWTPageViewController ()
@property (nonatomic, strong) RWTBook *book;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, assign) NSUInteger nextSpeechIndex;
@property (nonatomic, assign) float currentPitchMultiplier;
@property (nonatomic, assign) float currentRate;
@end

@implementation RWTPageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSString *path = [[NSBundle mainBundle] pathForResource:@"WhirlySquirrelly" ofType:@"plist"];
  [self setupBook:[RWTBook bookWithContentsOfFile:path]];

  UISwipeGestureRecognizer *swipeNext = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)];
  swipeNext.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.view addGestureRecognizer:swipeNext];

  UISwipeGestureRecognizer *swipePrevious = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPreviousPage)];
  swipePrevious.direction = UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer:swipePrevious];
  
  self.currentPitchMultiplier = 1.0f;
  self.currentRate = AVSpeechUtteranceDefaultSpeechRate;
  
  [self addSpeechControls];
  [self startSpeaking];
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
  self.nextSpeechIndex = 0;
}

- (void)gotoNextPage
{
  if ([self.book.pages count] == 0 || self.currentPageIndex == [self.book.pages count] - 1) {
    return;
  }

  self.currentPageIndex += 1;
  [self setupForCurrentPage];
  [self startSpeaking];
}

- (void)gotoPreviousPage
{
  if (self.currentPageIndex == 0) {
    return;
  }

  self.currentPageIndex -= 1;
  [self setupForCurrentPage];
  [self startSpeaking];
}

- (void)lowerPitch
{
  if (self.currentPitchMultiplier > 0.5f) {
    self.currentPitchMultiplier = MAX(self.currentPitchMultiplier * 0.8f, 0.5f);
  }
}

- (void)raisePitch
{
  if (self.currentPitchMultiplier < 2.0f) {
    self.currentPitchMultiplier = MIN(self.currentPitchMultiplier * 1.2f, 2.0f);
  }
}

- (void)lowerRate
{
  if (self.currentRate > AVSpeechUtteranceMinimumSpeechRate) {
    self.currentRate = MAX(self.currentRate * 0.8f, AVSpeechUtteranceMinimumSpeechRate);
  }
}

- (void)raiseRate
{
  if (self.currentRate < AVSpeechUtteranceMaximumSpeechRate) {
    self.currentRate = MIN(self.currentRate * 1.2f, AVSpeechUtteranceMaximumSpeechRate);
  }
}

-(void) addSpeechControlWithFrame: (CGRect) frame title:(NSString *) title action:(SEL) selector {
  UIButton *controlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  controlButton.frame = frame;
  controlButton.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
  [controlButton setTitle:title forState:UIControlStateNormal];
  [controlButton addTarget:self
                    action:selector
          forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:controlButton];
}

- (void)addSpeechControls
{
  [self addSpeechControlWithFrame:CGRectMake(52, 485, 150, 50)
                            title:@"Lower Pitch"
                           action:@selector(lowerPitch)];
  [self addSpeechControlWithFrame:CGRectMake(222, 485, 150, 50)
                            title:@"Raise Pitch"
                           action:@selector(raisePitch)];
  [self addSpeechControlWithFrame:CGRectMake(422, 485, 150, 50)
                            title:@"Lower Rate"
                           action:@selector(lowerRate)];
  [self addSpeechControlWithFrame:CGRectMake(592, 485, 150, 50)
                            title:@"Raise Rate"
                           action:@selector(raiseRate)];
  [self addSpeechControlWithFrame:CGRectMake(506, 555, 150, 50)
                            title:@"Speak Again"
                           action:@selector(speakAgain)];
  
}

- (void)speakAgain
{
  if (self.nextSpeechIndex == [[self currentPage].utterances count]) {
    self.nextSpeechIndex = 0;
    [self speakNextUtterance];
  }
}

#pragma mark - Speech Management

- (void)speakNextUtterance
{
  if (self.nextSpeechIndex < [[self currentPage].utterances count]) {
    AVSpeechUtterance *utterance = [[self currentPage].utterances objectAtIndex:self.nextSpeechIndex];
    self.nextSpeechIndex += 1;
    utterance.pitchMultiplier = self.currentPitchMultiplier;
    utterance.rate = self.currentRate;
    [self.synthesizer speakUtterance:utterance];
  }
}

- (void)startSpeaking
{
  if (!self.synthesizer) {
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer.delegate = self;
  }
  
  [self speakNextUtterance];
}

#pragma mark - AVSpeechSynthesizerDelegate Protocol

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
  NSUInteger indexOfUtterance = [[self currentPage].utterances indexOfObject:utterance];
  if (indexOfUtterance == NSNotFound) {
    return;
  }
  
  [self speakNextUtterance];
}

@end
