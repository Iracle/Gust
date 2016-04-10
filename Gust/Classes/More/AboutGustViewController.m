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
#import "GustConfigure.h"
#import "GustActivity.h"

@interface AboutGustViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *aboutGustTableView;
@property (nonatomic, strong) NSArray<NSString *> *aboutGustDataArray;
@property (nonatomic, nonnull, strong) UILabel *disPalyLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NSMutableAttributedString *labelDisplayString;
@end

@implementation AboutGustViewController

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.bounds = CGRectMake(0, 0, 80.0, 80.0);
        _iconImageView.center = CGPointMake(SCREEN_MID_X, 80.0);
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 12.0;
        _iconImageView.image = [UIImage imageNamed:@"AboutAppIcon"];
    }
    return _iconImageView;
}

- (UILabel *)disPalyLabel {
    if (!_disPalyLabel) {
        
        _disPalyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame) + 18.0, CGRectGetWidth(self.view.bounds), 25.0)];
        _disPalyLabel.textAlignment = NSTextAlignmentCenter;
        _disPalyLabel.font = [UIFont systemFontOfSize:21];
        _disPalyLabel.textColor = [UIColor colorWithRed:0.354 green:0.141 blue:0.118 alpha:1.000];
        _disPalyLabel.layer.shadowColor = [UIColor grayColor].CGColor;
        _disPalyLabel.layer.shadowOffset = CGSizeMake(6, 6);
        _disPalyLabel.layer.opacity = 0.7;
        _disPalyLabel.attributedText = self.labelDisplayString;
    }
    return _disPalyLabel;
}
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
        _aboutGustTableView.contentInset = UIEdgeInsetsMake(2.0, 0, 0, 0);
    }
    
    return _aboutGustTableView;
}

- (NSMutableAttributedString *)labelDisplayString {
    if (!_labelDisplayString) {
        
        _labelDisplayString = [[NSMutableAttributedString alloc] initWithString:@"Gust Browser"];
        
        [_labelDisplayString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0767 green:0.0767 blue:0.0767 alpha:1.0] range:NSMakeRange(0,4)];
        [_labelDisplayString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Medium" size:21] range:NSMakeRange(0, 4)];
        

        [_labelDisplayString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.2153 green:0.2153 blue:0.2153 alpha:1.0] range:NSMakeRange(4,8)];
        [_labelDisplayString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:21] range:NSMakeRange(4, 8)];
        
        
    }
    return _labelDisplayString;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = LOCALIZATION(@"AboutApp");
        _aboutGustDataArray = @[LOCALIZATION(@"RatingApp"), LOCALIZATION(@"ShareToFriend")];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.iconImageView.alpha = 0.0;
    self.disPalyLabel.alpha = 0.0;
    
    self.iconImageView.transform = CGAffineTransformMakeTranslation(0, 20);
    self.disPalyLabel.transform = CGAffineTransformMakeTranslation(0, 20);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.45 animations:^{
        
        self.iconImageView.alpha = 1.0;
        self.iconImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [UIView animateWithDuration:0.45 animations:^{
            
            self.disPalyLabel.alpha = 1.0;
            self.disPalyLabel.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    });
    
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
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1097706441&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
        
    } else {
        
        NSString *textToShare = LOCALIZATION(@"ShareTextAPP");
        UIImage *imageToShare = [UIImage imageNamed:@"launchexplore"];
        NSURL *urlToShare = [NSURL URLWithString:@"http://iracleme.com/works/"];
        
        NSArray *activityItems = @[textToShare,imageToShare, urlToShare];
        
        GustActivity *actWeichat = [[GustActivity alloc]initWithImage:[UIImage imageNamed:@"wechat_session"] atURL: @"" atTitle:@"WeChat" atShareContentArray:activityItems];
        
        GustActivity *actWeiCircle = [[GustActivity alloc]initWithImage:[UIImage imageNamed:@"wechat_timeline"] atURL:@"" atTitle:@"Moments" atShareContentArray:activityItems];
        
        NSArray *shareApps = @[actWeichat, actWeiCircle];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:shareApps];
        activityVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {

        };
        
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
        [self presentViewController:activityVC animated:YES completion:nil];

        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 210.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.iconImageView];
    [headerView addSubview:self.disPalyLabel];
    return headerView;
}

@end







