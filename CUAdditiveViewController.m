//
//  CUAdditiveViewController.m
//  CoreAnimationExample
//
//  Created by yuguang on 30/6/14.
//  Copyright (c) 2014 lion. All rights reserved.
//

#import "CUAdditiveViewController.h"

//#define USING_UIKIT 1



typedef NS_OPTIONS(NSUInteger, CUAnimationType) {
    CUAnimationTypeNone,
    CUAnimationTypeAdditive,
    CUAnimationTypeBeginFromCurrentState
};

@interface CUAdditiveViewController ()

@property(weak, nonatomic) IBOutlet UIImageView *imageViewA;
@property(weak, nonatomic) IBOutlet UIImageView *imageViewB;
@property(weak, nonatomic) IBOutlet UIImageView *imageViewC;
@end

@implementation CUAdditiveViewController
{
  BOOL _isForwardA;
  BOOL _isForwardB;
  BOOL _isForwardC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.imageViewA.backgroundColor = [UIColor redColor];
  self.imageViewB.backgroundColor = [UIColor blueColor];
  self.imageViewC.backgroundColor = [UIColor greenColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)animationClicked:(id)sender {
  
#ifdef USING_UIKIT
  
  static BOOL bTest = NO;
  [self UIKitAnimation:bTest];
  [self  UIKitAnimationDefault:bTest];
  bTest = !bTest;
  
#else
  
  [self animateType:CUAnimationTypeNone inLayer:self.imageViewA.layer];
  [self animateType:CUAnimationTypeAdditive inLayer:self.imageViewB.layer];
  [self animateType:CUAnimationTypeBeginFromCurrentState inLayer:self.imageViewC.layer];
  
#endif
}

- (void)UIKitAnimation:(BOOL)isReverse
{
  if (!isReverse) {
    [UIView animateWithDuration:1.0f
                     animations:^{
                       self.imageViewC.center = CGPointMake(self.imageViewC.center.x, 500);
                     }];
  }
  else
  {
    [UIView animateWithDuration:1.0f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                     animations:^{
                       self.imageViewC.center = CGPointMake(self.imageViewC.center.x, 88);
                     } completion:^(BOOL finished) {
                     }];
  }
}

- (void)UIKitAnimationDefault:(BOOL)isReverse
{
  if (!isReverse) {
    [UIView animateWithDuration:1.0f
                     animations:^{
                       self.imageViewA.center = CGPointMake(self.imageViewA.center.x, 500);
                     }];
  }
  else
  {
    [UIView animateWithDuration:1.0f
                     animations:^{
                       self.imageViewA.center = CGPointMake(self.imageViewA.center.x, 88);
                     } completion:^(BOOL finished) {
                     }];
  }
}

- (void)animateType:(CUAnimationType)type inLayer:(CALayer *)animationLayer {
  
  NSNumber *fromValue = @88;
  NSNumber *toValue = @500;
  NSNumber *endValue = toValue;
  CABasicAnimation *animation = [CABasicAnimation animation];
  animation.keyPath = @"position.y";
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  animation.duration = 1; //modify better
  
  switch (type) {
  case CUAnimationTypeNone: {
    
    if (!_isForwardA) {
      _isForwardA = YES;
      animation.fromValue = fromValue;
      animation.toValue = toValue;
      endValue = toValue;
    }
    else {
      _isForwardA = NO;
      animation.fromValue = toValue;
      animation.toValue = fromValue;
      endValue = fromValue;
    }
    
    animationLayer.position = CGPointMake(animationLayer.position.x, [endValue intValue]);
    
    NSString *key = [NSString stringWithFormat:@"ani"];
    [animationLayer addAnimation:animation forKey:key];
  }
      break;
  case CUAnimationTypeAdditive: {
    
    if (!_isForwardB) {
      _isForwardB = YES;
      animation.fromValue = @([fromValue intValue] - [toValue intValue]);
    }
    else {
      _isForwardB = NO;
      animation.fromValue = @([toValue intValue] - [fromValue intValue]);
      endValue = fromValue;
    }
    
    animation.toValue = @(0);
    animation.additive = YES;

    animationLayer.position = CGPointMake(animationLayer.position.x, [endValue intValue]);

    NSString *key = [NSString stringWithFormat:@"ani_%@", [NSDate date]];
    [animationLayer addAnimation:animation forKey:key];
  }
      break;
  case CUAnimationTypeBeginFromCurrentState: {
    if (!_isForwardC) {
      _isForwardC = YES;
      animation.fromValue = @([animationLayer.presentationLayer position].y);
      animation.toValue = toValue;
      endValue = toValue;
    }
    else {
      _isForwardC = NO;
      animation.fromValue = @([animationLayer.presentationLayer position].y);
      animation.toValue = fromValue;
      endValue = fromValue;
    }
    
    animationLayer.position = CGPointMake(animationLayer.position.x, [endValue intValue]);
    
    NSString *key = [NSString stringWithFormat:@"ani"];
    [animationLayer addAnimation:animation forKey:key];
  }
      break;

  default:
    break;
  }
}

- (void)timeProc
{
  
}

@end
