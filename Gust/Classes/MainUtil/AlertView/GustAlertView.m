//
//  GustAlertView.m
//  Gust
//
//  Created by Iracle on 15/4/9.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "GustAlertView.h"
#import <QuartzCore/QuartzCore.h>

@interface GustAlertView()

@property (nonatomic, strong) UILabel *alertLabel;

@property (nonatomic, strong) GustAlertView *visualEffectView;

@end;

@implementation GustAlertView

- (void)showInView:(UIView *)view type:(RectType) type title:(NSString *)info

{
     _visualEffectView = [[GustAlertView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _visualEffectView.clipsToBounds = YES;

    if (type == AlertSquare) {
        
        _visualEffectView.bounds = CGRectMake(0, 0, 140, 140);
        _visualEffectView.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
        CGRect labelFrame = CGRectMake(0, 80, 140, 50);
        _visualEffectView.layer.cornerRadius = 6;
        _alertLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont systemFontOfSize:14];
        _alertLabel.textColor = [UIColor colorWithWhite:0.930 alpha:1.000];
        _alertLabel.text = info;
        [_visualEffectView addSubview:_alertLabel];
        [view addSubview:_visualEffectView];
        
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:0.0 options:0 animations:^{
            _visualEffectView.bounds = CGRectMake(0, 0, 150, 150);
            
        } completion:^(BOOL finished) {
            
            [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:1.2];
            
        }];
        
    } else if (type == AlertRectangle) {
        
        _visualEffectView.bounds = CGRectMake(0, 0, CGRectGetWidth(view.bounds) * 0.7, 40);
        _visualEffectView.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height * 0.4);
         _visualEffectView.layer.cornerRadius = 3;
        _alertLabel = [[UILabel alloc] initWithFrame:_visualEffectView.bounds];
        _alertLabel.layer.cornerRadius = 3;
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont systemFontOfSize:14];
        _alertLabel.textColor = [UIColor colorWithWhite:0.930 alpha:1.000];
        _alertLabel.text = info;
        [_visualEffectView addSubview:_alertLabel];
        [view addSubview:_visualEffectView];
        [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:1.2];
    }
    
}

- (void)removeAlertView
{
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:0 animations:^{
        _alertLabel.frame = CGRectZero;
        _visualEffectView.bounds = CGRectZero;
        _visualEffectView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [_visualEffectView removeFromSuperview];
    
    }];

}

@end
