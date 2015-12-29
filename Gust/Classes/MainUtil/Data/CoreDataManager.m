//
//  CoreDataManager.m
//  Gust
//
//  Created by Iracle on 3/9/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"

@implementation CoreDataManager

+ (NSManagedObjectContext * )managedObjectContext
{
    return [(AppDelegate *) [UIApplication sharedApplication].delegate managedObjectContext];
}
+ (BOOL) insertObjectWithParameter: (NSDictionary *)parameters entityName: (NSString *) entityName
{
    
    if ([entityName length ] == 0) {
        return NO;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 1.获取数据
    //2.新建模型对象
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    // 3.配置对象数据
    for (NSString *key in parameters) {
        [object setValue:parameters[key] forKey:key];
    }
    // 4.保存同步文件
    NSError *error = nil;
    BOOL success = [context save:&error];
    NSAssert(success, @"save operation did failed with error message '%@'.", [error localizedDescription]);
    
    return  success;
    
}

//数据的查询
+ (NSArray *)searchObjectWithEntityName: (NSString *)entityName predicateString: (NSString *) predicateString;
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if ([entityName length ] == 0) {
        return nil;
    }
    
    // 1.初始化查询请求
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    // 配置查询条件
    if ([predicateString length] > 0) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:predicateString];
    }
    
    // 2.执行查询
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    NSAssert(!error, @"fetch operation did failed with error message '%@'.", [error localizedDescription]);
    // 3.处理查询结果
    return objects;
    
}

+(BOOL) removeObjectWithEntityName: (NSString *) entityName predicateString: (NSString *) predicateString
{
    BOOL sucess = NO;
    if ([entityName length] == 0) {
        return sucess;
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    NSArray *objects = [self searchObjectWithEntityName:entityName predicateString:predicateString];
    
    //对象删除
    for (id object in objects) {
        [context deleteObject:object];
    }
    // 3.保存同步文件
    NSError *error = nil;
    BOOL success = [context save:&error];
    return success;
    
    
    
}

@end
