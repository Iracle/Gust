//
//  TopSites.m
//  Gust
//
//  Created by Iracle on 15/4/10.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "TopSites.h"


@implementation TopSites

@dynamic pageName;
@dynamic pageUrl;
@dynamic imageUrl;

+ (NSString *)entityName
{
    return @"TopSites";
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; pageName = %@; pageUrl = %@; imageUrl = %@>", [self class], self, self.pageName, self.pageUrl, self.imageUrl];
    
}
@end
