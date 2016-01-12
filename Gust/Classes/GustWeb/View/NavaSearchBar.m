//
//  NavaSearchBar.m
//  Gust
//
//  Created by Iracle Zhang on 16/1/11.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "NavaSearchBar.h"
#import "GustConfigure.h"
static const CGFloat NavaSearchBarHeight = 40.0;

@interface NavaSearchBar ()

@end

@implementation NavaSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, NavaSearchBarHeight);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor colorWithRed:0.8244 green:0.8244 blue:0.8244 alpha:1.0].CGColor;
        self.layer.borderWidth = 0.5;
        
    }
    return self;
}
- (void)showInView:(UIView *)backgroundView {

    [backgroundView addSubview:self];
    [self addSubview:self.webTitle];
}

- (void)showSearchBar {
    self.webTitle.hidden = YES;
    self.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, 65.0);
    [self addSubview:self.searchBar];
    self.searchBar.hidden = NO;
}

- (void)hiddenSearchBar {
    self.webTitle.hidden = NO;
    self.searchBar.hidden = YES;
    self.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, NavaSearchBarHeight);

}

#pragma mark -- getter

- (UILabel *)webTitle {
    if (!_webTitle) {
        _webTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20)];
        _webTitle.textAlignment = NSTextAlignmentCenter;
        _webTitle.font = [UIFont systemFontOfSize:12];
        _webTitle.textColor = [UIColor colorWithRed:0.6503 green:0.6503 blue:0.6503 alpha:1.0];
        
    }
    return _webTitle;
    
}

- (MainSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[MainSearchBar alloc] init];
        _searchBar.bounds = CGRectMake(0.0, 0.0, SCREEN_WIDTH - COLLECTION_CONTENT_OFFSET * 2, 32);
        _searchBar.center = CGPointMake(SCREEN_WIDTH /2, 42);
        _searchBar.layer.shadowOpacity = 0.0;
//        _searchBar.backgroundColor = [UIColor colorWithRed:0.9865 green:0.9865 blue:0.9865 alpha:1.0];
    }
    return _searchBar;
}


@end
