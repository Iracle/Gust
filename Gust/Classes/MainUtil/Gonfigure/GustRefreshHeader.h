//
//  GustRefreshHeader.h
//  Gust
//
//  Created by Iracle on 3/11/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^BeginRefreshingBlock)(void);

@protocol GustRefreshDelegate <NSObject>

- (void)dismissToPreviousViewController;

@end
@interface GustRefreshHeader : NSObject

@property UIScrollView *scrollView;
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
@property (nonatomic, assign) id<GustRefreshDelegate> delegate;
-(void)addHeadView;
-(void)endRefreshing;
-(void)beginRefreshing;


@end
