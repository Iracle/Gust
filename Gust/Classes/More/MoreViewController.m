//
//  MoreViewController.m
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "MoreViewController.h"
#import "GustRefreshHeader.h"
#import "GustWebViewController.h"
#import "TopSitesManageViewController.h"
#import "DefaultSearchViewController.h"
#import "AboutGustViewController.h"
#import "SetPrivacyPasswordViewController.h"
#import "UINavigationBar+Addition.h"
#import "SettingsTableViewCell.h"
#import "GustConfigure.h"
#import "TodayExtentionWebSeletedViewController.h"
#import "AllAlertView.h"
#import "Localisator.h"
#import "GustFeedbackHelper.h"
#import "UIColor+Gust.h"

@interface MoreViewController () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong)  NSArray<NSString *> *tableListDataArray;
@property (nonatomic, copy)    NSArray<NSString *> *detailPageClassNames;
@property (nonatomic, copy)    NSArray<NSString *> *settingIcons;
@property (nonatomic, strong)  GustRefreshHeader *refreshHeader;


@end

@implementation MoreViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _detailPageClassNames = @[@"TopSitesManageViewController", @"DefaultSearchViewController", @"SetPrivacyPasswordViewController", @"TodayExtentionWebSeletedViewController",@"ChooseLanguageViewController", @"BaiduVoiceSettingViewController",@"ClearWebCacheController", @"FunctionIntroduceController", @"FeedbackController",@"AboutGustViewController"];
        _settingIcons = @[@"settingTopsite", @"settingSearch", @"settingPrivacy", @"settingPush",@"settingsLanguage", @"settingVoice", @"settingClear", @"settingGuide", @"settingFeedback", @"settingAbout"];

    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 54.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];

    }
    return _tableView;
}

- (GustRefreshHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [[GustRefreshHeader alloc] init];
        _refreshHeader.scrollView = self.tableView;
        [_refreshHeader addHeadView];
    }
    return  _refreshHeader;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.tableView];
    
    __strong typeof (self) strongSelf = self;
    self.refreshHeader.beginRefreshingBlock = ^(){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        });
        
    };

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewFromLocalisation];

    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar hideBottomHairline];
    navigationBar.barTintColor = [UIColor whiteColor];
    navigationBar.tintColor = [UIColor whiteColor];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.3107 green:0.3107 blue:0.3107 alpha:1.0]}];
    
    self.view.backgroundColor = [UIColor baseBackgroudColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];

}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
        
    } else {
        return 3;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MoreCell";
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.leftImage.image = IMAGENAMED(_settingIcons[indexPath.row]);
        [cell configCell:_tableListDataArray[indexPath.row]];
         NSLog(@"ll:%@",_tableListDataArray[indexPath.row]);
        
    } else {
        cell.leftImage.image = IMAGENAMED(_settingIcons[indexPath.row + 7]);
        [cell configCell:_tableListDataArray[indexPath.row + 7]];
         NSLog(@"jj:%@",_tableListDataArray[indexPath.row + 7]);
    }
    
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *destinationViewController;
    if (indexPath.section == 0) {
        if (indexPath.row == 6) {
            [self clearWebCookieAndCache];
            return;
        }

        destinationViewController = [[NSClassFromString(_detailPageClassNames[indexPath.row]) alloc] init];
    } else {
        if (indexPath.row == 1) {
            //send feedback email
            [[[GustFeedbackHelper alloc] init] sendEmailAction:self];
            return;
        }
        destinationViewController = [[NSClassFromString(_detailPageClassNames[indexPath.row + 7]) alloc] init];

    }
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

#pragma mark -- Web Cache
- (void)clearWebCookieAndCache {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    [[AllAlertView sharedAlert] showWithTitle: LOCALIZATION(@"DataCLeared") alertType:AllAlertViewAlertTypeDone height:100.0];

}
- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self configureViewFromLocalisation];
    }
}

- (void)configureViewFromLocalisation {
    
    self.title = LOCALIZATION(@"Settings");
    _tableListDataArray = @[LOCALIZATION(@"TopSites"), LOCALIZATION(@"SearchEngine"), LOCALIZATION(@"PasscodeLock"), LOCALIZATION(@"TodayExtention"), LOCALIZATION(@"Language"),LOCALIZATION(@"VoiceSetting"), LOCALIZATION(@"ClearDara"),LOCALIZATION(@"UserGuide"), LOCALIZATION(@"SendFeedback"), LOCALIZATION(@"AboutApp")];
    [self.tableView reloadData];

}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    

    [self dismissViewControllerAnimated:YES completion:nil];
}







@end
