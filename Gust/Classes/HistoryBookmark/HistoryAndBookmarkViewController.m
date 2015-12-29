//
//  HistoryAndBookmarkViewController.m
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "HistoryAndBookmarkViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "PureLayout.h"
#import "HisAndBooModel.h"
#import "History.h"
#import "Bookmark.h"
#import "TopSites.h"
#import "CoreDataManager.h"
#import "GustRefreshHeader.h"
#import "GustAlertView.h"
#import "GustWebViewController.h"
#import "GustConfigure.h"

@interface HistoryAndBookmarkViewController () <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UITableView *tableView;
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
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [UITableView newAutoLayoutView];
        _tableView.rowHeight = 70.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}
- (UISegmentedControl *)segment
{
    if (!_segment) {
        _segment = [UISegmentedControl newAutoLayoutView];
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"书签", @"历史"]];
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
        _segment.tintColor = [UIColor colorWithRed:0.827 green:0.986 blue:1.000 alpha:1.000];
    }
    return _segment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"书签";
    self.isBookmark = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segment];
    [self.view setNeedsUpdateConstraints];
    
    self.bookmarkArray = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"Bookmark"]];
    self.currentDataArray = [NSMutableArray arrayWithArray:self.bookmarkArray];
    
    _refreshHeader = [[GustRefreshHeader alloc] init];
    _refreshHeader.scrollView = self.tableView;
    [_refreshHeader addHeadView];
    
    //clear history button
    _clearHistoryButton = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearHistoryButtonTaped:)];
    _clearHistoryButton.tintColor = [UIColor blackColor];
    
    __strong typeof (self) strongSelf = self;
    _refreshHeader.beginRefreshingBlock = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        });
    };
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:45.0];
        
        [self.segment autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:35.0];
        [self.segment autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:35.0];
        [self.segment autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
        [self.segment autoSetDimension:ALDimensionHeight toSize:35.0];

        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}


- (void)segmentAction:(UISegmentedControl *)segment
{
    NSInteger index = segment.selectedSegmentIndex;
    if (index == 0) {
        self.title = @"书签";
        self.navigationItem.rightBarButtonItem = nil;
        self.isBookmark = YES;
        self.bookmarkArray = [NSArray arrayWithArray:[HisAndBooModel getDataWithType:@"Bookmark"]];
        self.currentDataArray = [NSMutableArray arrayWithArray:self.bookmarkArray];
        [self.tableView reloadData];
    } else {
        self.title = @"历史";
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
    MGSwipeTableCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.delegate = self;
    NSManagedObject *obj = [self.currentDataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj valueForKey:PageName];
    cell.detailTextLabel.text = [obj valueForKey:PageUrl];
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor redColor]],[MGSwipeButton buttonWithTitle:@"添加" backgroundColor:[UIColor lightGrayColor]]];
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    cell.rightExpansion.buttonIndex = 0;
    cell.rightExpansion.fillOnTrigger = YES;
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.732 alpha:1.000];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
            
        } else {
            
            GustAlertView *alertView = [[GustAlertView alloc] init];
            [alertView showInView:self.view type:1 title:@"主页书签已经存在!"];
            
        }
    }
    return YES;
}

#pragma mark -- Button Events
- (void)clearHistoryButtonTaped:(UIBarButtonItem *)sender {
    
    [CoreDataManager removeObjectWithEntityName:[History entityName] predicateString:nil];
    [_tableView reloadData];
}


























@end
