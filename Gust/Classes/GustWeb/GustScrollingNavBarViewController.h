//
//  GustScrollingNavBarViewController.h
//  Gust
//
//  Created by Iracle on 15/3/5.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GustScrollingNavBarViewControllerDelegate <NSObject>
@optional
@end

@interface GustScrollingNavBarViewController : UIViewController

@property (nonatomic, assign) id<GustScrollingNavBarViewControllerDelegate> delegate;
-(void)gustFollowRollingScrollView:(UIView *)scrollView;
- (void)gustWebViewScrollUp;
- (void)gustWebViewScrollDown;
@end
