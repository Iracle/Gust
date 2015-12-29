//
//  MainSearchBarTextManage.m
//  Gust
//
//  Created by Iracle on 15/4/16.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "MainSearchBarTextManage.h"

@implementation MainSearchBarTextManage

+ (NSMutableString *)manageTextFieldText:(NSString *)text
{
    NSMutableString *willReturnString = [NSMutableString stringWithString:text];
    if ([willReturnString hasSuffix:@".com"] || [willReturnString hasSuffix:@".cn"] || [willReturnString hasSuffix:@".net"] || [willReturnString hasSuffix:@".org"] || [willReturnString hasSuffix:@".me"]) {
        [willReturnString insertString:@"http://" atIndex:0];
        return willReturnString;
    } else
    {
        [willReturnString insertString:@"s" atIndex:0];
         
        return  willReturnString;
    }

}
@end
