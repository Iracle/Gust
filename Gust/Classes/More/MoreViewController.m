//
//  MoreViewController.m
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "MoreViewController.h"
#import  "GustRefreshHeader.h"
#import "GustWebViewController.h"
#import "TopSitesManageViewController.h"
#import "DefaultSearchViewController.h"
#import "AboutGustViewController.h"
#import "SetPrivacyPasswordViewController.h"
#import "UINavigationBar+Addition.h"
#import "SettingsTableViewCell.h"


@interface MoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)  NSArray *tableListDataArray;
@property (nonatomic, copy)    NSArray *detailPageClassNames;
@property (nonatomic, strong)  GustRefreshHeader *refreshHeader;

@end

@implementation MoreViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"设置";
        _detailPageClassNames = @[@"TopSitesManageViewController", @"DefaultSearchViewController", @"SetPrivacyPasswordViewController", @"PushNotifictionSettingController", @"ClearWebCacheController", @"FunctionIntroduceController", @"FeedbackController",@"AboutGustViewController"];
        _tableListDataArray = @[@"首页书签管理",@"默认搜索引擎", @"隐私模式密码", @"推送设置", @"清除缓存", @"功能介绍", @"反馈", @"关于"];
    }
    return self;
}

- (UITableView *)tableView
{
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar hideBottomHairline];
    navigationBar.barTintColor = [UIColor whiteColor];
    navigationBar.tintColor = [UIColor colorWithRed:0.3253 green:0.3253 blue:0.3253 alpha:1.0];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.3107 green:0.3107 blue:0.3107 alpha:1.0]}];
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    
    [self.view addSubview:self.tableView];
    
    _refreshHeader = [[GustRefreshHeader alloc] init];
    _refreshHeader.scrollView = self.tableView;
    [_refreshHeader addHeadView];
    __strong typeof (self) strongSelf = self;
    _refreshHeader.beginRefreshingBlock = ^(){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        });
        
    };

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
        
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
        [cell configCell:_tableListDataArray[indexPath.row]];
        
    } else {
        [cell configCell:_tableListDataArray[indexPath.row + 5]];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *destinationViewController;
    if (indexPath.section == 0) {
        destinationViewController = [[NSClassFromString(_detailPageClassNames[indexPath.row]) alloc] init];
    } else {
        destinationViewController = [[NSClassFromString(_detailPageClassNames[indexPath.row + 5]) alloc] init];

    }
    [self.navigationController pushViewController:destinationViewController animated:YES];
}




@end
