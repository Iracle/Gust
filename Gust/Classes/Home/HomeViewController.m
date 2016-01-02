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

#import "GustAlertView.h"
#import <objc/message.h>
//surport Touch ID
#import <LocalAuthentication/LocalAuthentication.h>
//privacy password view
#import "PrivacyPasswordView.h"

#import "GustRefreshHeader.h"
#import "GustCollectionView.h"
#import "HorizontalCollectionViewLayout.h"


@interface HomeViewController () <MainTouchViewDelegate, VLDContextSheetDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UIViewControllerPreviewingDelegate, PrivacyPasswordViewDelegate>

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
@property (nonatomic, strong) CustomNavigationController *threeDTouchNav;
@property (nonatomic, copy) NSString *urlString;
//privacy password view
@property (nonatomic, weak) PrivacyPasswordView *privacyView;

//pull back
@property (nonatomic, strong) GustRefreshHeader *refreshHeader;


@end

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -- getter
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
        _searchBar.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 20, SearchBarHeight);
        _searchBar.center = CGPointMake(CGRectGetMidX(self.view.bounds), 102.5);
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (PrivacyPasswordView *)privacyView {
    if (!_privacyView) {
        _privacyView = [[[NSBundle mainBundle] loadNibNamed:@"PrivacyPassword" owner:nil options:nil] lastObject];
        _privacyView.frame = CGRectMake(0, -50, CGRectGetWidth(self.view.bounds), 180);
        _privacyView.delegate = self;
    }
    return _privacyView;
    
}

- (UITableView *)inputHistorisTableView {
    if (!_inputHistorisTableView) {
        _inputHistorisTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 700, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 70)];
        _inputHistorisTableView.delegate = self;
        _inputHistorisTableView.dataSource = self;
        _inputHistorisTableView.alpha = 0.0;
        _inputHistorisTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _inputHistorisTableView.separatorColor = [UIColor clearColor];
        
        _refreshHeader = [[GustRefreshHeader alloc] init];
        _refreshHeader.scrollView = _inputHistorisTableView;
        [_refreshHeader addHeadView];
        _refreshHeader.pullBackOffset = 0.8;
        __weak typeof(self) weakSelf = self;
        _refreshHeader.beginRefreshingBlock = ^(){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hiddeInputHistorisTableView];
                [weakSelf setupSearchBarAnimation:NO];
                weakSelf.searchBar.text = nil;
            });
        };
    }
    return _inputHistorisTableView;
}

- (GustCollectionView *)homeCollectionView {
    if (!_homeCollectionView) {
        HorizontalCollectionViewLayout *layout = [[HorizontalCollectionViewLayout alloc] init];
        layout.itemSize = CGSizeMake(CollectionViewCellSize_WIDTH,CollectionViewCellSize_HIGHT);
        
        _homeCollectionView = [[GustCollectionView alloc] initWithFrame:CGRectMake(0, 170, self.view.bounds.size.width, CollectionViewCellSize_HIGHT * 3 - 1) collectionViewLayout:layout];
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self check3DTouch];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(checkoutNetWorkState) withObject:self afterDelay:2];
}

- (void)addContextSheet:(UIGestureRecognizer *)sender {
     NSLog(@"%@",sender);
    [self.contextSheet startWithGestureRecognizer: sender
                                               inView: self.view];
    self.touchView.hidden = YES;
    
}
- (void)removeContextSheet {
    self.touchView.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = HOME_COLOR;
    [self getCurrentSearchEnginSave];

    [self.view addSubview:self.homeCollectionView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.touchView];
    
    self.contextSheet = [[VLDContextSheet alloc] initWithItem:@"书签/历史" item:@"隐私模式" item:@"设置"];
    self.contextSheet.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTopSitesDate:) name:NotificationUpdateTopSites object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchBarTextChanged:) name:@"UITextFieldTextDidChangeNotification" object:_searchBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataMainTouchViewLocation:) name:NotificationUpdateMainTouchViewLocation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseDefautSeachEngin:) name:NotificationChangeDefautSearchEngin object:nil];
    
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
        UINavigationController *moreVC = [[UINavigationController alloc] initWithRootViewController:[[MoreViewController alloc] init]];
        moreVC.modalPresentationStyle = UIModalPresentationCustom;
        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:moreVC];
        self.animator.dragable = NO;
        self.animator.bounces = NO;
        self.animator.behindViewAlpha = 0.5f;
        self.animator.behindViewScale = 0.6f;
        self.animator.transitionDuration = 0.7f;
        self.animator.direction = ZFModalTransitonDirectionBottom;
        moreVC.transitioningDelegate = self.animator;
       [self presentViewController:moreVC animated:YES completion:nil];
        
    } else if ([item.title isEqualToString:@"隐私模式"]){
        
        __weak typeof(self) weakSelf = self;
        //Touch ID auth
        [self authenticateUser:^(bool isEnter) {
            if (isEnter) {
                NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
                if ([[privacyDefaults objectForKey:IsGustPrivacy] boolValue] == NO) {
                    BOOL privicyBool = YES;
                    [privacyDefaults setObject: [NSNumber numberWithBool:privicyBool] forKey:IsGustPrivacy];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf performSelector:@selector(showPrivcyAlert:) withObject:@"已开启隐私模式" afterDelay:0.5];
                    });
                    
                } else {
                    BOOL privicyBool = NO;
                    [privacyDefaults setObject: [NSNumber numberWithBool:privicyBool] forKey:IsGustPrivacy];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf performSelector:@selector(showPrivcyAlert:) withObject:@"已关闭隐私模式" afterDelay:0.5];
                    });
                }
                [privacyDefaults synchronize];

                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf performSelector:@selector(loadPrivacyView) withObject:nil afterDelay:0.35];
                });
            }
            
        }];
        
    } else{
        //if is privicy mode
        NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
        if ([[privacyDefaults objectForKey:IsGustPrivacy] boolValue]) {
            GustAlertView *alertView = [[GustAlertView alloc] init];
            [alertView showInView:self.view type:0 title:@"处于隐私模式不能访问!"];
            return;
        }

        HistoryAndBookmarkViewController *hisBookVC = [[HistoryAndBookmarkViewController alloc] init];
        hisBookVC.isFromHomePage = YES;
        hisBookVC.getUrltoHomeValueBlock = ^(NSString *UrlString){
            [self loadWebWithUrlString:UrlString];
        };
        UINavigationController *historyAndBookmarkVC = [[UINavigationController alloc] initWithRootViewController:hisBookVC];
        historyAndBookmarkVC.modalPresentationStyle = UIModalPresentationCustom;
        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:historyAndBookmarkVC];
        self.animator.dragable = NO;
        self.animator.bounces = NO;
        self.animator.behindViewAlpha = 0.5f;
        self.animator.behindViewScale = 0.6f;
        self.animator.transitionDuration = 0.7f;
        self.animator.direction = ZFModalTransitonDirectionBottom;
        historyAndBookmarkVC.transitioningDelegate = self.animator;
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
         NSLog(@"%@",gestureRecognizer);
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
    //if text length > 0,inputrecord should be save
    if (textField.text.length > 0) {
        //pravicy mode
        NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
        if (![[privacyDefaults objectForKey:IsGustPrivacy] boolValue]) {
            
            NSMutableDictionary *inputRecordDic= [NSMutableDictionary dictionary];
            [inputRecordDic setObject:textField.text forKey:InputRecordString];
            //if the InputRecord is exist
            NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[InputRecord entityName] predicateString:[NSString stringWithFormat:@"inputString = '%@'",textField.text]];
            if (resultsArray.count < 1) {
                [CoreDataManager insertObjectWithParameter:inputRecordDic entityName:[InputRecord entityName]];
            }
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
    gustWebVC.webURL = urlString;
    //if is search state
    if (_willSearchString) {
    
        [_willSearchString deleteCharactersInRange:NSMakeRange(0, 1)];
        gustWebVC.currentSearchString = _willSearchString;
        gustWebVC.isSearch = YES;
        _willSearchString = nil;
        
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gustWebVC];
    [self presentViewController:nav animated:NO completion:nil];
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
    [self.searchBar showSearchIcon];

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
        }
    } completion:^(BOOL finished) {
    }];
    
}

- (void)hiddeInputHistorisTableView {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = HOME_COLOR;
        _inputHistorisTableView.alpha = 0.3;
        _inputHistorisTableView.frame = CGRectMake(0, 700, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 70);
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
    [self loadWebWithUrlString:cell.pageUrlString];
    
}

#pragma mark --UITableViewDelegate
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
    cell.textLabel.textColor = [UIColor colorWithWhite:0.172 alpha:0.940];
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
        GustAlertView *alert = [[GustAlertView alloc] init];
        [alert showInView:self.view type:1 title:@"没有网络连接"];
    }
}
#pragma mark -- PrivacyPasswordViewDelegate
- (void)privacyPasswordView:(PrivacyPasswordView *)privacyView sucess:(BOOL)success {
    if (success) {
        
        NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
        if ([[privacyDefaults objectForKey:IsGustPrivacy] boolValue] == NO) {
            BOOL privicyBool = YES;
            [privacyDefaults setObject: [NSNumber numberWithBool:privicyBool] forKey:IsGustPrivacy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(showPrivcyAlert:) withObject:@"已开启隐私模式" afterDelay:0.5];
            });
            
        } else {
            BOOL privicyBool = NO;
            [privacyDefaults setObject: [NSNumber numberWithBool:privicyBool] forKey:IsGustPrivacy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(showPrivcyAlert:) withObject:@"已关闭隐私模式" afterDelay:0.5];
            });
        }
        [privacyDefaults synchronize];
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
        GustWebViewController *gustwebVC = [[GustWebViewController alloc] init];
        gustwebVC.touchView.hidden = YES;
        gustwebVC.webURL = homeCell.pageUrlString;
        CGRect rect = CGRectMake(homeCell.frame.origin.x + 10, homeCell.frame.origin.y + 10, CollectionContentView_WIDTH, CollectionContentView_WIDTH);
        previewingContext.sourceRect = [self.view convertRect:rect fromView:self.homeCollectionView];
        CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:gustwebVC];
        self.threeDTouchNav = nav;
        self.urlString = homeCell.pageUrlString;
        return nav;
        
    }
    return nil;

  }

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {

    GustWebViewController *gustwebVC = [[GustWebViewController alloc] init];
    gustwebVC.webURL = self.urlString;
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:gustwebVC];
    [self showViewController:nav sender:self];
    
   }

#pragma mark -- Touch ID
- (void)authenticateUser:(void(^)(_Bool isEnter))handler {
    //inti context object
    LAContext *context = [LAContext new];
    context.localizedFallbackTitle = @"输入密码";
    NSError *error = nil;
    NSString* result = @"获取进入隐私模式的权限";
    //judge if the device suport internationl
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //use fingerpint
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                handler(YES);
                //update main UI
            } else {
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            handler(NO);
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }

            }
    
            
        }];
        
        
    } else {
        //not surport fingerprint
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
        NSLog(@"pass world alert");
}
    
}
-(void)showPrivcyAlert:(NSNotification *)notification {
    GustAlertView *alertView = [[GustAlertView alloc] init];
    [alertView showInView:self.view type:0 title:(NSString *)notification];
}

- (void)loadPrivacyView {
    [self.view addSubview:self.privacyView];
    self.privacyView.transform = CGAffineTransformMakeTranslation(0, -130);
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:0 animations:^{
        self.privacyView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];
}

@end




