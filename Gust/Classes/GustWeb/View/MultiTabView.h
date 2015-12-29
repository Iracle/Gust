//
//  MultiTabView.h
//  Gust
//
//  Created by Iracle on 4/26/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MultiGetUrlValueBlock) (NSString *value);
typedef void (^MultiUpdateDataArrayBlock) (NSMutableArray *array);


@interface MultiTabView : UIVisualEffectView

@property (nonatomic, strong) MultiGetUrlValueBlock mutiGetUrlValueBlock;
@property (nonatomic, strong) MultiUpdateDataArrayBlock multiUpdateDataArrayBlock;

- (void)showInView:(UIWindow *)view tabArray:(NSMutableArray *)tabArray;
@end
