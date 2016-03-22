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
#import "SettingsTableViewCell.h"
#import "BKPasscodeViewController.h"
#import "GustBKPasscodeDelegate.h"
#import "Localisator.h"

#define TEXTFIELD_INDEX 0

@interface SetPrivacyPasswordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *openPasscodeSwitch;
@property (nonatomic, strong) GustBKPasscodeDelegate *gustBKPasscodeDelegate;


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

- (UISwitch *)openPasscodeSwitch {
    if (!_openPasscodeSwitch) {
        _openPasscodeSwitch = [[UISwitch alloc] init];
        [_openPasscodeSwitch addTarget:self action:@selector(openPasscodeSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _openPasscodeSwitch;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = LOCALIZATION(@"PasscodeLock");
        self.gustBKPasscodeDelegate = [[GustBKPasscodeDelegate alloc] init];

        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    
    [self.view addSubview:self.tableView];
    
    NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
    BOOL privicyBool = [privacyDefaults boolForKey:IsGustPrivacy];
    self.openPasscodeSwitch.on = privicyBool;

}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"SetPrivacyPasswordViewController";
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         cell.webTitle.transform = CGAffineTransformMakeTranslation(-30.0, 0.0);
    }
    if (indexPath.row == 0) {
        cell.webTitle.text = LOCALIZATION(@"TouchIDPasscode");
        cell.accessoryView = self.openPasscodeSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.webTitle.text = LOCALIZATION(@"ChangePassCode");
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        [self presentPasscodeViewControllerWithType:BKPasscodeViewControllerNewPasscodeType isPush:YES];
    }
    
}

#pragma mark -- Passcode
- (void)presentPasscodeViewControllerWithType:(BKPasscodeViewControllerType)type isPush:(BOOL)isPush
{
    BKPasscodeViewController *viewController = [self createPasscodeViewController];
    viewController.delegate = self.gustBKPasscodeDelegate;
    viewController.type = type;
    
    // Passcode style (numeric or ASCII)
    viewController.passcodeStyle = BKPasscodeInputViewNumericPasscodeStyle;
    
    // Setup Touch ID manager
    BKTouchIDManager *touchIDManager = [[BKTouchIDManager alloc] initWithKeychainServiceName:@"BKPasscodeSampleService"];
    touchIDManager.promptText = @"Gust Touch ID ";
    viewController.touchIDManager = touchIDManager;
    
    if (isPush) {
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
}

- (BKPasscodeViewController *)createPasscodeViewController
{
    return [[BKPasscodeViewController alloc] init];
    
}

- (void)openPasscodeSwitchAction:(UISwitch *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:sender.on forKey:IsGustPrivacy];
    [userDefaults synchronize];
    
    if (sender.on) {
        [self presentPasscodeViewControllerWithType:BKPasscodeViewControllerNewPasscodeType isPush:NO];
    }
    
}



@end











