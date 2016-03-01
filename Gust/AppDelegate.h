//
//  AppDelegate.h
//  Gust
//
//  Created by Iracle on 15/3/3.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BKPasscodeLockScreenManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BKPasscodeLockScreenManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

