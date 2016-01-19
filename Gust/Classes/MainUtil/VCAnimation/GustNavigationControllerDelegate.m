//
//  GustNavigationControllerDelegate.m
//  Gust
//
//  Created by Iracle Zhang on 16/1/7.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "GustNavigationControllerDelegate.h"

@implementation GustNavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        PopAnimationTransition *popTransition = [[PopAnimationTransition alloc] init];
        return popTransition;
    } else if (operation == UINavigationControllerOperationPop) {
        RevertPopAnimationTransition *revertPopTransition = [[RevertPopAnimationTransition alloc] init];
        return revertPopTransition;
        
    }else{
        return nil;
    }
}
@end
