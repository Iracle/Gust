//
//  AllAlertView.m
//  Gust
//
//  Created by Iracle Zhang on 1/20/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "AllAlertView.h"
#import "GustConfigure.h"

static const CGFloat AlertImageHeight = 50.0;

@interface AllAlertView ()

@property (nonatomic, copy)   NSString *alertImageName;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIImageView *alertImage;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic) BOOL alertFinish;
@property (nonatomic) CGFloat alertHeight;

@end

@implementation AllAlertView

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelAlert;
    }
    return _window;
}

- (UIImageView *)alertImage {
    if (!_alertImage) {
        _alertImage = [[UIImageView alloc] initWithFrame:CGRectMake(25.0, self.alertHeight / 2 - 20.0, AlertImageHeight, AlertImageHeight)];
    }
    return _alertImage;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.alertImage.frame) + 33.0, self.alertHeight / 2 - 20.0, SCREEN_WIDTH - 65 - CGRectGetMaxX(self.alertImage.frame) , AlertImageHeight)];
        _alertLabel.textAlignment = NSTextAlignmentLeft;
        _alertLabel.numberOfLines = 0;
        _alertLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightRegular];
    }
    return _alertLabel;
}

+ (AllAlertView *)sharedAlert {
    static AllAlertView *alertView = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        alertView = [[AllAlertView alloc] init];
    });
    return alertView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor colorWithRed:0.1683 green:0.1683 blue:0.1683 alpha:1.0].CGColor;
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 0.9;

    }
    return self;
}

- (void)showWithTitle:(NSString *)title alertType:(AllAlertType)alertType height:(CGFloat)height{
    if (self.alertFinish) {
        return;
    }
    self.alertFinish = YES;
    self.alertHeight = height;
    switch (alertType) {
        case AllAlertViewAlertTypeDone:
            self.alertImageName = @"alertDone";
            self.alertLabel.textColor = [UIColor colorWithRed:93 / 255.0 green:148 /255.0 blue:140 / 255.0 alpha:1.0];

            break;
        case AllAlertViewAlertTypeRemind:
            self.alertImageName = @"alertReminder";
            self.alertLabel.textColor = [UIColor colorWithRed:211 / 255.0 green:104 /255.0 blue:104 / 255.0 alpha:1.0];

            break;
        case  AllAlertViewAlertTypeAlert:
            self.alertImageName = @"alertAlert";
            self.alertLabel.textColor = [UIColor colorWithRed:211 / 255.0 green:104 /255.0 blue:104 / 255.0 alpha:1.0];

            break;
            
        default:
            break;
    }
    self.frame = CGRectMake(0.0, -height, SCREEN_WIDTH, height);
    self.alertImage.image = IMAGENAMED(self.alertImageName);
    self.alertLabel.text = title;
    [self addSubview:self.alertImage];
    [self addSubview:self.alertLabel];
    [self.window makeKeyAndVisible];
    [self.window addSubview:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.transform = CGAffineTransformMakeTranslation(0, height);
        
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(hideAlertView) withObject:nil afterDelay:1.0];
    }];
}

- (void)hideAlertView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.14 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        self.alertFinish = NO;
        self.window.hidden = YES;
        [self.window resignKeyWindow];
    }];
}

@end






