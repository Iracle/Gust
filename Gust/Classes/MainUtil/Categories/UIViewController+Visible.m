//
//  UIViewController+Visible.m
//  Gust
//
//  Created by Iracle Zhang on 3/2/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "UIViewController+Visible.h"

@implementation UIViewController (Visible)

- (BOOL)isVisibe {
    return (self.isViewLoaded && self.view.window);
}
@end
