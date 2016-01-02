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
        _mainTouchView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_mainTouchView];
        
        self.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 5.5);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 6;

    }
    return self;
}

- (void)layoutSubviews {
    
}

@end
