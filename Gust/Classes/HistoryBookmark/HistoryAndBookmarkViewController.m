//
//  HistoryAndBookmarkViewController.m
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "HistoryAndBookmarkViewController.h"
#import "MGSwipeButton.h"
#import "HisAndBooModel.h"
#import "History.h"
#import "Bookmark.h"
#import "TopSites.h"
#import "CoreDataManager.h"
#import "GustRefreshHeader.h"
#import "GustWebViewController.h"
#import "GustConfigure.h"
#import "UINavigationBar+Addition.h"
#import "GustSwipeTableCell.h"
#import "AllAlertView.h"
#import "Localisator.h"

@interface HistoryAndBookmarkViewController () <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSArray *bookmarkArray;
@property (nonatomic, strong) NSArray *historyArray;
@property (nonatomic, strong) NSMutableArray *currentDataArray;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) GustRefreshHeader *refreshHeader;
@property (nonatomic, copy) NSString *selectedPageUrlString;
@property BOOL isBookmark;

@property (nonatomic, strong) UIBarButtonItem *clearHistoryButton;

@end


@implementation HistoryAndBookmarkViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 64.0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 - 45.0)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 54.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = YES;
        _tableView.separatorColor = [UIColor clearColor];
    }
    
    return _tableView;
}
- (UISegmentedControl *)segment
{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[LOCALIZATION(@"Bookmarks"), LOCALIZATION(@"History")]];
        _segment.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 70, 35);
        _segment.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - 22.5);
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
        _segment.tintColor = [UIColor colorWithRed:93 / 255.0 green:148 / 255.0 blue:140 / 255.0 alpha:1.0];
    }
    return _segment;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar hideBottomHairline];
    navigationBar.barTintColor = [UIColor whiteColor];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.3107 green:0.3107 blue:0.3107 alpha:1.0]}];
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];
    
    self.title = LOCALIZATION(@"Bookmarks");
    self.isBookmark = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segment];
    
    self.bookmarkArray = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"Bookmark"]];
    self.currentDataArray = [NSMutableArray arrayWithArray:self.bookmarkArray];
    
    _refreshHeader = [[GustRefreshHeader alloc] init];
    _refreshHeader.scrollView = self.tableView;
    [_refreshHeader addHeadView];
    _refreshHeader.pullBackOffset = 0.9;

    //clear history button
    _clearHistoryButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearHistoryButtonTaped:)];
    _clearHistoryButton.tintColor = [UIColor colorWithRed:0.2752 green:0.2752 blue:0.2752 alpha:1.0];
    
    __strong typeof (self) strongSelf = self;
    _refreshHeader.beginRefreshingBlock = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        });
    };
    
}


- (void)segmentAction:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    if (index == 0) {
        self.title = LOCALIZATION(@"Bookmarks");
        self.navigationItem.rightBarButtonItem = nil;
        self.isBookmark = YES;
        self.bookmarkArray = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"Bookmark"]];
        self.currentDataArray = [NSMutableArray arrayWithArray:self.bookmarkArray];
        [self.tableView reloadData];
    } else {
        self.title = LOCALIZATION(@"History");
        self.navigationItem.rightBarButtonItem = _clearHistoryButton;
        self.isBookmark = NO;
        self.historyArray = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"History"]];
        self.currentDataArray = [NSMutableArray arrayWithArray:self.historyArray];
        [self.tableView reloadData];
    }
    
}

#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SwipCell";
    GustSwipeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GustSwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (_isBookmark) {
        [cell isBookmarks:YES];
    } else {
        [cell isBookmarks:NO];
    }
    cell.delegate = self;
    NSManagedObject *obj = [self.currentDataArray objectAtIndex:indexPath.row];
    [cell configCell:[obj valueForKey:PageName]];
    MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"cellDelete"] backgroundColor:[UIColor colorWithRed:0.9621 green:0.4919 blue:0.4729 alpha:1.0]];
    deleteButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    MGSwipeButton *addButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"cellAdd"] backgroundColor:[UIColor colorWithRed:0.1171 green:0.8897 blue:0.5259 alpha:1.0]];
    addButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);


    cell.rightButtons = @[deleteButton, addButton];
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    cell.rightExpansion.buttonIndex = 0;
    cell.rightExpansion.fillOnTrigger = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self changeBackHomeTimeNotification];

    NSManagedObject *obj = [self.currentDataArray objectAtIndex:indexPath.row];
    _selectedPageUrlString = [obj valueForKey:PageUrl];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    if (_isFromHomePage) {
        self.getUrltoHomeValueBlock(_selectedPageUrlString);
    } else {
        self.getUrlValueBlock(_selectedPageUrlString);
        
    }
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    NSIndexPath * indexPath = [_tableView indexPathForCell:cell];
    NSManagedObject *obj = [self.currentDataArray objectAtIndex:indexPath.row];
    NSString *pageName  = [obj valueForKey:PageName];
    NSString *entityName;
    
      if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        [self.currentDataArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
          
          if (self.isBookmark) {
              entityName = [Bookmark entityName];
          } else {
              entityName = [History entityName];
          }
        [CoreDataManager removeObjectWithEntityName:entityName predicateString:[NSString stringWithFormat:@"pageName = '%@'",pageName] ];
    
        return NO;
    } else if (direction == MGSwipeDirectionRightToLeft && index == 1)
    {
        NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[TopSites entityName] predicateString:[NSString stringWithFormat:@"pageName = '%@'",pageName]];

        if (resultsArray.count < 1) {
            
            NSDictionary *saveDic = @{PageName:pageName, PageUrl: [obj valueForKey:PageUrl], ImageUrl:  [obj valueForKey:ImageUrl]};
            [CoreDataManager insertObjectWithParameter:saveDic entityName:[TopSites entityName]];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateTopSites object:self];
            [[AllAlertView sharedAlert] showWithTitle: LOCALIZATION(@"TopSiteSucess") alertType:AllAlertViewAlertTypeDone height:100.0];
            
        } else {
            
            [[AllAlertView sharedAlert] showWithTitle: LOCALIZATION(@"TopSiteExist") alertType:AllAlertViewAlertTypeRemind height:100.0];
        }
    }
    return YES;
}

#pragma mark -- Button Events
- (void)clearHistoryButtonTaped:(UIBarButtonItem *)sender {
    [self.currentDataArray removeAllObjects];
    [CoreDataManager removeObjectWithEntityName:[History entityName] predicateString:nil];
    [_tableView reloadData];
}

- (void)changeBackHomeTimeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationResetTransitionDuration object:nil];
}



@end
