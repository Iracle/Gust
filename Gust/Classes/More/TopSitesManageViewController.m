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
        self.title = @"首页书签管理";
    }
    return self;
}

- (UITableView *)topSitesManageTableView {
    if (!_topSitesManageTableView) {
        _topSitesManageTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _topSitesManageTableView.delegate = self;
        _topSitesManageTableView.dataSource = self;
        _topSitesManageTableView.rowHeight = 70.0;
        _topSitesManageTableView.tableFooterView = [UIView new];
        _topSitesManageTableView.editing = YES;
    }
    return _topSitesManageTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSManagedObject *obj = [_currentDataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj valueForKey:PageName];
    cell.detailTextLabel.text = [obj valueForKey:PageUrl];

    cell.textLabel.font = [UIFont systemFontOfSize:18];
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
    
    return @"删除";
}




@end
