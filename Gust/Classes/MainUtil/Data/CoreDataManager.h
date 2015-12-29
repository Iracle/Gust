//
//  CoreDataManager.h
//  Gust
//
//  Created by Iracle on 3/9/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

+ (BOOL)insertObjectWithParameter:(NSDictionary *)parameters entityName:(NSString *)entityName;

+ (NSArray *)searchObjectWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString;

+ (BOOL)removeObjectWithEntityName:(NSString *)entityName predicateString:(NSString *)predicateString;

@end

