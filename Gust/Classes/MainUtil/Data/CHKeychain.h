//
//  CHKeychain.h
//  Keychain
//
//  Created by Iracle Zhang on 15/11/6.
//  Copyright © 2015年 Iracle Zhang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface CHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;


@end