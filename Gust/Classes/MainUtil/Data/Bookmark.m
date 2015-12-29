//
//  Bookmark.m
//  Gust
//
//  Created by Iracle on 3/9/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import "Bookmark.h"


@implementation Bookmark

@dynamic pageName;
@dynamic pageUrl;
@dynamic imageUrl;

+ (NSString *)entityName
{
    return @"Bookmark";
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; pageName = %@; pageUrl = %@; imageUrl = %@>", [self class], self, self.pageName, self.pageUrl, self.imageUrl];

}

@end

