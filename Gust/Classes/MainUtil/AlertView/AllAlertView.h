//
//  AllAlertView.h
//  Gust
//
//  Created by Iracle Zhang on 1/20/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AllAlertType) {
    AllAlertViewAlertTypeDone,
    AllAlertViewAlertTypeRemind,
    AllAlertViewAlertTypeAlert
};

@interface AllAlertView : UIView

+ (AllAlertView *)sharedAlert;

- (void)showWithTitle:(NSString *)title alertType:(AllAlertType)alertType height:(CGFloat)height;

@end
