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

@interface MoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *tableListDataArray;
@property (nonatomic, strong) GustRefreshHeader *refreshHeader;

@end

@implementation MoreViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"更多";
        _tableListDataArray = @[@"首页书签管理",@"默认搜索引擎", @"设置隐私模式密码", @"关于"];
    }
    return self;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.rowHeight = 70.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view setNeedsUpdateConstraints];

    }
    
    return _tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableListDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _tableListDataArray[indexPath.row];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        TopSitesManageViewController *topSitesManageVC = [[TopSitesManageViewController alloc] init];
        [self.navigationController pushViewController:topSitesManageVC animated:YES];
    } else if (indexPath.row == 1) {
        DefaultSearchViewController *defaultSearchVC = [[DefaultSearchViewController alloc] init];
        [self.navigationController pushViewController:defaultSearchVC animated:YES];
    } else if (indexPath.row == 2) {
        SetPrivacyPasswordViewController *privacyVC = [[SetPrivacyPasswordViewController alloc] init];
        [self.navigationController pushViewController:privacyVC animated:YES];
        } else if(indexPath.row == 3) {
        AboutGustViewController *aboutGustVC = [[AboutGustViewController alloc] init];
        [self.navigationController pushViewController:aboutGustVC animated:YES];

    }
}




@end
