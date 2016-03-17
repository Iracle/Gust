//
//  BaiduVoiceSettingViewController.m
//  Gust
//
//  Created by Iracle Zhang on 3/17/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "BaiduVoiceSettingViewController.h"
#import "GustConfigure.h"
#import "SettingsTableViewCell.h"
#import "Localisator.h"

@interface BaiduVoiceSettingViewController ()  <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BaiduVoiceSettingViewController

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = LOCALIZATION(@"VoiceSetting");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
    
    [self loadDataSource];
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
    
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)loadDataSource {
    _dataArray = @[LOCALIZATION(@"Speaktone"), LOCALIZATION(@"RecognitionLanguage")];
    [_tableView reloadData];
    
    
}

@end









