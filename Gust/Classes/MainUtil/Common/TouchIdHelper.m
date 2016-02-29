//
//  TouchIdHelper.m
//  Gust
//
//  Created by Iracle Zhang on 2/29/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "TouchIdHelper.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation TouchIdHelper

- (void)authenticateUser:(void (^)(bool))handler {
    //inti context object
    LAContext *context = [LAContext new];
    context.localizedFallbackTitle = @"输入密码";
    NSError *error = nil;
    NSString* result = @"获取进入隐私模式的权限";
    //judge if the device suport internationl
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //use fingerpint
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     handler(YES);
                });
                //update main UI
                
            } else {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            handler(NO);
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
                
            }
        }];
        
    } else {
        //not surport fingerprint
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
        NSLog(@"pass world alert");
}
}

@end
