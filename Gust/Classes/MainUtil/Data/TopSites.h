//
//  TopSites.h
//  Gust
//
//  Created by Iracle on 15/4/10.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TopSites : NSManagedObject

@property (nonatomic, retain) NSString * pageName;
@property (nonatomic, retain) NSString * pageUrl;
@property (nonatomic, retain) NSString * imageUrl;

+ (NSString *)entityName;

@end
