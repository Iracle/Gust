//
//  PopAnimationTransition.m
//  Gust
//
//  Created by Iracle Zhang on 16/1/7.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "PopAnimationTransition.h"
#import "HomeViewController.h"
#import "GustWebViewController.h"
#import <POP/POP.h>
#import "GustConfigure.h"

@interface PopAnimationTransition ()
@property (nonatomic, strong)  UIView *blackBackgroundView;
@end

@implementation PopAnimationTransition {
    UIView *currentAnimationView;
    HomeViewController *fromVC;
    GustWebViewController *toVC;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return  0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    fromVC = (HomeViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    toVC = (GustWebViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    currentAnimationView = fromVC.cellPopAnimationView;
    currentAnimationView.backgroundColor = [UIColor whiteColor];
    [fromVC.view addSubview:currentAnimationView];
    
    [self showAllHomeSubview:NO];
    [fromVC.view insertSubview:self.blackBackgroundView atIndex:0];
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    animation.duration = [self transitionDuration:transitionContext];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [[transitionContext containerView] addSubview:toVC.view];
             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [currentAnimationView.layer pop_removeAllAnimations];
            [self showAllHomeSubview:YES];
            [self removeAllAnimationView];
        }
    };
    [currentAnimationView.layer pop_addAnimation:animation forKey:@"decay"];
    
}


- (void)showAllHomeSubview:(BOOL)isSHow {
    for (UIView *homeSubview in fromVC.view.subviews) {
        if (homeSubview != currentAnimationView) {
            homeSubview.hidden = !isSHow;
        }
    }
}

- (void)removeAllAnimationView {
    [currentAnimationView removeFromSuperview];
    currentAnimationView = nil;
    [_blackBackgroundView removeFromSuperview];
    _blackBackgroundView = nil;
}

#pragma mark -- getter
- (UIView *)blackBackgroundView {
    if (!_blackBackgroundView) {
        _blackBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _blackBackgroundView.backgroundColor = [UIColor blackColor];
    }
    return _blackBackgroundView;
}


@end









