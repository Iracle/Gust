//
//  GustWebViewController.m
//  Gust
//
//  Created by Iracle on 15/3/5.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "GustWebViewController.h"
#import "OTMWebView.h"
#import "OTMWebViewProgressBar.h"
#import "GustConfigure.h"
#import "MainSearchBar.h"
#import "VLDContextSheet.h"
#import "MoreViewController.h"
#import "HistoryAndBookmarkViewController.h"
#import "ZFModalTransitionAnimator.h"
#import "VLDContextSheetItem.h"
#import "HomeViewController.h"
#import "GustConfigure.h"

#import "CoreDataManager.h"
#import "History.h"
#import "Bookmark.h"

//input record
#import "InputRecord.h"
#import "TopSites.h"
#import "CoreDataManager.h"
#import "MainSearchBarTextManage.h"
//multiTab
#import "MultiTabView.h"
#import "NavaSearchBar.h"
#import "GustRefreshHeader.h"
#import "AllAlertView.h"
#import "GustActivity.h"
#import "Localisator.h"

#import "BDVRCustomRecognitonViewController.h"
#import "BDVoiceRecognitionClientHelper.h"

@interface GustWebViewController ()< OTMWebViewDelegate, MainTouchViewDelegate, UIScrollViewDelegate, VLDContextSheetDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MainSearchBarDelegate, BDVRCustomRecognitonViewControllerDelegate>

@property (strong, nonatomic) OTMWebView *webView;
@property (strong, nonatomic) OTMWebViewProgressBar *progressBar;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (strong, nonatomic) VLDContextSheet *contextSheet;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property (nonatomic, strong) MainSearchBar *searchBar;
@property (nonatomic, strong) NSMutableDictionary *bookmarkDic;
@property (nonatomic, strong) NSMutableDictionary *historyDic;

@property (nonatomic, strong) UITableView *inputHistorisTableView;
@property (nonatomic, assign) BOOL isInputingState;
//save input record array
@property (nonatomic, strong) NSMutableArray *inputRecordArray;
//save search record result array
@property (nonatomic, strong) NSMutableArray *inputRecordSearchResultArray;
//save currentSearchEngin
@property (nonatomic, strong) NSString *currentSearchEnginString;

//multiTab
@property (nonatomic, strong) MultiTabView *mutiTabView;
@property (nonatomic, strong) NSMutableArray *currentMutiTabArray;

@property (nonatomic, strong) UIImage *currentTabPageImage;
@property (nonatomic, strong) NavaSearchBar *navaSearchBar;
//pull back
@property (nonatomic, strong) GustRefreshHeader *refreshHeader;

@end

@implementation GustWebViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.navigationController setNavigationBarHidden:NO];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentMutiTabArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (OTMWebView *)webView
{
    if (!_webView) {
        _webView = [[OTMWebView alloc] initWithFrame:CGRectMake(0, 40.0, SCREEN_WIDTH, SCREEN_HEIGHT- 40.0)];
        _webView.scrollView.scrollsToTop = YES;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (MainTouchBaseView *)touchView
{
    if (!_touchView) {
        _touchView = [[MainTouchBaseView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - MainTouchViewRadius / 2, CGRectGetMaxY(self.view.bounds) - MainTouchViewRadius * 1.5, MainTouchViewRadius, MainTouchViewRadius)];
        _touchView.mainTouchView.delegate = self;
    }
    return _touchView;
}

- (NavaSearchBar *)navaSearchBar {
    if (!_navaSearchBar) {
        _navaSearchBar = [[NavaSearchBar alloc] init];
    }
    return _navaSearchBar;
}

- (MainSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = self.navaSearchBar.searchBar;
        _searchBar.delegate = self;
        _searchBar.micDelegate = self;
    }
    return _searchBar;
}

- (NSMutableDictionary *)bookmarkDic
{
    if (!_bookmarkDic) {
        _bookmarkDic = [NSMutableDictionary dictionary];
    }
    return _bookmarkDic;
}

- (NSMutableDictionary *)historyDic
{
    if (!_historyDic) {
        _historyDic = [NSMutableDictionary dictionary];
    }
    return _historyDic;
}
- (UITableView *)inputHistorisTableView {
    if (!_inputHistorisTableView) {
        _inputHistorisTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 70)];
        _inputHistorisTableView.delegate = self;
        _inputHistorisTableView.dataSource = self;
        _inputHistorisTableView.alpha = 0.0;
        _inputHistorisTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _inputHistorisTableView.separatorColor = [UIColor clearColor];
        
        _refreshHeader = [[GustRefreshHeader alloc] init];
        _refreshHeader.scrollView = _inputHistorisTableView;
        [_refreshHeader addHeadView];
        _refreshHeader.pullBackOffset = 0.8;
        __strong typeof(self) weakSelf = self;
        _refreshHeader.beginRefreshingBlock = ^(){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf hiddeInputHistorisTableView];
                weakSelf.searchBar.text = nil;
            });
        };
    }
    return _inputHistorisTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSURLRequest *request = nil;
    [self.webView loadRequest:request];
    [self.webView removeFromSuperview];
    self.webView = nil;
    self.webView.delegate = nil;
    [self.webView stopLoading];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.hidden = YES;
    [self getCurrentSearchEnginSave];
    [self configureViewFromLocalisation];
    self.navigationController.hidesBarsWhenVerticallyCompact = YES;
    [self.view addSubview:self.webView];
    [self gustFollowRollingScrollView: self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
    [self.view addSubview:self.touchView];
    
    [self.navaSearchBar showInView:self.view];
    
    self.progressBar = [[OTMWebViewProgressBar alloc]init];
    CGFloat progressBarHeight = 1.5;
    
    self.progressBar.frame = CGRectMake(0.0, CGRectGetMaxY(self.navaSearchBar.bounds) - progressBarHeight, CGRectGetWidth(self.navaSearchBar.bounds), progressBarHeight);
    self.progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.progressBar.tintColor = [UIColor colorWithRed:0.013 green:0.763 blue:0.634 alpha:1.000];
    [self.navaSearchBar addSubview:self.progressBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchBarTextChanged:) name:@"UITextFieldTextDidChangeNotification" object:_searchBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataMainTouchViewLocation:) name:NotificationUpdateMainTouchViewLocation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseDefautSeachEngin:) name:NotificationChangeDefautSearchEngin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openWebPageInNewTab:) name:@"NotificationOpenPageInNewTab" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLanguageChangedNotification:)
                                                 name:kNotificationLanguageChanged
                                               object:nil];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return NO;
    }
    [self openNewWebWithSearchText:textField.text];

    return YES;
}

- (void)openNewWebWithSearchText:(NSString *) searchText {
    if (searchText.length > 0) {
        
        NSMutableDictionary *inputRecordDic= [NSMutableDictionary dictionary];
        [inputRecordDic setObject:searchText forKey:InputRecordString];
        //if the InputRecord is exist
        NSArray *allHisInput = [CoreDataManager searchObjectWithEntityName:[InputRecord entityName] predicateString: nil];
        if (allHisInput.count == 9) {
            NSManagedObject *obj = [allHisInput objectAtIndex: 0];
            NSString *deleteInput = [obj valueForKey:InputRecordString];
            [CoreDataManager removeObjectWithEntityName:[InputRecord entityName] predicateString:[NSString stringWithFormat:@"inputString = '%@'",deleteInput]];
        }
        if (allHisInput.count < 10) {
            NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[InputRecord entityName] predicateString:[NSString stringWithFormat:@"inputString = '%@'",searchText]];
            if (resultsArray.count < 1) {
                [CoreDataManager insertObjectWithParameter:inputRecordDic entityName:[InputRecord entityName]];
            }
        }
        
    }
    
    NSMutableString *returnString = [MainSearchBarTextManage manageTextFieldText:searchText];
    if ([returnString hasPrefix:@"s"]) {
        _currentSearchString = returnString;
        [_currentSearchString deleteCharactersInRange:NSMakeRange(0, 1)];
        _isSearch = YES;
        if ([_currentSearchEnginString isEqualToString:SearchEnginBaidu]) {
            [self loadWebWithUrlString:BaiduWebsite];
        } else {
            [self loadWebWithUrlString:GoogleWebsite];
        }
        
    } else {
        [self loadWebWithUrlString:returnString];
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = nil;
    _isInputingState = YES;
    [self.searchBar hiddenSearchIcon];
    
    [self.view insertSubview:self.inputHistorisTableView aboveSubview:self.webView];
    [self showInputHistorisTableView];
    [self loadInputHistoryData];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.searchBar resignFirstResponder];

    return YES;
}
#pragma mark -- Search Bar History Animation

- (void)hiddeInputHistorisTableView {
    [self.navaSearchBar hiddenSearchBar];
    [UIView animateWithDuration:0.24 animations:^{
        _inputHistorisTableView.alpha = 0.3;
        _inputHistorisTableView.frame = CGRectMake(0, SCREEN_HEIGHT, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 70);
    } completion:^(BOOL finished) {

        [_refreshHeader endRefreshing];
           
    }];
}

- (void)showInputHistorisTableView {
    [UIView animateWithDuration:0.15 animations:^{
        _inputHistorisTableView.alpha = 1.0;
        _inputHistorisTableView.frame = CGRectMake(0, 65.0, SCREEN_WIDTH, SCREEN_HEIGHT - 65.0);
    }];
}

- (void)loadWebWithUrlString:(NSString *)urlString
{
    //down hidden hisTable
    [self hiddeInputHistorisTableView];
    
    //clean searchBar state
    self.searchBar.text = nil;
    _isInputingState = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

}
#pragma mark -- Notification
- (void)searchBarTextChanged:(NSNotification *)notification {
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"self beginswith[cd] %@", _searchBar.text];
    if (_inputRecordSearchResultArray) {
        [_inputRecordSearchResultArray removeAllObjects];
    }
    _inputRecordSearchResultArray = [NSMutableArray arrayWithArray:[_inputRecordArray filteredArrayUsingPredicate:preicate]];
    [self.inputHistorisTableView reloadData];
}

- (void)updataMainTouchViewLocation:(NSNotification *)notification {
    
    self.didSetupConstraints = NO;
    [self.view setNeedsUpdateConstraints];
    
}

- (void)chooseDefautSeachEngin:(NSNotification *)notification {
    [self getCurrentSearchEnginSave];
}

- (void)openWebPageInNewTab:(NSNotification *)notification {
    
    NSDictionary *newTabDic = @{PageName:_historyDic[PageName], PageUrl: _historyDic[PageUrl], CurrentViewShot: [self getCurrentViewShotImage]};
    [_currentMutiTabArray addObject:newTabDic];

}

- (void)getCurrentSearchEnginSave {
    NSUserDefaults *searchDefaut = [NSUserDefaults standardUserDefaults];
    if ([[searchDefaut objectForKey:DefautSearchEngin] isEqualToString:SearchEnginBaidu]) {
        _currentSearchEnginString = SearchEnginBaidu;
    } else {
        _currentSearchEnginString = SearchEnginGoogle;
    }
}

- (void)loadInputHistoryData
{
    NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[InputRecord entityName] predicateString:nil];
    _inputRecordArray = [NSMutableArray array];
    for (NSInteger i = 0; i < resultsArray.count; i ++) {
        NSManagedObject *obj = [resultsArray objectAtIndex:i];
        [_inputRecordArray addObject:[obj valueForKey:InputRecordString]];
    }
   _inputRecordArray =  [[[_inputRecordArray reverseObjectEnumerator] allObjects] mutableCopy];
    
    [self.inputHistorisTableView reloadData];
}

#pragma mark --OTMWebViewDelegate
- (void)webView:(OTMWebView *)progressTracker progressDidChange:(double)progress
{
    [self.progressBar setProgress:progress animated:YES];
}

- (void)webViewProgressDidFinish:(OTMWebView *)webView
{
    
}

- (void)webView:(OTMWebView *)webView didReceiveResponse:(NSURLResponse *)response forRequest:(NSURLRequest *)request
{
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.searchBar resignFirstResponder];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.navaSearchBar.webTitle.text = LOCALIZATION(@"NetworkError");
    [self performSelector:@selector(checkoutNetWorkState) withObject:self afterDelay:1.3];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *currentDocumentTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *currentDocumentUrl = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSString *currentDocumentImageUrl = [self.webView stringByEvaluatingJavaScriptFromString:@"var images = document.getElementsByTagName('img');images[0].src.toString();"];
    
    [self.bookmarkDic setObject:currentDocumentTitle forKey:PageName];
    [self.bookmarkDic setObject:currentDocumentUrl forKey:PageUrl];
    [self.bookmarkDic setObject:currentDocumentImageUrl forKey:ImageUrl];
    
    [self.historyDic setObject:currentDocumentTitle forKey:PageName];
    [self.historyDic setObject:currentDocumentUrl forKey:PageUrl];
    [self.historyDic setObject:currentDocumentImageUrl forKey:ImageUrl];
    
    NSArray *rusultsArray = [CoreDataManager searchObjectWithEntityName:[History entityName] predicateString:[NSString stringWithFormat:@"pageName = '%@'",currentDocumentTitle] ];
    if (rusultsArray.count == 0 && currentDocumentTitle.length > 0) {
        
        [CoreDataManager insertObjectWithParameter:self.historyDic entityName:[History entityName]];
        }
    
    self.navaSearchBar.webTitle.text = currentDocumentTitle;

    //is search
    if (_isSearch) {
        NSString *javaScriptExecuteString = nil;
        if ([_currentSearchEnginString isEqualToString:SearchEnginBaidu]) {
            
          javaScriptExecuteString = [NSString stringWithFormat:@"document.getElementsByName('word')[0].value='%@';",_currentSearchString];
        } else {
            
          javaScriptExecuteString = [NSString stringWithFormat:@"document.getElementsByName('q')[0].value='%@';",_currentSearchString];
        }
        
        [webView stringByEvaluatingJavaScriptFromString:javaScriptExecuteString];
        [webView stringByEvaluatingJavaScriptFromString:@"document.forms[0].submit();"];
        _isSearch = NO;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

#pragma mark-- MainTouchViewDelegate
- (void)SingleTapMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)DoubleTapMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    _mutiTabView = [[MultiTabView alloc] init];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    [_mutiTabView showInView:windows tabArray:_currentMutiTabArray];
    __weak typeof(self) weakSelf = self;
    //load selected url
    _mutiTabView.mutiGetUrlValueBlock = ^(NSString *URLString){
        
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
        
    };
    _mutiTabView.multiUpdateDataArrayBlock = ^(NSMutableArray *array) {
        weakSelf.currentMutiTabArray = [NSMutableArray arrayWithArray:array];
        
    };
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
    [self.webView goBack];
}
- (void)SwipeRightMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [self.webView goForward];
}
- (void)SwipeUpMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    NSString *bookmark = [self.bookmarkDic objectForKey:PageName];
    NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[Bookmark entityName] predicateString:[NSString stringWithFormat:@"pageName = '%@'",bookmark] ];
    if (resultsArray.count < 1 && [self.bookmarkDic[PageName] length] > 0 ) {
        
        [CoreDataManager insertObjectWithParameter:self.bookmarkDic entityName:[Bookmark entityName]];
        [[AllAlertView sharedAlert] showWithTitle: LOCALIZATION(@"TopSiteSucess") alertType:AllAlertViewAlertTypeDone height:100.0];

    } else {
        [[AllAlertView sharedAlert] showWithTitle: LOCALIZATION(@"BookmarksExist") alertType:AllAlertViewAlertTypeRemind height:100.0];
    }

}
- (void)SwipeDownMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [self.navaSearchBar showSearchBar];

    [self.searchBar becomeFirstResponder];

}

#pragma mark-- VLDContextSheetDelegate
- (void) contextSheet: (VLDContextSheet *) contextSheet didSelectItem: (VLDContextSheetItem *) item {
    
    if ([item.title isEqualToString: LOCALIZATION(@"Settings")]){
        MoreViewController *more = [[MoreViewController alloc] init];
        UINavigationController *moreVC = [[UINavigationController alloc] initWithRootViewController:more];
        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:moreVC];
        self.animator.dragable = YES;
        self.animator.transitionDuration = 0.7;
        self.animator.behindViewAlpha = 0.7;
        self.animator.behindViewScale = 0.8;
        self.animator.direction = ZFModalTransitonDirectionBottom;
        [self.animator setContentScrollView:more.tableView];
        moreVC.transitioningDelegate = self.animator;
        moreVC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:moreVC animated:YES completion:nil];
        
    } else if ([item.title isEqualToString: LOCALIZATION(@"ShareWeb")]){
        
        if (!self.historyDic[PageUrl]) {
            return;
        }
        
        NSString *textToShare = [NSString stringWithFormat:@"%@%@",LOCALIZATION(@"ShareText"),self.historyDic[PageName]];
        UIImage *imageToShare = [self getCurrentViewShotImage];
        NSURL *urlToShare = [NSURL URLWithString:self.historyDic[PageUrl]];
        
        NSArray *activityItems = @[textToShare,imageToShare, urlToShare];
        
        GustActivity *actWeichat = [[GustActivity alloc]initWithImage:[UIImage imageNamed:@"wechat_session"] atURL: @"" atTitle:@"WeChat" atShareContentArray:activityItems];
        
        GustActivity *actWeiCircle = [[GustActivity alloc]initWithImage:[UIImage imageNamed:@"wechat_timeline"] atURL:@"" atTitle:@"Moments" atShareContentArray:activityItems];
        
        NSArray *shareApps = @[actWeichat, actWeiCircle];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:shareApps];
        activityVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            _contextSheet.hidden = NO;
            _touchView.hidden = NO;
        };
        
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
        [self presentViewController:activityVC animated:YES completion:nil];
        
    } else{

        HistoryAndBookmarkViewController *hisBookVC = [[HistoryAndBookmarkViewController alloc] init];
        hisBookVC.getUrlValueBlock = ^(NSString *value){
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:value]]];
            
        };
        UINavigationController *historyAndBookmarkVC = [[UINavigationController alloc] initWithRootViewController:hisBookVC];
        self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:historyAndBookmarkVC];
        self.animator.dragable = YES;
        self.animator.transitionDuration = 0.7;
        self.animator.behindViewAlpha = 0.7;
        self.animator.behindViewScale = 0.8;
        self.animator.direction = ZFModalTransitonDirectionBottom;
        [self.animator setContentScrollView:hisBookVC.tableView];
        historyAndBookmarkVC.transitioningDelegate = self.animator;
        historyAndBookmarkVC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:historyAndBookmarkVC animated:YES completion:nil];
        
    }
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *clearAllTopsiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearAllTopsiteButton setTitle: LOCALIZATION(@"ClearInput") forState:UIControlStateNormal];
    clearAllTopsiteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    clearAllTopsiteButton.backgroundColor = [UIColor clearColor];
    [clearAllTopsiteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [clearAllTopsiteButton addTarget:self action:@selector(clearAllTopsiteButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    return clearAllTopsiteButton;
}

- (void)clearAllTopsiteButtonTaped:(UIButton *)sender
{
    [_inputRecordArray removeAllObjects];
    [_inputHistorisTableView reloadData];
    [CoreDataManager removeObjectWithEntityName:[InputRecord entityName] predicateString:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

- (void)gustWebViewScrollUp
{
    if (self.touchView.alpha != CGFLOAT_MIN) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.touchView.alpha = CGFLOAT_MIN;
        } completion:^(BOOL finished) {
            self.touchView.hidden = YES;
        }];

    }
}

-(void)gustWebViewScrollDown
{
    if (self.touchView.alpha != 1.0) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.touchView.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.touchView.hidden = NO;
        }];
    }
    
}
//截图
- (UIImage *)getCurrentViewShotImage {
    
    _contextSheet.hidden = YES;
    _touchView.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(self.webView.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(CGRectMake(0, 64.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)));
    [self.view.layer renderInContext:context];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _contextSheet.hidden = NO;
    _touchView.hidden = NO;
    return image;
}

#pragma -- 3D Touch
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    /**
     *   next version add the remander open web function
     *
     *
     */
    
    /*
    UIPreviewAction *remindAction = [UIPreviewAction actionWithTitle:@"提醒" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationReminderMe object:nil];
        
    }];
    */
    UIPreviewAction *deleteAction = [UIPreviewAction actionWithTitle: LOCALIZATION(@"TopSiteDelete") style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDeleteTopsit object:nil];

    }];
    return @[deleteAction];
}

- (void) receiveLanguageChangedNotification:(NSNotification *) notification
{
    if ([notification.name isEqualToString:kNotificationLanguageChanged])
    {
        [self configureViewFromLocalisation];
    }
}

- (void)configureViewFromLocalisation {
    
    VLDContextSheetItem *item1 = [[VLDContextSheetItem alloc] initWithTitle: [NSString stringWithFormat:@"%@/%@", LOCALIZATION(@"Bookmarks"), LOCALIZATION(@"History")]
                                                                      image: [UIImage imageNamed: @"bookhistory"]
                                                           highlightedImage: [UIImage imageNamed: @"bookhistory_h"]];
    
    
    VLDContextSheetItem *item2 = [[VLDContextSheetItem alloc] initWithTitle: LOCALIZATION(@"ShareWeb")
                                                                      image: [UIImage imageNamed: @"MainTouchShare"]
                                                           highlightedImage: [UIImage imageNamed: @"MainTouchShare_h"]];
    
    VLDContextSheetItem *item3 = [[VLDContextSheetItem alloc] initWithTitle: LOCALIZATION(@"Settings")
                                                                      image: [UIImage imageNamed: @"mainTouchSetting"]
                                                           highlightedImage: [UIImage imageNamed: @"mainTouchSetting_h"]];
    self.contextSheet = [[VLDContextSheet alloc] initWithItem:item1 item:item2 item:item3];
    self.contextSheet.delegate = self;

}

#pragma mark -- MainSearchBarDelegate

- (void)searchBarTapepMic:(MainSearchBar *)searchBar {
    [self voiceSearch];
}

- (void)voiceSearch {
    [self.view endEditing:YES];
    [BDVoiceRecognitionClientHelper new];
    // 创建语音识别界面，在其viewdidload方法中启动语音识别
    BDVRCustomRecognitonViewController *tmpAudioViewController = [[BDVRCustomRecognitonViewController alloc] init];
    
    tmpAudioViewController.delegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:tmpAudioViewController.view];
    
}

#pragma mark -- BDVRCustomRecognitonViewControllerDelegate

- (void)recongnitionController:(BDVRCustomRecognitonViewController *)controller logOutToManualResut:(NSString *)aResult {
    NSString *tmpString = self.searchBar.text;
    
    if (tmpString == nil || [tmpString isEqualToString:@""])
    {
        self.searchBar.text = aResult;
    }
    else
    {
        self.searchBar.text = [self.searchBar.text stringByAppendingString:aResult];
    }
    
    [self openNewWebWithSearchText:self.searchBar.text];
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
        
        [[AllAlertView sharedAlert] showWithTitle: LOCALIZATION(@"NetWorkCheck") alertType:AllAlertViewAlertTypeAlert height:100.0];
    }
}


@end









