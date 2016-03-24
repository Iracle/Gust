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
#define SCREEN_MID_X ([UIScreen mainScreen].bounds.size.width / 2)
#define SCREEN_MID_Y ([UIScreen mainScreen].bounds.size.height / 2)
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

#define AppVersion @"appVersion"

#define BaiduVoice @"baiduVoice"

const static float HomePageCancelButtonAlpha = 0.9999999;

//notification
#define NotificationUpdateTopSites                @"notificationUpdateTopSites"
#define NotificationUpdateMainTouchViewLocation   @"notificationUpdateMainTouchViewLocation"
#define NotificationChangeDefautSearchEngin       @"notificationChangeDefautSearchEngin"
#define NotificationResetTransitionDuration       @"notificationResetTransitionDuration"
#define NotificationDeleteTopsit                  @"notificationDeleteTopsit"
#define NotificationReminderMe                    @"notificationReminderMe"
#define NotificationOpenTodayUrl                  @"notificationOpenTodayUrl"
#define NotificationAddNewWeb                     @"notificationAddNewWeb"
#define NotificationRevertPopAnimation            @"notificationRevertPopAnimation"


#define ShareText @"我在Gust浏览器发现了一个好网站，快来看看吧："
#define BaiduWebsite @"http://www.baidu.com"
#define GoogleWebsite @"http://www.google.com.tw"

//color
#define HOME_COLOR [UIColor colorWithRed:251/255.0 green:252/255.0 blue:253/255.0 alpha:1.0]
#define HOME_COLLECTIONCELL_COLOR [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1.0]
#define HOME_COLLECTIONCELL_SHADOW_COLOR [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.2]
#define SEARCH_BAR_SHADOW_COLOR [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3]


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif





