//
//  GustRevertNavigationControllerDelegate.m
//  Gust
//
//  Created by Iracle Zhang on 16/1/8.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "GustRevertNavigationControllerDelegate.h"


@implementation GustRevertNavigationControllerDelegate 

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        RevertPopAnimationTransition *revertPopTransition = [[RevertPopAnimationTransition alloc] init];
        return revertPopTransition;

    } else{
        return nil;
    }
}
@end
