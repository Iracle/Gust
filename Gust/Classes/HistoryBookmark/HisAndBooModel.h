//
//  HisAndBooModel.h
//  Gust
//
//  Created by Iracle on 3/10/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HisAndBooModel : NSObject

@property (nonatomic,copy) NSString *pageName;
@property (nonatomic,copy) NSString *pageUrl;
@property (nonatomic,copy) NSString *imageUrl;

+ (NSArray *)getDataWithType:(NSString *)dataType;

@end
