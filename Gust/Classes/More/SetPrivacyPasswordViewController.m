//
//  SetPrivacyPasswordViewController.m
//  Gust
//
//  Created by Iracle Zhang on 15/11/5.
//  Copyright © 2015年 Iralce. All rights reserved.
//

#import "SetPrivacyPasswordViewController.h"
#import "CHKeychain.h"
#import "GustConfigure.h"
#import "BKCustomPasscodeViewController.h"
#import "SettingsTableViewCell.h"

#define TEXTFIELD_INDEX 0

@interface SetPrivacyPasswordViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation SetPrivacyPasswordViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    
    [self.view addSubview:self.tableView];


}



@end











