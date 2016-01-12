//
//  NavaSearchBar.h
//  Gust
//
//  Created by Iracle Zhang on 16/1/11.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSearchBar.h"

@interface NavaSearchBar : UIView

- (void)showInView:(UIView *)backgroundView;
- (void)showSearchBar;
- (void)hiddenSearchBar;

@property (nonatomic, strong) UILabel *webTitle;
@property (nonatomic, strong) MainSearchBar *searchBar;

@end
