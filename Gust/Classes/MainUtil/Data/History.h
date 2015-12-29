//
//  History.h
//  Gust
//
//  Created by Iracle on 3/9/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface History : NSManagedObject

@property (nonatomic, retain) NSString * pageName;
@property (nonatomic, retain) NSString * pageUrl;
@property (nonatomic, retain) NSString * imageUrl;

+ (NSString *)entityName;
@end
