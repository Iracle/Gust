//
//  TopSitesManageViewController.m
//  Gust
//
//  Created by Iracle on 15/4/19.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "TopSitesManageViewController.h"
#import "TopSites.h"
#import "CoreDataManager.h"
#import "GustConfigure.h"
#import "SettingsTableViewCell.h"
#import "Localisator.h"

@interface TopSitesManageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UITableView *topSitesManageTableView;
@property (nonatomic, strong) NSMutableArray *currentDataArray;
@property (nonatomic, strong) NSMutableArray *topSitesSaveArray;

@end

@implementation TopSitesManageViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = LOCALIZATION(@"TopSites");
    }
    return self;
}

- (UITableView *)topSitesManageTableView {
    if (!_topSitesManageTableView) {
        _topSitesManageTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _topSitesManageTableView.backgroundColor = [UIColor clearColor];
        _topSitesManageTableView.delegate = self;
        _topSitesManageTableView.dataSource = self;
        _topSitesManageTableView.rowHeight = 54.0;
        _topSitesManageTableView.tableFooterView = [UIView new];
        _topSitesManageTableView.editing = YES;
        _topSitesManageTableView.allowsSelectionDuringEditing = YES;
        _topSitesManageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topSitesManageTableView.showsVerticalScrollIndicator = NO;
        _topSitesManageTableView.separatorColor = [UIColor clearColor];
    }
    return _topSitesManageTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    
    [self.view addSubview:self.topSitesManageTableView];
    [self setupTopSitesManageTableViewData];
    [self.view setNeedsUpdateConstraints];
}

- (void)setupTopSitesManageTableViewData {
    //sort so use TopSits UserDefaults
    _currentDataArray = [NSMutableArray array];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _topSitesSaveArray= [NSMutableArray arrayWithArray:[userDefaults valueForKey:TopSits]];

    for (int i = 0; i < _topSitesSaveArray.count; i ++) {
        
        NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[TopSites entityName] predicateString:[NSString stringWithFormat:@"pageName = '%@'",_topSitesSaveArray[i]]];
        if (resultsArray.count > 0) {
            
            NSManagedObject *obj = [resultsArray objectAtIndex:0];
            [_currentDataArray addObject:obj];

        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"topSitesManageCell";
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSManagedObject *obj = [_currentDataArray objectAtIndex:indexPath.row];
    [cell configCell:[obj valueForKey:PageName]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *obj = [_currentDataArray objectAtIndex:indexPath.row];
        [_currentDataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [CoreDataManager removeObjectWithEntityName:[TopSites entityName] predicateString:[NSString stringWithFormat:@"pageName = '%@'",[obj valueForKey:PageName]]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray * topSitesSaveArray= [NSMutableArray arrayWithArray:[userDefaults valueForKey:TopSits]];
        [topSitesSaveArray removeObjectAtIndex:indexPath.row];
        [userDefaults setObject:topSitesSaveArray forKey:TopSits];
        [userDefaults synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateTopSites object:self];
        

    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    //NSUserDefaults
     NSString *willMoveString = [_topSitesSaveArray objectAtIndex:sourceIndexPath.row];
    [_topSitesSaveArray removeObject:willMoveString];
    [_topSitesSaveArray insertObject:willMoveString atIndex:destinationIndexPath.row];
    
    //CoreData
    NSString *currentWillMoveSting = [_currentDataArray objectAtIndex:sourceIndexPath.row];
    [_currentDataArray removeObject:currentWillMoveSting];
    [_currentDataArray insertObject:currentWillMoveSting atIndex:destinationIndexPath.row];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_topSitesSaveArray forKey:TopSits];
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateTopSites object:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)
indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LOCALIZATION(@"TopSiteDelete");
}





@end
