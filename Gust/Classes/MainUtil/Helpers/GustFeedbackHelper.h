//
//  GustFeedbackHelper.h
//  Gust
//
//  Created by Iracle Zhang on 3/12/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
@import UIKit;

@interface GustFeedbackHelper : NSObject

@property (nonatomic, strong) UIViewController *rootViewController;
- (void)sendEmailAction:(UIViewController *) viewController;

@end
