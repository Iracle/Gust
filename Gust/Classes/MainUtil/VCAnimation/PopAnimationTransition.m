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
@property (nonatomic, strong)  UIView *animationView;
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
    
    UIView *currentContainerView = [transitionContext containerView];
    currentContainerView.backgroundColor = [UIColor blackColor];
    

    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

    //zoom animation view
    self.animationView.hidden = NO;
    self.animationView.center = CGPointMake(fromVC.cellPopAnimationViewRect.origin.x + fromVC.cellPopAnimationViewRect.size.width/2, fromVC.cellPopAnimationViewRect.origin.y + fromVC.cellPopAnimationViewRect.size.height/2);
    self.animationView.transform = CGAffineTransformMakeScale(0.28, 0.17);
    [currentContainerView addSubview:self.animationView];
    
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.duration = [self transitionDuration:transitionContext];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

    [self.animationView pop_addAnimation:animation forKey:@"Center"];
    
    POPBasicAnimation *animation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation1.duration = [self transitionDuration:transitionContext];
    animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation1.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [currentContainerView addSubview:toVC.view];
            [toVC.view.layer pop_removeAllAnimations];
            self.animationView.hidden = YES;
        }
    };
    [self.animationView.layer pop_addAnimation:animation1 forKey:@"ScaleXY"];

}

#pragma mark -- getter
- (UIView *)animationView{
    if (!_animationView) {
        _animationView = [[UIView alloc] init];
        _animationView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _animationView.backgroundColor = [UIColor whiteColor];
    }
    return _animationView;
}


@end









