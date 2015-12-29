//
//  GustWebViewController.h
//  Gust
//
//  Created by Iracle on 15/3/5.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GustScrollingNavBarViewController.h"
#import "MainTouchView.h"


@interface GustWebViewController : GustScrollingNavBarViewController

@property (nonatomic, strong) NSString * webURL;
@property (nonatomic, strong) NSMutableString *currentSearchString;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, strong) MainTouchView *touchView;


@end
