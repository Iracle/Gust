//
//  GustWebViewController.m
//  Gust
//
//  Created by Iracle on 15/3/5.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "GustWebViewController.h"
#import <OTMWebView/OTMWebView.h>
#import <OTMWebView/OTMWebViewProgressBar.h>
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

#import "GustAlertView.h"
//input record
#import "InputRecord.h"
#import "TopSites.h"
#import "CoreDataManager.h"
#import "MainSearchBarTextManage.h"
//multiTab
#import "MultiTabView.h"

@interface GustWebViewController ()< OTMWebViewDelegate, MainTouchViewDelegate, UIScrollViewDelegate, VLDContextSheetDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

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
@property (nonatomic, strong) NSLayoutConstraint *searchBarWidthConstraint;
//save input record array
@property (nonatomic, strong) NSMutableArray *inputRecordArray;
//save search record result array
@property (nonatomic, strong) NSMutableArray *inputRecordSearchResultArray;
@property (nonatomic, strong) UIButton *cancelButton;
//save currentSearchEngin
@property (nonatomic, strong) NSString *currentSearchEnginString;

//multiTab
@property (nonatomic, strong) MultiTabView *mutiTabView;
@property (nonatomic, strong) NSMutableArray *currentMutiTabArray;

@property (nonatomic, strong) UIImage *currentTabPageImage;

@end

@implementation GustWebViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        _webView = [[OTMWebView alloc] initWithFrame:self.view.bounds];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

- (MainTouchView *)touchView
{
    if (!_touchView) {
        _touchView = [[MainTouchView alloc] init];
        _touchView.bounds = CGRectMake(0, 0, MainTouchViewRadius, MainTouchViewRadius);
        _touchView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - MainTouchViewRadius);
        _touchView.delegate = self;
        
    }
    return _touchView;
}

- (MainSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar.delegate = self;
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

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.alpha = HomePageCancelButtonAlpha;
        _cancelButton.hidden = YES;
        
        
    }
    return _cancelButton;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    [self getCurrentSearchEnginSave];
    
    self.navigationController.hidesBarsWhenVerticallyCompact = YES;
    [self.view addSubview:self.webView];
    [self gustFollowRollingScrollView: self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];

    [self.view addSubview:self.touchView];
    [self.navigationController.navigationBar addSubview:self.searchBar];

    self.progressBar = [[OTMWebViewProgressBar alloc]init];
    CGFloat progressBarHeight = 1.5;
    self.progressBar.frame = CGRectMake(0.0, CGRectGetMaxY(self.navigationController.navigationBar.bounds) - progressBarHeight, CGRectGetWidth(self.navigationController.navigationBar.bounds), progressBarHeight);
    self.progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.progressBar.tintColor = [UIColor colorWithRed:0.013 green:0.763 blue:0.634 alpha:1.000];
    [self.navigationController.navigationBar addSubview:self.progressBar];

    self.contextSheet = [[VLDContextSheet alloc] initWithItem:@"书签/历史" item:@"分享" item:@"设置"];
    self.contextSheet.delegate = self;
    [self.navigationController.navigationBar addSubview:self.cancelButton];
    [self.view setNeedsUpdateConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchBarTextChanged:) name:@"UITextFieldTextDidChangeNotification" object:_searchBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataMainTouchViewLocation:) name:NotificationUpdateMainTouchViewLocation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseDefautSeachEngin:) name:NotificationChangeDefautSearchEngin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openWebPageInNewTab:) name:@"NotificationOpenPageInNewTab" object:nil];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return NO;
    }
    if (textField.text.length > 0) {
        //pravicy mode
        NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
        if (![[privacyDefaults objectForKey:IsGustPrivacy] boolValue]) {
            
            NSMutableDictionary *inputRecordDic= [NSMutableDictionary dictionary];
            [inputRecordDic setObject:textField.text forKey:InputRecordString];
            //if the InputRecord is exist
            NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[InputRecord entityName] predicateString:[NSString stringWithFormat:@"inputString = '%@'",textField.text]];
            if (resultsArray.count < 1) {
                [CoreDataManager insertObjectWithParameter:inputRecordDic entityName:[InputRecord entityName]];}
        }
    }
        
    NSMutableString *returnString = [MainSearchBarTextManage manageTextFieldText:textField.text];
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
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.text = nil;
    _isInputingState = YES;
    if (!_inputHistorisTableView) {
        
        [self loadInputHistorisTableView];
    }    [self loadInputHistoryData];
    [self setupSearchBarAnimation];
    return YES;
}
- (void)loadInputHistorisTableView {
    _inputHistorisTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 700, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - 20)];
    _inputHistorisTableView.delegate = self;
    _inputHistorisTableView.dataSource = self;
    _inputHistorisTableView.alpha = 0.0;
    [self.view addSubview:_inputHistorisTableView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _inputHistorisTableView.alpha = 1.0;
        _inputHistorisTableView.frame = CGRectMake(0,CGRectGetHeight(self.navigationController.navigationBar.bounds) + 20, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - 20);
    }];
    
}

- (void)loadWebWithUrlString:(NSString *)urlString
{
    //down hidden hisTable
    [UIView animateWithDuration:0.3 animations:^{
        _inputHistorisTableView.alpha = 10.0;
        _inputHistorisTableView.frame = CGRectMake(0, 700, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 70);
    }];

    //clean searchBar state
    self.searchBar.text = nil;
    _isInputingState = NO;
    [self setupSearchBarAnimation];
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
    
    [self.inputHistorisTableView reloadData];
}

- (void)setupSearchBarAnimation
{
    [self.view setNeedsUpdateConstraints];
    if (_isInputingState) {
        _cancelButton.hidden = NO;
        if (_cancelButton.alpha == HomePageCancelButtonAlpha) {
            _cancelButton.alpha = 0.0;
        }
    }
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:0 animations:^{
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!_isInputingState) {
            
            _cancelButton.hidden = YES;
            [_inputHistorisTableView removeFromSuperview];
            _inputHistorisTableView = nil;
        }
    }];
    
}

- (void)cancelButtonTaped:(UIButton *)sender
{
    [self.searchBar resignFirstResponder];
    _searchBar.text = nil;
    _isInputingState = NO;
    [self setupSearchBarAnimation];
    
    [UIView animateWithDuration:0.3 animations:^{
        _inputHistorisTableView.alpha = 10.0;
        _inputHistorisTableView.frame = CGRectMake(0, 700, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.navigationController.navigationBar.bounds) - 20);
    }];
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
    //Privicy mode
    NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
    if (![[privacyDefaults objectForKey:IsGustPrivacy] boolValue]) {
        
        NSArray *rusultsArray = [CoreDataManager searchObjectWithEntityName:[History entityName] predicateString:[NSString stringWithFormat:@"pageName = '%@'",currentDocumentTitle] ];
        if (rusultsArray.count == 0 && currentDocumentTitle.length > 0) {
            
            [CoreDataManager insertObjectWithParameter:self.historyDic entityName:[History entityName]];
        }
    }
    self.searchBar.text = currentDocumentTitle;

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
}

#pragma mark-- MainTouchViewDelegate
- (void)SingleTapMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
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
    NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
    if ([[privacyDefaults objectForKey:IsGustPrivacy] boolValue]) {
        GustAlertView *alertView = [[GustAlertView alloc] init];
        [alertView showInView:self.view type:0 title:@"隐私模式不能添加书签!"];
        return;
    }
    GustAlertView *alertView = [[GustAlertView alloc] init];
    NSString *bookmark = [self.bookmarkDic objectForKey:PageName];
    NSArray *resultsArray = [CoreDataManager searchObjectWithEntityName:[Bookmark entityName] predicateString:[NSString stringWithFormat:@"pageName = '%@'",bookmark] ];
    if (resultsArray.count < 1 && [self.bookmarkDic[PageName] length] > 0 ) {
        
        [CoreDataManager insertObjectWithParameter:self.bookmarkDic entityName:[Bookmark entityName]];
        [alertView showInView:self.view type:1 title:@"添加书签成功"];
    } else {
        [alertView showInView:self.view type:1 title:@"书签已存在"];
    }

}
- (void)SwipeDownMainTouchView:(MainTouchView *)touchView withGesture:(UIGestureRecognizer *)gestureRecognizer
{
    [self.searchBar becomeFirstResponder];
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
    
        
    } else if ([item.title isEqualToString:@"分享"]){
        
        if (!self.historyDic[PageUrl]) {
            return;
        }
        
        NSString *textToShare = [NSString stringWithFormat:@"%@%@",ShareText,self.historyDic[PageName]];
        UIImage *imageToShare = [self getCurrentViewShotImage];
        NSURL *urlToShare = [NSURL URLWithString:self.historyDic[PageUrl]];
        
        NSArray *activityItems = @[textToShare,imageToShare, urlToShare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            _contextSheet.hidden = NO;
            _touchView.hidden = NO;
        };
        
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact];
        [self presentViewController:activityVC animated:YES completion:nil];
        
    } else{
        NSUserDefaults *privacyDefaults = [NSUserDefaults standardUserDefaults];
        if ([[privacyDefaults objectForKey:IsGustPrivacy] boolValue]) {
            GustAlertView *alertView = [[GustAlertView alloc] init];
            [alertView showInView:self.view type:0 title:@"处于隐私模式不能访问!"];
            return;
        }

        HistoryAndBookmarkViewController *hisBookVC = [[HistoryAndBookmarkViewController alloc] init];
        hisBookVC.getUrlValueBlock = ^(NSString *value){
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:value]]];
            
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *clearAllTopsiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearAllTopsiteButton setTitle:@"清空输入历史" forState:UIControlStateNormal];
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
    [self.searchBar resignFirstResponder];
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
    [self.searchBar resignFirstResponder];
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


@end
