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
#import "AllAlertView.h"

#define SELECTED_VIEW_HEIGHT (SCREEN_HEIGHT - 200.0)

@interface TodayExtentionWebSeletedViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, copy)   NSMutableArray   *todayWebs;
@property (nonatomic, strong) UIWindow         *seletedWindow;
@property (nonatomic, strong) UIView           *seletedContainView;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UITableView       *seletedTableView;
@property (nonatomic, strong) ArrayDataSource   *arraydataSource;
@property (nonatomic, copy)   NSMutableArray    *webItems;
@property (nonatomic, strong) GustRefreshHeader *refreshHeader;

@property (nonatomic, strong) UITextField       *webNameTextField;
@property (nonatomic, strong) UITextField       *webUrlTextField;
@property (nonatomic, strong) UILabel           *alertLabel;

@end

@implementation TodayExtentionWebSeletedViewController

- (UITextField *)webNameTextField {
    if (!_webNameTextField) {
        _webNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.0, 0, SCREEN_WIDTH, 54.0)];
        _webNameTextField.placeholder = @"请输入网站名";
        _webNameTextField.delegate = self;
        
    }
    return _webNameTextField;
}

- (UITextField *)webUrlTextField {
    if (!_webUrlTextField) {
        _webUrlTextField = [[UITextField alloc] initWithFrame:CGRectMake(15.0, 54.0, SCREEN_WIDTH, 54.0)];
        _webUrlTextField.placeholder = @"请输入网址";
        _webUrlTextField.text = @"http://";
        _webUrlTextField.keyboardType = UIKeyboardTypeURL;
        _webUrlTextField.returnKeyType = UIReturnKeyDone;
        _webUrlTextField.delegate = self;
        
    }
    return _webUrlTextField;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 108.0, SCREEN_WIDTH, 54.0)];
        _alertLabel.text = @"下拉取消";
        _alertLabel.textColor = [UIColor colorWithRed:0.3554 green:0.3554 blue:0.3554 alpha:1.0];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
        
    }
    return _alertLabel;
}

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
        _seletedTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _seletedTableView.separatorColor = [UIColor colorWithRed:0.9471 green:0.9471 blue:0.9471 alpha:1.0];
        _seletedTableView.rowHeight = 45.0;
        _seletedTableView.tableFooterView = [UIView new];
        _seletedTableView.delegate = self;
        
        self.refreshHeader.scrollView = _seletedTableView;
        [self.refreshHeader addHeadView];
        self.refreshHeader.pullBackOffset = 0.8;
        __strong typeof(self) weakSelf = self;
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
        _seletedWindow.windowLevel = UIWindowLevelNormal;
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
    cell.webTitle.text = self.todayWebs[indexPath.row][PageName];
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
        [self.todayWebs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveWebInfoToUserDefaults];
        
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSDictionary *willMoveDic = [self.todayWebs objectAtIndex:sourceIndexPath.row];
    [self.todayWebs removeObject:willMoveDic];
    [self.todayWebs insertObject:willMoveDic atIndex:destinationIndexPath.row];
    [self saveWebInfoToUserDefaults];
    
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.seletedContainView endEditing:YES];
    if (self.webNameTextField.text.length > 0 && self.webUrlTextField.text.length > 0) {
        if (self.todayWebs.count > 3) {
            [[AllAlertView sharedAlert] showWithTitle:@"网页不能超过4个" alertType:AllAlertViewAlertTypeRemind height:100.0];
            return NO;
        }
        NSDictionary *seletedWebInfo = @{PageName: self.webNameTextField.text, PageUrl: self.webUrlTextField.text};
        [self.todayWebs addObject:seletedWebInfo];
        [self saveWebInfoToUserDefaults];
        [self hiddeSeletedPanel];
        [self.tableView reloadData];
    } else {
        [[AllAlertView sharedAlert] showWithTitle:@"输入不正确" alertType:AllAlertViewAlertTypeRemind height:100.0];
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.seletedContainView endEditing:YES];
}
- (void)loadTodayWebsData{
    _todayWebs = [[self getWebInfoFromUserDefaults] mutableCopy];
    [self.tableView reloadData];
}

- (void)addTodayWeb:(UIBarButtonItem *)item {
    [self.seletedWindow makeKeyAndVisible];

    [self.seletedWindow addSubview:self.seletedContainView];
    [self.seletedContainView addSubview:self.segment];
    
    [self configSeletedTableView];

    [self.seletedContainView addSubview:self.seletedTableView];
    [self.seletedTableView addSubview:self.webNameTextField];
    [self.seletedTableView addSubview:self.webUrlTextField];
    [self.seletedTableView addSubview:self.alertLabel];
    
    self.webNameTextField.hidden = YES;
    self.webUrlTextField.hidden = YES;
    self.alertLabel.hidden = YES;
    
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
        [self seletedBookmarksAndHistories];
        NSArray *bookmarks = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"Bookmark"]];
        self.webItems = [NSMutableArray arrayWithArray:bookmarks];
        self.arraydataSource.items = [self.webItems copy];
        [self.seletedTableView reloadData];

    } else if (index == 1) {
        [self seletedBookmarksAndHistories];
        NSArray *histories = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"History"]];
        self.webItems = [NSMutableArray arrayWithArray:histories];
        self.arraydataSource.items = [self.webItems copy];
        [self.seletedTableView reloadData];
    } else {
        [self customInputWeb];
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
        [_segment removeFromSuperview];
        _segment = nil;
        _seletedWindow.hidden = YES;
        [_seletedWindow resignKeyWindow];
    }];
}

- (void)customInputWeb {
    self.webNameTextField.hidden = NO;
    self.webUrlTextField.hidden = NO;
    self.alertLabel.hidden = NO;
    self.webItems = nil;
    self.arraydataSource.items = nil;
    self.seletedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.seletedTableView.separatorColor = [UIColor clearColor];
    [self.seletedTableView reloadData];
    [self.webNameTextField becomeFirstResponder];
}

- (void)seletedBookmarksAndHistories {
    self.webNameTextField.hidden = YES;
    self.webUrlTextField.hidden = YES;
    self.alertLabel.hidden = YES;
    self.seletedTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.seletedTableView.separatorColor = [UIColor colorWithRed:0.9471 green:0.9471 blue:0.9471 alpha:1.0];

}

- (void)configSeletedTableView {
    
    NSArray *bookmarks = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"Bookmark"]];
    self.webItems = [NSMutableArray arrayWithArray:bookmarks];
    
    self.arraydataSource = [[ArrayDataSource alloc] initWithItems:self.webItems cellIdentifier:@"cellIdentifier" cellConfigureBlock:^(UITableViewCell *cell, NSManagedObject *data) {
        
        cell.textLabel.text = [data valueForKey:PageName];
        
    }];
    __weak typeof(self) weakSelf = self;
    [self.arraydataSource tableViewDidSelectRowAtIndexPathWithBlock:^(UITableView *tableView, NSIndexPath *indexPath, NSManagedObject *data) {
        NSDictionary *seletedWebInfo = @{PageName: [data valueForKey:PageName], PageUrl: [data valueForKey:PageUrl]};

        if ([self filterTodayWebs:seletedWebInfo]) {
            [[AllAlertView sharedAlert] showWithTitle:@"网页已经存在" alertType:AllAlertViewAlertTypeRemind height:100.0];
            return ;
        }
        if (weakSelf.todayWebs.count > 3) {
            [[AllAlertView sharedAlert] showWithTitle:@"网页不能超过4个" alertType:AllAlertViewAlertTypeRemind height:100.0];
            return ;
        }
        [weakSelf.todayWebs addObject:seletedWebInfo];
        [weakSelf.tableView reloadData];
        [weakSelf hiddeSeletedPanel];
        [weakSelf saveWebInfoToUserDefaults];
        
    }];
    //tableview drag
    [self.arraydataSource tableViewWillDragingWithBlock:^(UIScrollView *scrollView) {
        [self.webNameTextField resignFirstResponder];
        [self.webUrlTextField resignFirstResponder];
        self.webNameTextField.text = nil;
        self.webUrlTextField.text = @"http://";
    }];
    
    self.seletedTableView.dataSource = self.arraydataSource;
    self.seletedTableView.delegate = self.arraydataSource;
    
}

- (void)saveWebInfoToUserDefaults{
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.localNotificationSharedDefaults"];
    [shared setObject:self.todayWebs forKey:@"todayWeb"];
    [shared synchronize];
    
}

- (NSArray *)getWebInfoFromUserDefaults {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.localNotificationSharedDefaults"];
    NSArray *results = [NSArray arrayWithArray:[shared objectForKey:@"todayWeb"]];
    return results;
}

- (BOOL)filterTodayWebs:(NSDictionary *)webInfo {
    return [self.todayWebs containsObject:webInfo];
}




@end














