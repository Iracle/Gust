//
//  AboutGustViewController.m
//  Gust
//
//  Created by Iracle on 15/5/2.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "AboutGustViewController.h"
#import "GuideViewController.h"

@interface AboutGustViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *aboutGustTableView;
@property(nonatomic, strong) NSArray *aboutGustDataArray;

@end

@implementation AboutGustViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"关于";
        _aboutGustDataArray = @[@"功能介绍", @"去评分"];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _aboutGustTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _aboutGustTableView.delegate = self;
    _aboutGustTableView.dataSource = self;
    _aboutGustTableView.rowHeight = 65.0;
    _aboutGustTableView.tableFooterView = [UIView new];
    [self.view addSubview:_aboutGustTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _aboutGustDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = _aboutGustDataArray[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:18];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        [self presentViewController:guideVC animated:YES completion:nil];

        
    } else {
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 230.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor colorWithRed:0.533 green:0.982 blue:1.000 alpha:0.640];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 230)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"zapfino" size:38];
    label.textColor = [UIColor colorWithRed:0.354 green:0.141 blue:0.118 alpha:1.000];
    label.text = @"Gust";
    label.layer.shadowColor = [UIColor grayColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(6, 6);
    label.layer.opacity = 0.7;
    [headerView addSubview:label];
    return headerView;
}

@end
