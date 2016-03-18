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
#import "BDVRSConfig.h"

static const CGFloat bgPanHeight = 260.0;

@interface BaiduVoiceSettingViewController ()  <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *dataArray;

@property (nonatomic, strong) UISwitch *speakToneSwitch;
@property (nonatomic, strong) UIView *bgPan;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *hiddenPickerPanButton;
@property (nonatomic, copy) NSArray<NSString *> *pickerDataSource;
@property (nonatomic, strong) UILabel *showLanguageLabel;

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

- (UISwitch *)speakToneSwitch {
    if (!_speakToneSwitch) {
        _speakToneSwitch = [[UISwitch alloc] init];
        [_speakToneSwitch addTarget:self action:@selector(speakToneSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _speakToneSwitch;
}

- (UIView *)bgPan {
    if (!_bgPan) {
        _bgPan = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bgPanHeight, SCREEN_WIDTH, bgPanHeight)];
    }
    return _bgPan;
}

- (UIButton *)hiddenPickerPanButton {
    if (!_hiddenPickerPanButton) {
        _hiddenPickerPanButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _hiddenPickerPanButton.frame = CGRectMake(CGRectGetMaxX(self.view.bounds) - 50.0 - 15.0, 7.0, 50.0, 30.0);
        [_hiddenPickerPanButton setTitle:LOCALIZATION(@"StringConform") forState:UIControlStateNormal];
        [_hiddenPickerPanButton addTarget:self action:@selector(hiddenBgPan:) forControlEvents:UIControlEventTouchUpInside];
        [_hiddenPickerPanButton setTintColor:[UIColor whiteColor]];
        _hiddenPickerPanButton.titleLabel.font = [UIFont systemFontOfSize:17];

    }
    return _hiddenPickerPanButton;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43.0, SCREEN_WIDTH, bgPanHeight - 43.0)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
    }
    return _pickerView;
}

- (UILabel *)showLanguageLabel {
    if (!_showLanguageLabel) {
        _showLanguageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 130 - 15, 2, 130, 52)];
        _showLanguageLabel.textAlignment = NSTextAlignmentRight;
        _showLanguageLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _showLanguageLabel.textColor = [UIColor colorWithRed:0.1757 green:0.1757 blue:0.1757 alpha:1.0];
    }
    return _showLanguageLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = LOCALIZATION(@"VoiceSetting");
        [self loadPickerViewDataSource];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    
    [self.view addSubview:self.tableView];

    
    [self loadDataSource];
    
     NSLog(@"当前语言：%d",[BDVRSConfig sharedInstance].recognitionLanguage);
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
        if (indexPath.row == 1) {
            [cell addSubview:self.showLanguageLabel];
        }
    }
    if (indexPath.row == 0) {
        cell.accessoryView = self.speakToneSwitch;
        self.speakToneSwitch.on = [BDVRSConfig sharedInstance].playStartMusicSwitch;
    } else {
        self.showLanguageLabel.text =  [_pickerDataSource objectAtIndex:[BDVRSConfig sharedInstance].recognitionLanguage];
    }
    [cell configCell:_dataArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self showLanguageSlectedPan];
    }
    
}

- (void)loadDataSource {
    _dataArray = @[LOCALIZATION(@"Speaktone"), LOCALIZATION(@"RecognitionLanguage")];
    [_tableView reloadData];
}

- (void)showLanguageSlectedPan {
    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 43)];
    topBar.backgroundColor = [UIColor colorWithRed:0.3485 green:0.3485 blue:0.3485 alpha:1.0];
    [self.view addSubview:self.bgPan];
    [self.bgPan addSubview:topBar];
    [self.bgPan addSubview:self.pickerView];
    [self.bgPan addSubview:self.hiddenPickerPanButton];
    self.bgPan.transform = CGAffineTransformMakeTranslation(0.0, bgPanHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgPan.transform = CGAffineTransformIdentity;
    }];
}

- (void)speakToneSwitchAction:(UISwitch *)sender {
    
    [BDVRSConfig sharedInstance].playStartMusicSwitch = sender.on;
    [BDVRSConfig sharedInstance].playEndMusicSwitch = sender.on;
    
}

- (void)hiddenBgPan:(UIButton *)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.bgPan.transform = CGAffineTransformMakeTranslation(0.0, bgPanHeight);
 
    }];
}

- (void)loadPickerViewDataSource {
    _pickerDataSource = @[LOCALIZATION(@"Putonghua"), LOCALIZATION(@"Yueyu"), LOCALIZATION(@"English_en"), LOCALIZATION(@"SichuanHua")];
}

#pragma mark-- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerDataSource[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 43.0;
}

- ( NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component  {
    return [[NSAttributedString alloc] initWithString:_pickerDataSource[row] attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:150 /255.0 green:150 /255.0 blue:150 /255.0 alpha:1.0], NSFontAttributeName: [UIFont systemFontOfSize:15.0 weight:UIFontWeightThin]}];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.showLanguageLabel.text = _pickerDataSource[row];
    [BDVRSConfig sharedInstance].recognitionLanguage = (int)row;
}
@end









