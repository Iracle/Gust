//
//  GustConfigure.h
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#ifndef Gust_GustConfigure_h
#define Gust_GustConfigure_h

#endif

//picture
#define PNGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME,EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define IMAGENAMED(NAME)       [UIImage imageNamed:NAME]
#define ORIGINAL_IMAGE(NAME)   [[UIImage imageNamed:NAME] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

//size
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//custom define
static const CGFloat MainTouchViewRadius = 57.5;
static const CGFloat SearchBarHeight = 45;

#define COLLECTION_CELL_WIDTH SCREEN_WIDTH / 3
#define COLLECTION_CELL_HIGHT SCREEN_WIDTH / 3
#define COLLECTION_CONTENT_WIDTH (SCREEN_WIDTH - 70) / 3
#define COLLECTION_CONTENT_OFFSET (COLLECTION_CELL_WIDTH - COLLECTION_CONTENT_WIDTH) / 2

#define EntityNameBookmark @"Bookmark"
#define EntityNameHistory @"History"

//userDefaults
#define TopSits @"topSitsData"

//the location of mainTouchView
#define MainTouchViewIsLocation @"mainTouchViewIsLocation"
#define MainTouchViewLocationLeft @"mainTouchViewLocationLeft"
#define MainTouchViewLocationRight @"mainTouchViewLocationRight"

//defualt search engin
#define DefautSearchEngin @"DefautSearchEngin"
#define SearchEnginBaidu @"SearchEnginBaidu"
#define SearchEnginGoogle @"SearchEnginGoogle"

#define PageName @"pageName"
#define PageUrl @"pageUrl"
#define ImageUrl @"imageUrl"

//UserDefualts
//privacy mode
#define IsGustPrivacy @"gustPrivacy"

//screenshot image
#define CurrentViewShot @"currentViewShot"

#define InputRecordString @"inputString"

//defuat guide
#define GuideIsShow @"guideIsShow"

const static float HomePageCancelButtonAlpha = 0.9999999;

//notification
#define NotificationUpdateTopSites                @"notificationUpdateTopSites"
#define NotificationUpdateMainTouchViewLocation   @"notificationUpdateMainTouchViewLocation"
#define NotificationChangeDefautSearchEngin       @"notificationChangeDefautSearchEngin"
#define NotificationResetTransitionDuration       @"notificationResetTransitionDuration"
#define NotificationDeleteTopsit                  @"notificationDeleteTopsit"
#define NotificationReminderMe                    @"notificationReminderMe"
#define NotificationOpenTodayUrl                  @"notificationOpenTodayUrl"


#define ShareText @"我在Gust浏览器发现了一个好网站，快来看看吧："
#define BaiduWebsite @"http://www.baidu.com"
#define GoogleWebsite @"http://www.google.com.tw"

//color
#define HOME_COLOR [UIColor colorWithRed:251/255.0 green:252/255.0 blue:253/255.0 alpha:1.0]
#define HOME_COLLECTIONCELL_COLOR [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1.0]
#define HOME_COLLECTIONCELL_SHADOW_COLOR [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.2]
#define SEARCH_BAR_SHADOW_COLOR [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3]





