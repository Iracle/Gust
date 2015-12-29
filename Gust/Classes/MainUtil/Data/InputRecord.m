//
//  InputRecord.m
//  Gust
//
//  Created by Iracle on 15/4/21.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "InputRecord.h"


@implementation InputRecord

@dynamic inputString;

+ (NSString *)entityName
{
    return @"InputRecord";
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; inputString = %@>", [self class], self, self.inputString];
    
}
@end
