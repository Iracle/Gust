//
//  RevertPopAnimationTransition.m
//  Gust
//
//  Created by Iracle Zhang on 16/1/8.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "RevertPopAnimationTransition.h"
#import "HomeViewController.h"
#import "GustWebViewController.h"
#import "GustConfigure.h"
#import <POP/POP.h>

@implementation RevertPopAnimationTransition {
    HomeViewController *toVC;
    GustWebViewController *fromVC;
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return  0.14;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    fromVC = (GustWebViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    toVC = (HomeViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toVC.view];
    toVC.view.layer.opacity = 0.01;
    toVC.view.transform = CGAffineTransformMakeScale(1.1, 1.1);

    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    animation.duration = [self transitionDuration:transitionContext];
    animation.toValue = @(1.0);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
          
        }
    };

    [toVC.view.layer pop_addAnimation:animation forKey:@"Opacity"];
    
    POPBasicAnimation *animation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation1.duration = [self transitionDuration:transitionContext];
    animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [toVC.view.layer pop_addAnimation:animation1 forKey:@"ScaleXY"];
}



@end
