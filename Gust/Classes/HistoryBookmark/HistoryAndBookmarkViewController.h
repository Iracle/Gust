//
//  HistoryAndBookmarkViewController.h
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GetUrlValueBlock) (NSString *value);
typedef void (^NotificationHomeBlock) ();
typedef void (^GetUrlToHomeValueBlock) (NSString *value);


@interface HistoryAndBookmarkViewController : UIViewController 

@property (nonatomic, strong) GetUrlValueBlock getUrlValueBlock;
@property (nonatomic, strong) GetUrlToHomeValueBlock getUrltoHomeValueBlock;

@property (nonatomic, assign) BOOL isFromHomePage;



@end
