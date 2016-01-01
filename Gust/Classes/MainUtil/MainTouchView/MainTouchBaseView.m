//
//  MainTouchBaseView.m
//  Gust
//
//  Created by Iracle Zhang on 16/1/1.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "MainTouchBaseView.h"

@implementation MainTouchBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mainTouchView = [[MainTouchView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_mainTouchView];
        
        self.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.08].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2.5);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 3;

    }
    return self;
}

- (void)layoutSubviews {
    
}

@end
