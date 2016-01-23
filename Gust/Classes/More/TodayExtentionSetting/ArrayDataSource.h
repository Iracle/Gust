//
//  ArrayDataSource.h
//  LightVCFirstDemo
//
//  Created by Iracle on 3/18/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef void (^TableViewConfigureBlock) (id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;

- (instancetype)initWithItems:(NSArray *)anItem cellIdentifier:(NSString *)acellIdentifier cellConfigureBlock:(TableViewConfigureBlock) atableViewConfigureBlock;

@end
