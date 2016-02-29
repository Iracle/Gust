//
//  TouchIdHelper.h
//  Gust
//
//  Created by Iracle Zhang on 2/29/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchIdHelper : NSObject

- (void)authenticateUser:(void (^)(_Bool isEnter)) handler;

@end
