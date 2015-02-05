//
//  CUAppDelegate.m
//  CoreAnimationExample
//
//  Created by yuguang on 24/6/14.
//  Copyright (c) 2014 lion. All rights reserved.
//

#import "CUAppDelegate.h"
#import "CUAdditiveViewController.h"
#import "CUGestureViewController.h"

@implementation CUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];
  
  self.window.rootViewController = [CUAdditiveViewController new];
  [self.window makeKeyAndVisible];
  return YES;
}

@end
