//
//  MainSearchBar.m
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "MainSearchBar.h"

@implementation MainSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initMainSearchBar];
    }
    return self;
}

- (void)initMainSearchBar
{
    self.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.626 alpha:0.390];
    self.layer.cornerRadius = 3.0;
    self.keyboardType = UIKeyboardTypeWebSearch;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.font = [UIFont systemFontOfSize:15];
    self.placeholder =@"搜索或输入网址";
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.returnKeyType = UIReturnKeyGo;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, CGRectGetHeight(self.bounds))];
    leftView.backgroundColor = [UIColor clearColor];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
@end
