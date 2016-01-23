//
//  TodayExtentionWebSeletedViewController.m
//  Gust
//
//  Created by Iracle Zhang on 1/22/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "TodayExtentionWebSeletedViewController.h"
#import "SettingsTableViewCell.h"
#import "GustConfigure.h"
#import "ArrayDataSource.h"
#import "HisAndBooModel.h"
#import "History.h"
#import "Bookmark.h"
#import "GustRefreshHeader.h"

#define SELECTED_VIEW_HEIGHT (SCREEN_HEIGHT - 200.0)

@interface TodayExtentionWebSeletedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *todayWebs;
@property (nonatomic, strong) UIWindow *seletedWindow;
@property (nonatomic, strong) UIView *seletedContainView;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UITableView *seletedTableView;
@property (nonatomic, strong) ArrayDataSource *arraydataSource;
@property (nonatomic, strong) NSMutableArray *webItems;
@property (nonatomic, strong) GustRefreshHeader *refreshHeader;


@end

@implementation TodayExtentionWebSeletedViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 54.0;
        _tableView.tableFooterView = [UIView new];
        _tableView.editing = YES;
        _tableView.allowsSelectionDuringEditing = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
    }
    return _tableView;
}
- (UITableView *)seletedTableView {
    if (!_seletedTableView) {
        _seletedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10.0, SCREEN_WIDTH, CGRectGetHeight(self.seletedContainView.bounds) - 10 - 50)];
        
        _seletedTableView.rowHeight = 45.0;
        _seletedTableView.tableFooterView = [UIView new];
        
        self.refreshHeader.scrollView = _seletedTableView;
        [self.refreshHeader addHeadView];
        self.refreshHeader.pullBackOffset = 0.8;
        __weak typeof(self) weakSelf = self;
        self.refreshHeader.beginRefreshingBlock = ^(){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hiddeSeletedPanel];
            });
        };

    }
    return _seletedTableView;
}

- (GustRefreshHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [[GustRefreshHeader alloc] init];
    }
    return _refreshHeader;
}

- (UIWindow *)seletedWindow {
    if (!_seletedWindow) {
        _seletedWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _seletedWindow.alpha = 0.0;
        _seletedWindow.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    }
    return _seletedWindow;
}

- (UIView *)seletedContainView {
    if (!_seletedContainView) {
        _seletedContainView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SELECTED_VIEW_HEIGHT)];
        _seletedContainView.backgroundColor = [UIColor whiteColor];
    }
    return _seletedContainView;
}

- (UISegmentedControl *)segment
{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"书签", @"历史记录", @"自定义"]];
        _segment.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 70, 35);
        _segment.center = CGPointMake(CGRectGetMidX(self.seletedContainView.bounds), CGRectGetMaxY(self.seletedContainView.bounds) - 22.5);
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
        _segment.tintColor = [UIColor colorWithRed:93 / 255.0 green:148 / 255.0 blue:140 / 255.0 alpha:1.0];
    }
    return _segment;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"选择快速启动网页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
    [self loadTodayWebsData];

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTodayWeb:)];
    addItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = addItem;

}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _todayWebs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"topSitesManageCell";
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.webTitle.text = self.todayWebs[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

- (void)loadTodayWebsData{
    _todayWebs = [@[@"雅虎新闻", @"苹果官网"] mutableCopy];
    [self.tableView reloadData];
}

- (void)addTodayWeb:(UIBarButtonItem *)item {
    [self.seletedWindow makeKeyAndVisible];

    [self.seletedWindow addSubview:self.seletedContainView];
    [self.seletedContainView addSubview:self.segment];
    
    NSArray *bookmarks = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"Bookmark"]];
    self.webItems = [NSMutableArray arrayWithArray:bookmarks];
    
    self.arraydataSource = [[ArrayDataSource alloc] initWithItems:self.webItems cellIdentifier:@"cellIdentifier" cellConfigureBlock:^(UITableViewCell *cell, NSManagedObject *data) {
        
        cell.textLabel.text = [data valueForKey:PageName];
        
    }];
    self.seletedTableView.dataSource = self.arraydataSource;
    [self.seletedContainView addSubview:self.seletedTableView];
    
    
    [UIView animateWithDuration:0.24 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.seletedWindow.alpha = 1.0;
        self.seletedContainView.transform = CGAffineTransformMakeTranslation(0.0, -SELECTED_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)segmentAction:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    if (index == 0) {
        NSArray *bookmarks = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"Bookmark"]];
        self.webItems = [NSMutableArray arrayWithArray:bookmarks];
        self.arraydataSource.items = [self.webItems copy];
        [self.seletedTableView reloadData];

    } else if (index == 1) {
        NSArray *histories = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"History"]];
        self.webItems = [NSMutableArray arrayWithArray:histories];
        self.arraydataSource.items = [self.webItems copy];
        [self.seletedTableView reloadData];
    } else {

    }
}

- (void)hiddeSeletedPanel {
    [UIView animateWithDuration:0.24 animations:^{
        self.seletedContainView.transform = CGAffineTransformIdentity;
        self.seletedWindow.alpha = 0.0;
        
    } completion:^(BOOL finished) {
       [_refreshHeader endRefreshing];
        for (UIView *windowSubView in self.seletedWindow.subviews) {
            [windowSubView removeFromSuperview];
        }
        
        _seletedWindow.hidden = YES;
        [_seletedWindow resignKeyWindow];
        _seletedWindow = nil;
    }];
}

- (void)customInputWeb {
    self.webItems = nil;
    self.arraydataSource.items = nil;
    self.seletedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.seletedTableView.separatorColor = [UIColor clearColor];
    [self.seletedTableView reloadData];
}

- (void)seletedBookmarksAndHistories {
    self.seletedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.seletedTableView.separatorColor = [UIColor clearColor];
}

@end









