//
//  GustBKPasscodeDelegate.h
//  Gust
//
//  Created by Iracle Zhang on 3/1/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKPasscodeViewController.h"

@interface GustBKPasscodeDelegate : NSObject <BKPasscodeViewControllerDelegate>

@property (strong, nonatomic) NSString          *passcode;
@property (nonatomic) NSUInteger                failedAttempts;
@property (strong, nonatomic) NSDate            *lockUntilDate;

@end
