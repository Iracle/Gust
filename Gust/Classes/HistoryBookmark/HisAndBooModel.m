//
//  HisAndBooModel.m
//  Gust
//
//  Created by Iracle on 3/10/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import "HisAndBooModel.h"
#import "CoreDataManager.h"
#import "History.h"
#import "Bookmark.h"


@implementation HisAndBooModel

+ (NSArray *)getDataWithType:(NSString *)dataType
{
    NSArray *rusultsArray;
    if ([dataType isEqualToString:@"Bookmark"]) {
       rusultsArray = [CoreDataManager searchObjectWithEntityName:[Bookmark entityName] predicateString:@""];
    } else {
       rusultsArray = [CoreDataManager searchObjectWithEntityName:[History entityName] predicateString:@""];
    }
    return rusultsArray;
}
@end


