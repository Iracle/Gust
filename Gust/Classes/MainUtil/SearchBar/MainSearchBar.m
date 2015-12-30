//
//  MainSearchBar.m
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "MainSearchBar.h"
#import "GustConfigure.h"

@implementation MainSearchBar {
    UIView *micInputView;
    
}
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
    //shadow
    self.clipsToBounds = NO;
    self.layer.shadowColor = SEARCH_BAR_SHADOW_COLOR.CGColor;
    self.layer.shadowRadius = 2.0;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0, 1.7);

    self.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.borderStyle = UITextBorderStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3.0;
    self.keyboardType = UIKeyboardTypeWebSearch;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.font = [UIFont systemFontOfSize:15];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.returnKeyType = UIReturnKeyGo;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8.5, 28, 28)];
    imageView.userInteractionEnabled = NO;
    imageView.image = IMAGENAMED(@"search");
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 45)];
    paddingView.userInteractionEnabled = NO;
    [paddingView addSubview:imageView];

    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;

    
    UIImageView *micPic = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 8.5, 28, 28)];
    micPic.image = IMAGENAMED(@"mic");
    micPic.userInteractionEnabled = YES;
    micInputView  = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 50, 45)];
    [micInputView addSubview:micPic];
    self.rightView = micInputView;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    UITapGestureRecognizer *tapMicGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMic:)];
    [micInputView addGestureRecognizer:tapMicGes];
    
}

- (void)tapMic:(UIGestureRecognizer *)ges {
     NSLog(@"hhh");
}
@end










