//
//  LockWindow.m
//  Gust
//
//  Created by Iracle Zhang on 2/29/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "LockWindow.h"
#import "GustConfigure.h"
#import "TouchIdHelper.h"
#import "UIAlertController+Window.h"

@implementation LockWindow

+ (LockWindow *)shareLockWindow {
    static LockWindow *lock = nil;
    static dispatch_once_t oneToken = 0;
    dispatch_once(&oneToken, ^{
        lock = [[LockWindow alloc] init];
    });
    return lock;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        self.alpha = 0.9;
    }
    return self;
}

- (void)showLockWindow {

    [self makeKeyAndVisible];
    [self performSelector:@selector(showTouchId) withObject:nil afterDelay:0.5];
}

- (void)dismissLockWindow {
    self.hidden = YES;
    [self resignKeyWindow];
    
}
- (void)showTouchId {
    __weak typeof(self) weakSelf = self;
    [[TouchIdHelper new] authenticateUser:^(bool isEnter) {
        if (isEnter) {
            [weakSelf dismissLockWindow];
        }
    }];
}
@end
