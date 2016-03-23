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
    UIImageView *scaleView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return  0.24;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    fromVC = (GustWebViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    toVC = (HomeViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contView = [transitionContext containerView];
    contView.backgroundColor = [UIColor blackColor];
    scaleView = [[UIImageView alloc] initWithImage:[self getCurrentViewShotImage]];
    scaleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [contView addSubview:scaleView];
    
    scaleView.layer.opacity = 0.1;
    scaleView.transform = CGAffineTransformMakeScale(1.5, 1.5);

    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    animation.duration = [self transitionDuration:transitionContext];
    animation.toValue = @(1.0);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [scaleView removeFromSuperview];
            scaleView = nil;
            [[transitionContext containerView] addSubview:toVC.view];

            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
          
        }
    };

    [scaleView.layer pop_addAnimation:animation forKey:@"Opacity"];
    POPBasicAnimation *animation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation1.duration = [self transitionDuration:transitionContext];
    animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [scaleView.layer pop_addAnimation:animation1 forKey:@"ScaleXY"];
}

//截图
- (UIImage *)getCurrentViewShotImage {
    
    UIGraphicsBeginImageContextWithOptions(toVC.view.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT));
    [toVC.view.layer renderInContext:context];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)animationEnded:(BOOL)transitionCompleted {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationRevertPopAnimation object:nil];
    
}



@end
