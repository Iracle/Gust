//
//  AboutGustViewController.m
//  Gust
//
//  Created by Iracle on 15/5/2.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "AboutGustViewController.h"
#import "GuideViewController.h"
#import "SettingsTableViewCell.h"
#import "Localisator.h"

@interface AboutGustViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *aboutGustTableView;
@property (nonatomic, strong) NSArray *aboutGustDataArray;
@end

@implementation AboutGustViewController

- (UITableView *)aboutGustTableView
{
    if (!_aboutGustTableView) {
        _aboutGustTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _aboutGustTableView.backgroundColor = [UIColor clearColor];
        _aboutGustTableView.rowHeight = 54.0;
        _aboutGustTableView.delegate = self;
        _aboutGustTableView.dataSource = self;
        _aboutGustTableView.tableFooterView = [UIView new];
        _aboutGustTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _aboutGustTableView.showsVerticalScrollIndicator = NO;
        _aboutGustTableView.separatorColor = [UIColor clearColor];
    }
    
    return _aboutGustTableView;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = LOCALIZATION(@"AboutApp");
        _aboutGustDataArray = @[LOCALIZATION(@"RatingApp")];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    [self.view addSubview:self.aboutGustTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _aboutGustDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTableViewCell *cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.webTitle.transform = CGAffineTransformMakeTranslation(-30.0, 0.0);
    cell.webTitle.text = _aboutGustDataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=247423477&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
        
    } else {
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 230.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithRed:0.533 green:0.982 blue:1.000 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 230)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:28];
    label.textColor = [UIColor colorWithRed:0.354 green:0.141 blue:0.118 alpha:1.000];
    label.text = @"Gust";
    label.layer.shadowColor = [UIColor grayColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(6, 6);
    label.layer.opacity = 0.7;
    [headerView addSubview:label];
    return headerView;
}

@end
