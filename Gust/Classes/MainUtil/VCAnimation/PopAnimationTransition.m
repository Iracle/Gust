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
    HomeViewController *fromVC;
    GustWebViewController *toVC;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return  0.38;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    fromVC = (HomeViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    toVC = (GustWebViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toVC.view];
    toVC.view.center = CGPointMake(fromVC.cellPopAnimationViewRect.origin.x + fromVC.cellPopAnimationViewRect.size.width/2, fromVC.cellPopAnimationViewRect.origin.y + fromVC.cellPopAnimationViewRect.size.height/2);
    toVC.view.transform = CGAffineTransformMakeScale(0.28, 0.17);
    
    [self showAllHomeSubview:NO];
    [fromVC.view insertSubview:self.blackBackgroundView atIndex:0];
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.duration = [self transitionDuration:transitionContext];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

    [toVC.view pop_addAnimation:animation forKey:@"Center"];
    
    POPBasicAnimation *animation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation1.duration = [self transitionDuration:transitionContext];
    animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation1.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [toVC.view.layer pop_removeAllAnimations];
            [self showAllHomeSubview:YES];
            [self removeAllAnimationView];
        }
    };
    [toVC.view.layer pop_addAnimation:animation1 forKey:@"ScaleXY"];

}


- (void)showAllHomeSubview:(BOOL)isSHow {
    for (UIView *homeSubview in fromVC.view.subviews) {
            homeSubview.hidden = !isSHow;
    }
}

- (void)removeAllAnimationView {
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









