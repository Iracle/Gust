//
//  InputRecord.h
//  Gust
//
//  Created by Iracle on 15/4/21.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InputRecord : NSManagedObject

@property (nonatomic, retain) NSString * inputString;

+(NSString *)entityName;

@end
