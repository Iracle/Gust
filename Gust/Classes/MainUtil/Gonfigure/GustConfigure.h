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

//color
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//custom define
static const CGFloat MainTouchViewRadius = 57.5;
static const CGFloat SearchBarHeight = 45;

#define CollectionViewCellSize (self.view.bounds.size.width - 60) / 3
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

//privacy mode
#define IsGustPrivacy @"gustPrivacy"

//screenshot image
#define CurrentViewShot @"currentViewShot"

#define InputRecordString @"inputString"

//defuat guide
#define GuideIsShow @"guideIsShow"

const static float HomePageCancelButtonAlpha = 0.9999999;

//notification
#define NotificationUpdateTopSites @"notificationUpdateTopSites"
#define NotificationUpdateMainTouchViewLocation @"notificationUpdateMainTouchViewLocation"
#define NotificationChangeDefautSearchEngin @"notificationChangeDefautSearchEngin"

#define ShareText @"我在Gust浏览器发现了一个好网站，快来看看吧："

#define BaiduWebsite @"http://www.baidu.com"
#define GoogleWebsite @"http://www.google.com.tw"

//keychain

//color
#define HOME_COLOR [UIColor colorWithRed:251/255.0 green:252/255.0 blue:253/255.0 alpha:1.0]
#define HOME_COLLECTIONCELL_COLOR [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1.0]
#define HOME_COLLECTIONCELL_SHADOW_COLOR [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]


#define SEARCH_BAR_SHADOW_COLOR [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.6]





