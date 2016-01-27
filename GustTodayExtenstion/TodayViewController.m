//
//  TodayViewController.m
//  GustTodayExtenstion
//
//  Created by Iracle Zhang on 1/21/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "GustConfigure.h"
#import "UIButton+additions.h"

#define WEBITEM_BASETAG 2000

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, copy) NSArray *todayWebs;
@end

@implementation TodayViewController {
    UIStackView *stackView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(0, 145);
     NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.localNotificationSharedDefaults"];
    self.todayWebs = [shared valueForKey:@"todayWeb"];
    
    NSLog(@"%@",self.todayWebs);
    stackView = [[UIStackView alloc] initWithFrame:CGRectMake(15, 35, CGRectGetMaxX(self.view.frame) - 30, 75)];
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.spacing = 10;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    [self.view addSubview:stackView];
    
    if (self.todayWebs.count == 0) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
        addButton.layer.borderColor = [UIColor colorWithRed:0.7549 green:0.7549 blue:0.7549 alpha:1.0].CGColor;
        addButton.layer.borderWidth = 1.5;
        [addButton setTintColor:[UIColor whiteColor]];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightThin];
        [addButton addTarget:self action:@selector(addButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [stackView addArrangedSubview:addButton];
        return;
    }
    
    for (NSInteger index = 0; index < self.todayWebs.count; index ++) {
        UIButton *webItem = [UIButton buttonWithType:UIButtonTypeSystem];
        webItem.tag = WEBITEM_BASETAG + index;
        webItem.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
        webItem.layer.borderColor = [UIColor colorWithRed:0.7549 green:0.7549 blue:0.7549 alpha:1.0].CGColor;
        webItem.layer.borderWidth = 1.5;
        [webItem setTintColor:[UIColor whiteColor]];
        webItem.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightThin];
        [webItem addTarget:self action:@selector(webItemButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        NSString *titleString =[self.todayWebs[index][PageName] substringToIndex:4];
        [ webItem setTitle:titleString forState:UIControlStateNormal];
        webItem.str = self.todayWebs[index][PageUrl];
        [stackView addArrangedSubview:webItem];
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}

- (void)webItemButtonTaped:(UIButton *) sender{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.localNotificationSharedDefaults"];
    [shared setObject:sender.str forKey:@"openUrl"];
    [shared synchronize];
    [self.extensionContext openURL:[NSURL URLWithString:@"LocalNotification://finished"] completionHandler:^(BOOL success) {
        
    }];

    
}

- (void)addButtonTaped:(UIButton *)sender {
    
}

@end





















