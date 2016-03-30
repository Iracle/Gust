//
//  AppDelegate.m
//  Gust
//
//  Created by Iracle on 15/3/3.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "GustConfigure.h"
#import "GuideViewController.h"
#import "GustBKPasscodeDelegate.h"
#import "OpenShareHeader.h"
#import "Localisator.h"
#import "BDVRSConfig.h"
#import "CoreDataManager.h"
#import "TopSites.h"
#import <Bugtags/Bugtags.h>

@interface AppDelegate ()
@property (nonatomic, strong) GustBKPasscodeDelegate *gustBKPasscodeDelegate;

@end

@implementation AppDelegate

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //lock passcode
    self.gustBKPasscodeDelegate = [[GustBKPasscodeDelegate alloc] init];
    [[BKPasscodeLockScreenManager sharedManager] setDelegate:self];
    [[BKPasscodeLockScreenManager sharedManager] showLockScreen:NO];
    
    //open the baidu voice tone
    BOOL showTone = [[NSUserDefaults standardUserDefaults] boolForKey:BaiduVoice];
    if (!showTone) {
        [BDVRSConfig sharedInstance].playStartMusicSwitch = YES;
        [BDVRSConfig sharedInstance].playEndMusicSwitch = YES;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    nav.navigationBar.hidden = YES;
    self.window.rootViewController = nav;
    
    //mainTouchView initialize location is left
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:MainTouchViewIsLocation]) {
        [defaults setObject:MainTouchViewLocationLeft forKey:MainTouchViewIsLocation];
        [defaults synchronize];
    }
    
    //defaut search engin is baidu.com
    NSUserDefaults *searcDefaults = [NSUserDefaults standardUserDefaults];
    if (![searcDefaults objectForKey:DefautSearchEngin]) {
        [searcDefaults setObject:SearchEnginBaidu forKey:DefautSearchEngin];
        [searcDefaults synchronize];
    }
    
    //register Weichat share
    [OpenShare connectWeixinWithAppId:@"wx98e8def97c8002f0"];
    
    //First Open App
    NSString *currentAppVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *appVersion =  [[NSUserDefaults standardUserDefaults] objectForKey:AppVersion];
    if (appVersion == nil || currentAppVersion != appVersion) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:AppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        self.window.rootViewController = guideVC;
        [self loadSomeTopSite];
        
    }
    
    //degbug
    [Bugtags startWithAppKey:@"e2e75f419487ce335b89bd8f6dc09fff" invocationEvent:BTGInvocationEventShake];
    

    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //第二步：添加回调
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    //这里可以写上其他OpenShare不支持的客户端的回调，比如支付宝等。
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [[BKPasscodeLockScreenManager sharedManager] showLockScreen:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    


}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark -- today extention
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([url.scheme isEqualToString:@"LocalNotification"]) {
        if ([url.host isEqualToString:@"finished"]) {
            [self performSelector:@selector(delayOpenTodayWeb) withObject:nil afterDelay:1];
        }
        if ([url.host isEqualToString:@"space"]) {
            [self performSelector:@selector(delayAddNewTodayWeb) withObject:nil afterDelay:1];
        }
    }
    return YES;
}

- (void)delayOpenTodayWeb {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationOpenTodayUrl object:nil];

}

- (void)delayAddNewTodayWeb {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAddNewWeb object:nil];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Iracle.Gust" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Gust" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Gust.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -- Lock Passcode
- (BOOL)lockScreenManagerShouldShowLockScreen:(BKPasscodeLockScreenManager *)aManager
{
    //privacy mode
    NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
    BOOL privicyBool = [privacyDefaults boolForKey:IsGustPrivacy];
    if (privicyBool) {
        return YES;
    } else {
        return NO;
    }
}

- (UIViewController *)lockScreenManagerPasscodeViewController:(BKPasscodeLockScreenManager *)aManager
{
    BKPasscodeViewController *viewController = [[BKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
    viewController.type = BKPasscodeViewControllerCheckPasscodeType;
    viewController.delegate = self.gustBKPasscodeDelegate;
    
    viewController.touchIDManager = [[BKTouchIDManager alloc] initWithKeychainServiceName:@"BKPasscodeSampleService"];
    viewController.touchIDManager.promptText = @"Scan fingerprint to unlock";
    viewController.title = LOCALIZATION(@"UnlockPasscode");
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    return navController;
}

- (void)loadSomeTopSite {
    
    NSDictionary *saveDic = @{PageName:@"Yahoo", PageUrl: @"https://www.yahoo.com/"};
    NSDictionary *saveDic1 = @{PageName:@"一点资讯", PageUrl: @"http://www.yidianzixun.com/"};
    NSDictionary *saveDic2 = @{PageName:@"果壳网移动版", PageUrl: @"http://m.guokr.com/"};
    NSDictionary *saveDic3 = @{PageName:@"豆瓣东西", PageUrl: @"https://dongxi.douban.com/"};
    
    NSArray *array = @[saveDic, saveDic1, saveDic2, saveDic3];
    
    for (NSInteger index = 0; index < array.count; index ++) {
        [CoreDataManager insertObjectWithParameter:array[index] entityName:[TopSites entityName]];
    }

    
}

@end












