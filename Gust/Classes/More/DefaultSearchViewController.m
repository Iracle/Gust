//
//  DefaultSearchViewController.m
//  Gust
//
//  Created by Iracle on 15/4/23.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "DefaultSearchViewController.h"
#import "GustConfigure.h"
#import "SettingsTableViewCell.h"
#import "Localisator.h"

@interface DefaultSearchViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *defautSearchEnginSting;

@end

@implementation DefaultSearchViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 54.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor clearColor];
    }
    
    return _tableView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = LOCALIZATION(@"SearchEngine");
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];

    [self.view addSubview:self.tableView];
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
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.webTitle.transform = CGAffineTransformMakeTranslation(-30.0, 0.0);
    }
    [cell configCell:_dataArray[indexPath.row]];
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
    SettingsTableViewCell *cell = (SettingsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView *view in cell.superview.subviews) {
        SettingsTableViewCell *currentCell = (SettingsTableViewCell *)view;
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
    _dataArray = @[LOCALIZATION(@"SearchEngineBaidu"), LOCALIZATION(@"SearchEngineGoogle")];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _defautSearchEnginSting =[[defaults objectForKey:DefautSearchEngin] copy];
    [_tableView reloadData];
    
}

@end
