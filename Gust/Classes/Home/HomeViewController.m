//
//  HomeViewController.m
//  Gust
//
//  Created by Iracle on 15/3/3.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "HomeViewController.h"
#import "GustConfigure.h"
#import "MainTouchBaseView.h"
#import "VLDContextSheet.h"
#import "VLDContextSheetItem.h"
#import "MainSearchBar.h"
#import "MoreViewController.h"
#import "HistoryAndBookmarkViewController.h"
#import "ZFModalTransitionAnimator.h"
#import "GustWebViewController.h"
#import "HomeCollectionViewCell.h"

#import "InputRecord.h"
#import "TopSites.h"
#import "CoreDataManager.h"
#import "MainSearchBarTextManage.h"
#import "CustomNavigationController.h"

#import <objc/message.h>

#import "GustRefreshHeader.h"
#import "GustCollectionView.h"
#import "HorizontalCollectionViewLayout.h"
#import "GustAssistScrollView.h"
#import <POP/POP.h>
#import "GustNavigationControllerDelegate.h"

#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "AllAlertView.h"
#import "TodayExtentionWebSeletedViewController.h"
#import "UIViewController+Visible.h"

@interface HomeViewController () <MainTouchViewDelegate, VLDContextSheetDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UIViewControllerPreviewingDelegate, QRCodeReaderDelegate>

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) MainTouchBaseView *touchView;
@property (nonatomic, strong) MainSearchBar *searchBar;
@property (strong, nonatomic) VLDContextSheet *contextSheet;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (strong, nonatomic) GustCollectionView *homeCollectionView;
@property (nonatomic, strong) NSMutableArray *savedArray;
@property (nonatomic, strong) NSMutableArray *topSitesSortArray;

@property (nonatomic, assign) BOOL isInputingState;
@property (nonatomic, assign) BOOL didSetupMainTouchViewConstraints;

@property (nonatomic, strong) UITableView *inputHistorisTableView;
//save input record array
@property (nonatomic, strong) NSMutableArray *inputRecordArray;
//save search record result array
@property (nonatomic, strong) NSMutableArray *inputRecordSearchResultArray;
@property (nonatomic, strong) NSString *currentSearchEnginString;
@property (nonatomic, strong) NSMutableString *willSearchString;
@property (nonatomic, strong) GustWebViewController *threeDTouchVC;
@property (nonatomic, copy) NSString *urlString;

//pull back
@property (nonatomic, strong) GustRefreshHeader *refreshHeader;

//assist scrollView
@property (nonatomic, strong) GustAssistScrollView *assistScrollView;

@property (nonatomic) BOOL isFirstEnter;

@property (nonatomic, strong) GustNavigationControllerDelegate *gustNavDelegate;
//save 3D Touch webname
@property (nonatomic) NSInteger touchPageNumber;

/**
 *  make sure open the today extention web from homepage never have a viewcontroller was show
 */
@property (nonatomic, strong) UINavigationController *currentHistoryAndBookmarkVC;
@property (nonatomic, strong) UINavigationController *currentMoreVC;
@property (nonatomic, strong) GustWebViewController *currentGustWebVC;
@property (nonatomic, strong) QRCodeReaderViewController *currentQRReader;
@property (nonatomic, strong) UINavigationController *currentDayExtentionVC;
@property (nonatomic, strong) TodayExtentionWebSeletedViewController *todayExtention;

@end

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- getter

- (UINavigationController *)currentDayExtentionVC {
    if (!_currentDayExtentionVC) {
        _currentDayExtentionVC = [[UINavigationController alloc] initWithRootViewController:self.todayExtention];
    }
    return _currentDayExtentionVC;
}
- (TodayExtentionWebSeletedViewController *)todayExtention {
    if (!_todayExtention) {
        _todayExtention = [[TodayExtentionWebSeletedViewController alloc] init];
    }
    return _todayExtention;
}
- (MainTouchBaseView *)touchView
{
    if (!_touchView) {
        _touchView = [[MainTouchBaseView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - MainTouchViewRadius / 2, CGRectGetMaxY(self.view.bounds) - MainTouchViewRadius * 1.5, MainTouchViewRadius, MainTouchViewRadius)];
        _touchView.mainTouchView.delegate = self;
    }
    return _touchView;
}

- (MainSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[MainSearchBar alloc] init];
        _searchBar.bounds = CGRectMake(0, 0, SCREEN_WIDTH - COLLECTION_CONTENT_OFFSET * 2, SearchBarHeight);
        _searchBar.center = CGPointMake(CGRectGetMidX(self.view.bounds), 102.5);
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)inputHistorisTableView {
    if (!_inputHistorisTableView) {
        _inputHistorisTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 70)];
        _inputHistorisTableView.delegate = self;
        _inputHistorisTableView.dataSource = self;
        _inputHistorisTableView.alpha = 0.0;
        _inputHistorisTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _inputHistorisTableView.separatorColor = [UIColor clearColor];
        
        self.refreshHeader = [[GustRefreshHeader alloc] init];
        self.refreshHeader.scrollView = _inputHistorisTableView;
        [self.refreshHeader addHeadView];
        self.refreshHeader.pullBackOffset = 0.8;
        __weak typeof(self) weakSelf = self;
        self.refreshHeader.beginRefreshingBlock = ^(){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hiddeInputHistorisTableView];
                [weakSelf setupSearchBarAnimation:NO];
                weakSelf.searchBar.text = nil;
            });
        };
    }
    return _inputHistorisTableView;
}
- (GustRefreshHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [[GustRefreshHeader alloc] init];
    }
    return _refreshHeader;
}

- (GustCollectionView *)homeCollectionView {
    if (!_homeCollectionView) {
        HorizontalCollectionViewLayout *layout = [[HorizontalCollectionViewLayout alloc] init];
        layout.itemSize = CGSizeMake(COLLECTION_CELL_WIDTH,COLLECTION_CELL_HIGHT);
        
        _homeCollectionView = [[GustCollectionView alloc] initWithFrame:CGRectMake(0, 170, self.view.bounds.size.width, COLLECTION_CELL_HIGHT * 3 - 1) collectionViewLayout:layout];
        _homeCollectionView .backgroundColor = [UIColor clearColor];
        _homeCollectionView.pagingEnabled = YES;
        _homeCollectionView.showsHorizontalScrollIndicator = NO;
        [_homeCollectionView  registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HOMECELL"];
        _homeCollectionView .delegate = self;
        _homeCollectionView.dataSource = self;
        _homeCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _homeCollectionView;
}

- (GustAssistScrollView *)assistScrollView {
    if (!_assistScrollView) {
        _assistScrollView = [[GustAssistScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_homeCollectionView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_homeCollectionView.frame))];
        _assistScrollView.backgroundColor = [UIColor clearColor];
        _assistScrollView.pagingEnabled = YES;
        _assistScrollView.showsHorizontalScrollIndicator = NO;
        _assistScrollView.delegate = self;
    }
    return _assistScrollView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self check3DTouch];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // [self performSelector:@selector(checkoutNetWorkState) withObject:self afterDelay:2];
    [self touchViewAnimtion];
    if (!_isFirstEnter) {
        [self performSelector:@selector(searchBarAnimation) withObject:nil afterDelay:0.24];
        //get Visible collection cell
        NSMutableArray *cellArray = [NSMutableArray array];
        NSArray *indexPaths = [self.homeCollectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in indexPaths) {
            HomeCollectionViewCell *cell = (HomeCollectionViewCell*)[self.homeCollectionView cellForItemAtIndexPath:indexPath];
            cell.cellContentView.backgroundColor = [UIColor colorWithRed:0.9618 green:0.9618 blue:0.9618 alpha:0.2];
            cell.cellContentView.alpha = 0.0;
            [cellArray addObject:cell];
        }

        [self performSelector:@selector(cellContentViewAnimation:) withObject:cellArray afterDelay:0.5];
    }
}

- (void)addContextSheet:(UIGestureRecognizer *)sender {
    [self.contextSheet startWithGestureRecognizer: sender
                                               inView: self.view];
    self.touchView.hidden = YES;
    
}
- (void)removeContextSheet {
    self.touchView.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HOME_COLOR;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.gustNavDelegate = [[GustNavigationControllerDelegate alloc] init];
    self.navigationController.delegate = self.gustNavDelegate;
    [self getCurrentSearchEnginSave];
    
    if (!_isFirstEnter) {
        self.searchBar.hidden = YES;
    }
    [self.view addSubview:self.homeCollectionView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.assistScrollView];
    [self.view addSubview:self.touchView];
    
    self.contextSheet = [[VLDContextSheet alloc] initWithItem:@"书签/历史" item:@"二维码" item:@"设置"];
    self.contextSheet.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTopSitesDate:) name:NotificationUpdateTopSites object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchBarTextChanged:) name:@"UITextFieldTextDidChangeNotification" object:_searchBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataMainTouchViewLocation:) name:NotificationUpdateMainTouchViewLocation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseDefautSeachEngin:) name:NotificationChangeDefautSearchEngin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetnResetTransitionDuration:) name:NotificationResetTransitionDuration object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threeDTouchDeleteTopsite:) name:NotificationDeleteTopsit object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remindTheWebsite:) name:NotificationReminderMe object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openTodayWebsite:) name:NotificationOpenTodayUrl object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewTodayWebsite:) name:NotificationAddNewWeb object:nil];

    //applicationWillResignActive
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self setupTopSitsData];

}

- (void)setupTopSitsData
{
    _topSitesSortArray = [NSMutableArray array];
    NSString *tempPageName = [NSString new];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _savedArray = [NSMutableArray arrayWithArray:[userDefaults valueForKey:TopSits]];
    NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[TopSites entityName] predicateString:nil];
    if (_savedArray.count != 0 && (resultsArray.count > _savedArray.count)) {
        for (int i = 0; i < resultsArray.count; i ++) {
            NSManagedObject *obj = [resultsArray objectAtIndex:i];
            NSString *pageName  = [obj valueForKey:PageName];
            for (NSString *currentPageName in _savedArray) {
                if ([currentPageName isEqualToString:pageName]) {
                    
                    tempPageName = nil;
                    break;
                } else {
                    
                    tempPageName = pageName;
                }
            }
            
            if (tempPageName) {
                
             [_savedArray addObject:tempPageName];
                
            }
        }
    } else if (_savedArray.count == 0){
        
        for (int i = 0; i < resultsArray.count; i ++) {
            
            NSManagedObject *obj = [resultsArray objectAtIndex:i];
            NSString *pageName  = [obj valueForKey:PageName];
            [_savedArray addObject:pageName];
        }
        
    }
    
    for (int i = 0; i < _savedArray.count; i ++) {
        
        NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[TopSites entityName] predicateString:[NSString stringWithFormat:@"pageName = '%@'",_savedArray[i]]];
        if (resultsArray.count > 0) {
            
            NSManagedObject *obj = [resultsArray objectAtIndex:0];
            
            NSDictionary *saveDic = @{PageName:[obj valueForKey:PageName], PageUrl: [obj valueForKey:PageUrl], ImageUrl:  [obj valueForKey:ImageUrl]};
            [_topSitesSortArray addObject:saveDic];

            
        }
    }
    [_homeCollectionView reloadData];
    //ret assist scrollView contentsize
    self.assistScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * ceil(_topSitesSortArray.count / 6.0), CGRectGetHeight(self.assistScrollView.bounds));
    [userDefaults setObject:_savedArray forKey:TopSits];
    [userDefaults synchronize];
        
}

#pragma mark - Notification
- (void)updateTopSitesDate:(NSNotification *)notification {
    
    [self setupTopSitsData];
}
- (void)updataMainTouchViewLocation:(NSNotification *)notication {
    
    self.didSetupConstraints = NO;
    [self.view setNeedsUpdateConstraints];
    
}

- (void)chooseDefautSeachEngin:(NSNotification *)notification {
    [self getCurrentSearchEnginSave];
}

- (void)resetnResetTransitionDuration:(NSNotification *)notification {
    self.animator.transitionDuration = 0.0;
}

- (void)threeDTouchDeleteTopsite:(NSNotification *)notification {
    //delete cuttent collection cell data
    NSString *pageName = _topSitesSortArray[self.touchPageNumber][@"pageName"];
    [_topSitesSortArray removeObjectAtIndex:self.touchPageNumber];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.touchPageNumber inSection:0];
    [self.homeCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    //delete coredata data
    [CoreDataManager removeObjectWithEntityName:[TopSites entityName] predicateString:[NSString stringWithFormat:@"pageName = '%@'", pageName]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * topSitesSaveArray= [NSMutableArray arrayWithArray:[userDefaults valueForKey:TopSits]];
    [topSitesSaveArray removeObject:pageName];
    [userDefaults setObject:topSitesSaveArray forKey:TopSits];
    [userDefaults synchronize];
    [self setupTopSitsData];
    
}

- (void)remindTheWebsite:(NSNotification *)notification {

}

- (void)applicationWillResignActive:(NSNotification *)notification {
    
    
}

- (void)openTodayWebsite:(NSNotification *)notification {
    /**
     *  sure open the today extention quick open webPage from homeviewcontroller
     */
    self.cellPopAnimationViewRect = self.view.frame;
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.localNotificationSharedDefaults"];
    
    if (self.currentHistoryAndBookmarkVC.isVisibe) {
        [self.currentHistoryAndBookmarkVC.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self loadWebWithUrlString:[shared valueForKey:@"openUrl"]];
        }];
        return;
    }
    
    if (self.currentMoreVC.isVisibe) {
        [self.currentMoreVC.presentingViewController dismissViewControllerAnimated:YES completion:^{
           [self loadWebWithUrlString:[shared valueForKey:@"openUrl"]];
        }];
        return;
        
    }
    if (self.currentQRReader.isVisibe) {
        [self.currentQRReader.presentingViewController dismissViewControllerAnimated:YES completion:^{
            [self loadWebWithUrlString:[shared valueForKey:@"openUrl"]];
        }];
        return;
    }
    
    if (self.currentGustWebVC.isVisibe) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self loadWebWithUrlString:[shared valueForKey:@"openUrl"]];
        return;

    }
    
    if (self.threeDTouchVC.isVisibe) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self loadWebWithUrlString:[shared valueForKey:@"openUrl"]];
        return;
    }

    [self loadWebWithUrlString:[shared valueForKey:@"openUrl"]];
}

- (void)addNewTodayWebsite:(NSNotification *)notification {
    
    if (self.currentDayExtentionVC.isVisibe) {
        return;
    }
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:self.todayExtention];
    self.animator.dragable = YES;
    self.animator.transitionDuration = 0.7;
    self.animator.behindViewAlpha = 0.7;
    self.animator.direction = ZFModalTransitonDirectionBottom;
    [self.animator setContentScrollView:self.todayExtention.tableView];
    self.currentDayExtentionVC.transitioningDelegate = self.animator;
    self.currentDayExtentionVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:self.currentDayExtentionVC animated:YES completion:nil];
    
}

- (void)getCurrentSearchEnginSave {
    NSUserDefaults *searchDefaut = [NSUserDefaults standardUserDefaults];
    if ([[searchDefaut objectForKey:DefautSearchEngin] isEqualToString:SearchEnginBaidu]) {
        _currentSearchEnginString = SearchEnginBaidu;
    } else {
        _currentSearchEnginString = SearchEnginGoogle;
    }
}

#pragma mark-- VLDContextSheetDelegate
- (void) contextSheet: (VLDContextSheet *) contextSheet didSelectItem: (VLDContextSheetItem *) item {
    
    if ([item.title isEqualToString:@"设置"]){
        
        MoreViewController *more = [[MoreViewController alloc] init];
        UINavigationController *moreVC = [[UINavigationController alloc] initWithRootViewController:more];
        self.currentMoreVC = moreVC;
        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:moreVC];
        self.animator.dragable = YES;
        self.animator.transitionDuration = 0.7;
        self.animator.behindViewAlpha = 0.7;
        self.animator.direction = ZFModalTransitonDirectionBottom;
        [self.animator setContentScrollView:more.tableView];
        moreVC.transitioningDelegate = self.animator;
        moreVC.modalPresentationStyle = UIModalPresentationCustom;
       [self presentViewController:moreVC animated:YES completion:nil];
        
    } else if ([item.title isEqualToString:@"二维码"]){
        
        if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
            static QRCodeReaderViewController *reader = nil;
            static dispatch_once_t onceToken;
            
            dispatch_once(&onceToken, ^{
                reader = [QRCodeReaderViewController new];
                reader.modalPresentationStyle = UIModalPresentationFormSheet;
            });
            reader.delegate = self;
            
            [reader setCompletionWithBlock:^(NSString *resultAsString) {
            }];
            self.currentQRReader = reader;
            [self presentViewController:reader animated:YES completion:NULL];
        }
        else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前设备不支持" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        
    } else{
        
        HistoryAndBookmarkViewController *hisBookVC = [[HistoryAndBookmarkViewController alloc] init];
        hisBookVC.isFromHomePage = YES;
         __weak typeof(self) weakSelf = self;
        hisBookVC.getUrltoHomeValueBlock = ^(NSString *UrlString){
            weakSelf.cellPopAnimationViewRect = weakSelf.view.frame;
            [weakSelf loadWebWithUrlString:UrlString];
        };
        
        UINavigationController *historyAndBookmarkVC = [[UINavigationController alloc] initWithRootViewController:hisBookVC];
        self.currentHistoryAndBookmarkVC = historyAndBookmarkVC;
        
        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:historyAndBookmarkVC];
        self.animator.dragable = YES;
        self.animator.transitionDuration = 0.7;
        self.animator.behindViewAlpha = 0.7;
        self.animator.direction = ZFModalTransitonDirectionBottom;
        [self.animator setContentScrollView:hisBookVC.tableView];
        historyAndBookmarkVC.transitioningDelegate = self.animator;
        historyAndBookmarkVC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:historyAndBookmarkVC animated:YES completion:nil];
    }
}

#pragma mark-- MainTouchViewDelegate
- (void)SingleTapMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
 
}
- (void)DoubleTapMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    
}
- (void)LongPressMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.contextSheet startWithGestureRecognizer: gestureRecognizer
                                               inView: self.view];
        self.touchView.hidden = YES;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        self.touchView.hidden = NO;
    }

 
}
- (void)SwipeLeftMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    
}
- (void)SwipeRightMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    
}
- (void)SwipeUpMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    
}
- (void)SwipeDownMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [self.searchBar becomeFirstResponder];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    if (textField.text.length == 0) {
        return NO;
    }
    //transiotn animation position
    self.cellPopAnimationViewRect = self.view.frame;
    //if text length > 0,inputrecord should be save
    if (textField.text.length > 0) {
        NSMutableDictionary *inputRecordDic= [NSMutableDictionary dictionary];
        [inputRecordDic setObject:textField.text forKey:InputRecordString];
        //if the InputRecord is exist
        NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[InputRecord entityName] predicateString:[NSString stringWithFormat:@"inputString = '%@'",textField.text]];
        if (resultsArray.count < 1) {
            [CoreDataManager insertObjectWithParameter:inputRecordDic entityName:[InputRecord entityName]];
            }
    }
    NSMutableString *returnString = [MainSearchBarTextManage manageTextFieldText:textField.text];
    if ([returnString hasPrefix:@"s"]) {
        _willSearchString = returnString;
        if ([_currentSearchEnginString isEqualToString:SearchEnginBaidu]) {
            [self loadWebWithUrlString:BaiduWebsite];
        } else {
            [self loadWebWithUrlString:GoogleWebsite];
        }

    } else {
        [self loadWebWithUrlString:returnString];
    }
    return YES;
}

- (void)loadWebWithUrlString:(NSString *)urlString
{
    //down hidden hisTable
    [self hiddeInputHistorisTableView];
    
    GustWebViewController *gustWebVC = [[GustWebViewController alloc] init];
    //user for today extention open web dismiss current GustWebViewController
    self.currentGustWebVC = gustWebVC;
    gustWebVC.webURL = urlString;
    //if is search state
    if (_willSearchString) {
    
        [_willSearchString deleteCharactersInRange:NSMakeRange(0, 1)];
        gustWebVC.currentSearchString = _willSearchString;
        gustWebVC.isSearch = YES;
        _willSearchString = nil;
        
    }
    [self.navigationController pushViewController:gustWebVC animated:YES];
    
    //clean searchBar state
    self.searchBar.text = nil;
    _isInputingState = NO;
    [self setupSearchBarAnimation:NO];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.searchBar hiddenSearchIcon];
    _isInputingState = YES;
    
    [self.view insertSubview:self.inputHistorisTableView belowSubview:self.searchBar];
    [self showInputHistorisTableView];
    
    [self loadInputHistoryData];
    [self setupSearchBarAnimation:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)searchBarTextChanged:(NSNotification *)notification {
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"self beginswith[cd] %@", _searchBar.text];
    if (_inputRecordSearchResultArray) {
        [_inputRecordSearchResultArray removeAllObjects];
    }
    _inputRecordSearchResultArray = [NSMutableArray arrayWithArray:[_inputRecordArray filteredArrayUsingPredicate:preicate]];
    [self.inputHistorisTableView reloadData];
}

#pragma mark -- Search Bar History Animation
- (void)setupSearchBarAnimation:(BOOL)isShow
{
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:0 animations:^{
        if (isShow) {
            self.searchBar.transform = CGAffineTransformMakeTranslation(0, -40);
        } else {
            self.searchBar.transform = CGAffineTransformIdentity;
            [self.searchBar showSearchIcon];

        }
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hiddeInputHistorisTableView {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = HOME_COLOR;
        _inputHistorisTableView.alpha = 0.3;
        _inputHistorisTableView.frame = CGRectMake(0, SCREEN_HEIGHT, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 70);
    } completion:^(BOOL finished) {
         [_refreshHeader endRefreshing];

    }];
}

- (void)showInputHistorisTableView {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
        _inputHistorisTableView.alpha = 1.0;
        _inputHistorisTableView.frame = CGRectMake(0, 85, SCREEN_WIDTH, SCREEN_HEIGHT - 85);
    }];
}
- (void)loadInputHistoryData
{
    NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[InputRecord entityName] predicateString:nil];
    _inputRecordArray = [NSMutableArray array];
    for (NSInteger i = 0; i < resultsArray.count; i ++) {
        NSManagedObject *obj = [resultsArray objectAtIndex:i];
        [_inputRecordArray addObject:[obj valueForKey:InputRecordString]];
    }

    [self.inputHistorisTableView reloadData];
}

#pragma mark --UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _topSitesSortArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HOMECELL" forIndexPath:indexPath];
    
    if (_topSitesSortArray.count > indexPath.row ) {
        
        NSDictionary *dic = [_topSitesSortArray objectAtIndex:indexPath.row];
        [cell configCollectionViewCell:dic];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.searchBar resignFirstResponder];
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGRect cellRect = [self.view convertRect:cell.frame fromView:self.homeCollectionView];
    self.cellPopAnimationViewRect = cellRect;
    [self loadWebWithUrlString:cell.pageUrlString];
}

#pragma mark --UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchBar.text.length > 0) {
        return _inputRecordSearchResultArray.count;
    } else {
        return _inputRecordArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SwipCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (_searchBar.text.length > 0) {
        cell.textLabel.text  = [_inputRecordSearchResultArray objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text  = [_inputRecordArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.textColor = [UIColor colorWithWhite:0.3745 alpha:1.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    _searchBar.text = cell.textLabel.text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_inputRecordArray.count > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 35.0;
    } else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIButton *clearAllTopsiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearAllTopsiteButton setTitle:@"清空输入历史" forState:UIControlStateNormal];
    clearAllTopsiteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    clearAllTopsiteButton.backgroundColor = [UIColor clearColor];
    [clearAllTopsiteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [clearAllTopsiteButton addTarget:self action:@selector(clearAllTopsiteButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    return clearAllTopsiteButton;
}

- (void)clearAllTopsiteButtonTaped:(UIButton *)sender {
    [_inputRecordArray removeAllObjects];
    [_inputHistorisTableView reloadData];
    [CoreDataManager removeObjectWithEntityName:[InputRecord entityName] predicateString:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

- (void)checkoutNetWorkState {
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    //0 - 无网络; 1 - 2G; 2 - 3G; 3 - 4G; 5 - WIFI
    if (type == 0) {
        
        [[AllAlertView sharedAlert] showWithTitle:@"没有网络连接" alertType:AllAlertViewAlertTypeAlert height:130.0];
    }
}

#pragma mark -- Add 3D Touch
- (void)check3DTouch {
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
        NSLog(@"3d touch 开启");
    } else {
        NSLog(@"3d touch 没有开启");
    }
}

#pragma mark -- UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    CGPoint cellPosition = [_homeCollectionView convertPoint:location fromView:self.view];
    NSIndexPath *touchIndexPath = [_homeCollectionView indexPathForItemAtPoint:cellPosition];
    if (touchIndexPath) {
        [_homeCollectionView deselectItemAtIndexPath:touchIndexPath animated:YES];
        HomeCollectionViewCell *homeCell = (HomeCollectionViewCell *)[_homeCollectionView cellForItemAtIndexPath:touchIndexPath];
        self.touchPageNumber = touchIndexPath.row;
        GustWebViewController *gustwebVC = [[GustWebViewController alloc] init];
        gustwebVC.webURL = homeCell.pageUrlString;
        gustwebVC.touchView.hidden = YES;
        CGRect rect = CGRectMake(homeCell.frame.origin.x + COLLECTION_CONTENT_OFFSET, homeCell.frame.origin.y + COLLECTION_CONTENT_OFFSET, COLLECTION_CONTENT_WIDTH, COLLECTION_CONTENT_WIDTH);
        previewingContext.sourceRect = [self.view convertRect:rect fromView:self.homeCollectionView];
        self.threeDTouchVC = gustwebVC;
        self.urlString = homeCell.pageUrlString;
        return gustwebVC;
        
    }
    return nil;

  }

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {

    [self.navigationController pushViewController:self.threeDTouchVC  animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[GustCollectionView class]]) {
        [self.assistScrollView setContentOffset:self.homeCollectionView.contentOffset ];
    }else if([scrollView isKindOfClass:[GustAssistScrollView class]]) {
        [self.homeCollectionView setContentOffset:self.assistScrollView.contentOffset];
    } else {
        return;
    }
    
}

#pragma mark -- animation
- (void)touchViewAnimtion {
    
    self.touchView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.beginTime = CACurrentMediaTime() + 0.5;
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    animation.springBounciness = 10.0;
    animation.springSpeed = 10.0;
    [self.touchView.layer pop_addAnimation:animation forKey:@"spring"];
}

- (void)searchBarAnimation {
    self.searchBar.hidden = NO;
    _isFirstEnter = YES;
    [UIView animateWithDuration:0.35 delay:0 options:0 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.searchBar cache:YES];
    } completion:nil];
}

- (void)cellContentViewAnimation:(NSMutableArray *)cellArray {
    for (NSInteger index = 0; index < cellArray.count; index ++) {
        HomeCollectionViewCell *cell = cellArray[index];
        switch (index) {
            case 0:
                [self showMycellWithAnimation:cell withDaly:0];
                    
                break;
            case 1:
                [self showMycellWithAnimation:cell withDaly:0.1];
                    
                break;
            case 2:
                [self showMycellWithAnimation:cell withDaly:0.2];
                break;
            case 3:
                [self showMycellWithAnimation:cell withDaly:0.1];
                    
                break;
            case 4:
                [self showMycellWithAnimation:cell withDaly:0.2];
                break;
            case 5:
                [self showMycellWithAnimation:cell withDaly:0.3];
                break;
            default:
                    break;
            }
    }

}

- (void)showMycellWithAnimation:(HomeCollectionViewCell *)cell withDaly:(NSTimeInterval)dely {
    [self performSelector:@selector(showCurrentCell:) withObject:cell afterDelay:dely];
}

- (void)showCurrentCell:(HomeCollectionViewCell *)cell {
    cell.cellContentView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        cell.cellContentView.backgroundColor = [UIColor whiteColor];
        cell.cellContentView.alpha = 1.0;
    }];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:NO completion:^{
        
        GustWebViewController *gustWebVC = [[GustWebViewController alloc] init];
        gustWebVC.webURL = result;
        [self.navigationController pushViewController:gustWebVC animated:YES];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end



