//
//  GustBKPasscodeDelegate.m
//  Gust
//
//  Created by Iracle Zhang on 3/1/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "GustBKPasscodeDelegate.h"
#import "CHKeychain.h"

@implementation GustBKPasscodeDelegate


- (void)passcodeViewController:(BKPasscodeViewController *)aViewController authenticatePasscode:(NSString *)aPasscode resultHandler:(void (^)(BOOL))aResultHandler
{
    self.passcode = [CHKeychain load:@"KEY_PRIVACY"];
     NSLog(@"ppp:%@",self.passcode);
    if ([aPasscode isEqualToString:self.passcode]) {
        
        self.lockUntilDate = nil;
        self.failedAttempts = 0;
        
        aResultHandler(YES);
    } else {
        aResultHandler(NO);
    }
}

- (void)passcodeViewControllerDidFailAttempt:(BKPasscodeViewController *)aViewController
{
    self.failedAttempts++;
    
    if (self.failedAttempts > 5) {
        
        NSTimeInterval timeInterval = 60;
        
        if (self.failedAttempts > 6) {
            
            NSUInteger multiplier = self.failedAttempts - 6;
            
            timeInterval = (5 * 60) * multiplier;
            
            if (timeInterval > 3600 * 24) {
                timeInterval = 3600 * 24;
            }
        }
        
        self.lockUntilDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    }
}

- (NSUInteger)passcodeViewControllerNumberOfFailedAttempts:(BKPasscodeViewController *)aViewController
{
    return self.failedAttempts;
}

- (NSDate *)passcodeViewControllerLockUntilDate:(BKPasscodeViewController *)aViewController
{
    return self.lockUntilDate;
}

- (void)passcodeViewController:(BKPasscodeViewController *)aViewController didFinishWithPasscode:(NSString *)aPasscode
{
    switch (aViewController.type) {
        case BKPasscodeViewControllerNewPasscodeType:
        {
            [CHKeychain save:@"KEY_PRIVACY" data:aPasscode];
            
            break;
        }
        case BKPasscodeViewControllerChangePasscodeType:
        {
            self.passcode = aPasscode;
            self.failedAttempts = 0;
            self.lockUntilDate = nil;
            break;
        }
        case BKPasscodeViewControllerCheckPasscodeType:
        {

        }
        default:
            break;
    }
    
    [aViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
