//
//  LockWindow.h
//  Gust
//
//  Created by Iracle Zhang on 2/29/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockWindow : UIWindow

+ (LockWindow *)shareLockWindow;

- (void)showLockWindow;
- (void)dismissLockWindow;


@end
