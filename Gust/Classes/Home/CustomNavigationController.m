//
//  CustomNavigationController.m
//  Gust
//
//  Created by Iracle Zhang on 15/11/4.
//  Copyright © 2015年 Iralce. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma -- 3D Touch
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *shareAction = [UIPreviewAction actionWithTitle:@"Share" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    UIPreviewAction *addAction = [UIPreviewAction actionWithTitle:@"Add" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    return @[shareAction, addAction];
}


@end
