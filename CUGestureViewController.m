//
//  CUGestureViewController.m
//  CoreAnimationExample
//
//  Created by yuguang on 5/2/15.
//  Copyright (c) 2015 lion. All rights reserved.
//

#import "CUGestureViewController.h"

@interface CUGestureViewController ()

@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation CUGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.imageView addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleGesture:(UIPanGestureRecognizer *)recognizer {
    
    if (self.isAnimating) {
        return;
    }
    
    CGPoint translation = [recognizer translationInView:self.view];
    CGRect recognizerFrame = recognizer.view.frame;
    recognizerFrame.origin.x += translation.x;
    recognizerFrame.origin.y += translation.y;
    
    // Check if UIImageView is completely inside its superView
    if (CGRectContainsRect(self.view.bounds, recognizerFrame)) {
        recognizer.view.frame = recognizerFrame;
    }
    // Else check if UIImageView is vertically and/or horizontally outside of its
    // superView. If yes, then set UImageView's frame accordingly.
    // This is required so that when user pans rapidly then it provides smooth translation.
    else {
        // Check vertically
        if (recognizerFrame.origin.y < self.view.bounds.origin.y) {
            recognizerFrame.origin.y = 0;
        }
        else if (recognizerFrame.origin.y + recognizerFrame.size.height > self.view.bounds.size.height) {
            recognizerFrame.origin.y = self.view.bounds.size.height - recognizerFrame.size.height;
        }
        
        // Check horizantally
        if (recognizerFrame.origin.x < self.view.bounds.origin.x) {
            recognizerFrame.origin.x = 0;
        }
        else if (recognizerFrame.origin.x + recognizerFrame.size.width > self.view.bounds.size.width) {
            recognizerFrame.origin.x = self.view.bounds.size.width - recognizerFrame.size.width;
        }
    }
    
    // Reset translation so that on next pan recognition
    // we get correct translation value
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recognizer.view.frame.origin.y >= 100 && !self.isAnimating) {
        
        self.isAnimating = YES;
        
        CGFloat speed = [recognizer velocityInView:self.view].y;
        CGFloat distance = 300;
        
        [UIView animateWithDuration:2.0f
                              delay:0.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:speed / distance
                            options:0
                         animations:^{
                             recognizer.view.frame = CGRectOffset(recognizer.view.frame, 0, distance);
                         } completion:^(BOOL finished) {
                             self.isAnimating = NO;
                         }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
