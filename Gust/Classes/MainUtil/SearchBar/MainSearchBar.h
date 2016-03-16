//
//  MainSearchBar.h
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainSearchBar;
@protocol MainSearchBarDelegate <NSObject>

- (void)searchBarTapepMic:(MainSearchBar *)searchBar;

@end

@interface MainSearchBar : UITextField

@property (nonatomic, assign) id<MainSearchBarDelegate> micDelegate;

- (void)showSearchIcon;
- (void)hiddenSearchIcon;

@end
