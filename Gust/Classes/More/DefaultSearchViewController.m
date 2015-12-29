//
//  DefaultSearchViewController.m
//  Gust
//
//  Created by Iracle on 15/4/23.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "DefaultSearchViewController.h"
#import "GustConfigure.h"

@interface DefaultSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *defautSearchEnginSting;

@end

@implementation DefaultSearchViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"搜索引擎选择";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 65.0;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [self getMainTouchViewLocationData];
    
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MainTouchViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    if ([_defautSearchEnginSting isEqualToString:SearchEnginBaidu]) {
        if (indexPath.row == 0) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:18];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView *view in cell.superview.subviews) {
        UITableViewCell *currentCell = (UITableViewCell *)view;
        currentCell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (indexPath.row == 0) {
        [defaults setObject:SearchEnginBaidu forKey:DefautSearchEngin];
        
    } else {
        [defaults setObject:SearchEnginGoogle forKey:DefautSearchEngin];
        
    }
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter ] postNotificationName:NotificationChangeDefautSearchEngin object:self];
    
}

- (void)getMainTouchViewLocationData
{
    _dataArray = @[@"百度", @"谷歌"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _defautSearchEnginSting =[[defaults objectForKey:DefautSearchEngin] copy];
    [_tableView reloadData];
    
}

@end
