//
//  ChooseLanguageViewController.m
//  Gust
//
//  Created by Iracle Zhang on 3/7/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "ChooseLanguageViewController.h"
#import "SettingsTableViewCell.h"
#import "Localisator.h"

@interface ChooseLanguageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray * arrayOfLanguages;
@property (nonatomic, strong) NSString *currentLanguage;
@end

@implementation ChooseLanguageViewController

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLanguageChanged object:nil];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = LOCALIZATION(@"LocalisatorViewTitle");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    //get all localized language
    self.arrayOfLanguages = [[[Localisator sharedInstance] availableLanguagesArray] copy];
     NSLog(@"all language:%@",self.arrayOfLanguages);
    
    [self.view addSubview:self.tableView];
    [self loadCurrentLanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    [[Localisator sharedInstance] setSaveInUserDefaults:YES];


    
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *localisatorViewControlleCellIdentifer = @"LocalisatorViewControlleCell";
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:localisatorViewControlleCellIdentifer];
    if (!cell) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:localisatorViewControlleCellIdentifer];
        cell.webTitle.transform = CGAffineTransformMakeTranslation(-30.0, 0.0);
    }
    
    [cell configCell:_dataArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    if ([self.currentLanguage isEqualToString:self.arrayOfLanguages[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self GotoSettingslaugageWithIndex: indexPath.row];
    
}

- (void)loadCurrentLanguage {
    _dataArray = @[LOCALIZATION(@"DeviceLanguage"),LOCALIZATION(@"English_en"), LOCALIZATION(@"zh-Hans")];
    self.title = LOCALIZATION(@"LocalisatorViewTitle");
    //get current lauguage
    self.currentLanguage = [[Localisator sharedInstance] currentLanguage];
    
     NSLog(@"current language:%@",self.currentLanguage);
    [_tableView reloadData];
}

- (void)receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self loadCurrentLanguage];
    }
}

-(void)GotoSettingslaugageWithIndex:(NSInteger)index
{
    if ([[Localisator sharedInstance] setLanguage:self.arrayOfLanguages[index]])
    {
        
    }else{
        NSLog(@"您选择的语言为当前语言!");
    }
}


@end
