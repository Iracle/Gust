//
//  GustScrollingNavBarViewController.m
//  Gust
//
//  Created by Iracle on 15/3/5.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "GustScrollingNavBarViewController.h"
#define NavBarFrame self.navigationController.navigationBar.frame

@interface GustScrollingNavBarViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *scrollView;
@property (retain, nonatomic)UIPanGestureRecognizer *panGesture;
@property (assign, nonatomic)BOOL isHidden;

@end

@implementation GustScrollingNavBarViewController

-(void)gustFollowRollingScrollView:(UIView *)scrollView
{
    self.scrollView = scrollView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] init];
    self.panGesture.delegate=self;
    self.panGesture.minimumNumberOfTouches = 1;
    [self.panGesture addTarget:self action:@selector(handlePanGesture:)];
    [self.scrollView addGestureRecognizer:self.panGesture];
 }

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:[self.scrollView superview]];
//show NavBar
    if (translation.y >= 5) {
        if (self.isHidden) {
            [self gustWebViewScrollDown];
             self.isHidden= NO;
        }
    }
    
//hidden NavBar
    if (translation.y <= -20) {
        if (!self.isHidden) {
            [self gustWebViewScrollUp];
            self.isHidden=YES;
        }
    }
}

- (void)gustWebViewScrollUp
{
    
}
- (void)gustWebViewScrollDown
{
    
}

@end
