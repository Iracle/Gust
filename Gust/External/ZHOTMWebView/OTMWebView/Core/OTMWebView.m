//
// OTMWebView.m
//
// Copyright (c) 2014 Ryan Coffman
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <objc/runtime.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <SafariServices/SafariServices.h>

#import "OTMWebView.h"
#import "OTMWebViewURLProtocol.h"
#import "OTMWebViewProgressTracker.h"
#import "AHKActionSheet.h"
#import "Localisator.h"


NSString *const OTMWebViewElementTagNameKey = @"tagName";
NSString *const OTMWebViewElementHREFKey = @"href";
NSString *const OTMWebViewElementSRCKey = @"src";
NSString *const OTMWebViewElementTitleKey = @"title";
NSString *const OTMWebViewElementAltKey = @"alt";
NSString *const OTMWebViewElementIDKey = @"id";
NSString *const OTMWebViewElementDocumentURL = @"documentURL";

NSString *const kOTMWebViewURLScheme = @"OTMWebView";

@interface OTMWebView () <UIWebViewDelegate, OTMWebViewProgressTrackerDelegate, UIGestureRecognizerDelegate>
+ (NSString *)injectionScript;
+ (NSString *)contextMenuInjectionScript;
@property (weak, nonatomic) id <UIWebViewDelegate> otm_delegate;
@property (strong, nonatomic) OTMWebViewProgressTracker *progressTracker;
@property (copy, nonatomic) NSString *documentTitle;
@property (strong, nonatomic) UILongPressGestureRecognizer *contextMenuGestureRecognizer;
@property (nonatomic, strong) AHKActionSheet *actionSheet;
@property BOOL isLongPress;
- (void)contextMenuGestureRecognizerAction:(UILongPressGestureRecognizer *)gestureRecognizer;
@end

@implementation OTMWebView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (void)load
{
    // swap the delegate property with our own private one,so we can internally set the delegate to ourselves,
    // and then forward the calls to the public delegate.
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oldMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
        Method newMethod = class_getInstanceMethod([self class], @selector(setOtm_delegate:));
        
        method_exchangeImplementations(oldMethod, newMethod);
        
        oldMethod = class_getInstanceMethod([self class], @selector(delegate));
        newMethod = class_getInstanceMethod([self class], @selector(otm_delegate));
        
        method_exchangeImplementations(oldMethod, newMethod);
    });
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

+ (NSString *)injectionScript
{
    static dispatch_once_t onceToken;
    static NSString *script;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"OTMWebView" ofType:@"js"];
        NSError *error;
        script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"unable to load injection script: %@", error.localizedDescription);
        }
    });
    
    return script;
}

- (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSURLProtocol registerClass:[OTMWebViewURLProtocol class]];
    });
    
    self.otm_delegate = self;
    self.progressTracker = [[OTMWebViewProgressTracker alloc]init];
    self.progressTracker.delegate = self;
    self.contextMenuGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(contextMenuGestureRecognizerAction:)];
    self.contextMenuGestureRecognizer.minimumPressDuration = 0.25;
    self.contextMenuGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.contextMenuGestureRecognizer];
    
    self.customContextMenuEnabled = YES;
}

-(void)setDelegate:(id<UIWebViewDelegate>)delegate {
    
    [super setDelegate:delegate];
}

-(id<UIWebViewDelegate>)delegate {
    
    return [super delegate];
}

- (void)setDocumentTitle:(NSString *)documentTitle
{
    _documentTitle = documentTitle;
    
    if ([self.delegate respondsToSelector:@selector(webView:documentTitleDidChange:)]) {
        [(id < OTMWebViewDelegate >)self.delegate webView : self documentTitleDidChange : documentTitle];
    }
}

- (double)progress
{
    return self.progressTracker.progress;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

/*
 -(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
 
 return YES;
 }
 */
#pragma mark - Web View Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme compare:kOTMWebViewURLScheme options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        if ([request.URL.host isEqualToString:@"onReadyStateChange"]) {
            [self.progressTracker finishProgress];
        }
        else if ([request.URL.host isEqualToString:@"setDocumentTitle"]) {
            self.documentTitle = request.URL.path.lastPathComponent;
        }
        
        return NO;
    }
    
    if (self.isLongPress) {
        self.isLongPress = NO;
        return NO;
    }
    
    NSAssert([request isKindOfClass:[NSMutableURLRequest class]], @"request is not mutable");
    
    NSMutableURLRequest *mutableRequest = (NSMutableURLRequest *)request;
    
    mutableRequest.URL = OTMWebViewURLByAddingWebViewIdentifier(mutableRequest.URL, (OTMWebView *)webView);
    mutableRequest.mainDocumentURL = OTMWebViewURLByAddingWebViewIdentifier(mutableRequest.mainDocumentURL, (OTMWebView *)webView);
    
    [OTMWebViewURLProtocol setProperty:self forKey:kOTMWebViewURLProtocolHandleRequestkey inRequest:mutableRequest];
    [OTMWebViewURLProtocol setProperty:self forKey:kOTMWebViewURLProtocolMainRequestKey inRequest:mutableRequest];
    
    BOOL shouldLoadRequest = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        shouldLoadRequest = [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    BOOL startProgress = YES;
    
    if (request.URL.fragment && navigationType != UIWebViewNavigationTypeReload) {
        NSString *nonFragmentUrl1 = [request.URL.absoluteString substringToIndex:[request.URL.absoluteString rangeOfString:@"#"].location];
        
        NSRange range = [webView.request.URL.absoluteString rangeOfString:@"#"];
        
        NSString *nonFragmentUrl2 = range.location == NSNotFound ? webView.request.URL.absoluteString : [webView.request.URL.absoluteString substringToIndex:range.location];
        if ([nonFragmentUrl1 isEqualToString:nonFragmentUrl2]) {
            startProgress = NO;
        }
    }
    
    if ([NSURLProtocol propertyForKey:kOTMWebViewURLProtocolRedirectRequestKey inRequest:request]) {
        startProgress = NO;
    }
    
    if (shouldLoadRequest && startProgress) {
        if ([mutableRequest.URL isEqual:mutableRequest.mainDocumentURL] || mutableRequest.mainDocumentURL == nil) {
            [self.progressTracker startProgress];
        }
    }
    
    return shouldLoadRequest;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *res = [webView stringByEvaluatingJavaScriptFromString:[[self class]injectionScript]];
    
    if (res == nil) {
        NSLog(@"Failed to run injection script");
    }
    if (self.customContextMenuEnabled) {
        NSString *res = [webView stringByEvaluatingJavaScriptFromString:[[self class]contextMenuInjectionScript]];
        if (res == nil) {
            NSLog(@"Failed to run context menu script");
        }
    }
    
//    self.documentTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    NSString *firstImageUrl = [webView stringByEvaluatingJavaScriptFromString:@"var images = document.getElementsByTagName('src');srcs[0].src.toString();"];
//
//
//     NSLog(@"firstImageUrl:%@",firstImageUrl);
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    if ([readyState isEqualToString:@"complete"] || readyState == nil) {
        [self.progressTracker finishProgress];
    }
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.progressTracker finishProgress];
    
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

#pragma mark - Progress Tracker Delegate

- (void)progressTrackerProgressDidStart:(OTMWebViewProgressTracker *)tracker
{
    if ([self.delegate respondsToSelector:@selector(webViewProgressDidStart:)]) {
        [(id < OTMWebViewDelegate >)self.delegate webViewProgressDidStart: self];
    }
}

- (void)progressTrackerProgressDidFinish:(OTMWebViewProgressTracker *)tracker
{
    if ([self.delegate respondsToSelector:@selector(webViewProgressDidFinish:)]) {
        [(id < OTMWebViewDelegate >)self.delegate webViewProgressDidFinish: self];
    }
}

- (void)progressTracker:(OTMWebViewProgressTracker *)progressTracker progressDidChange:(double)progress
{
    if ([self.delegate respondsToSelector:@selector(webView:progressDidChange:)]) {
        [(id < OTMWebViewDelegate >)self.delegate webView : self progressDidChange : progress];
    }
}
#pragma mark --ActionSheetTaped
//单击ActionSheet的选项
- (void)TapCellWithButtonIndex:(NSInteger )buttonIndex withDictionary:(NSDictionary *)elementItemMap
{
    __block NSDictionary *menuItemElement;
    __block OTMWebViewContextMenuItem *menuItem;
    
    __block NSInteger count = 0;
    
    [elementItemMap enumerateKeysAndObjectsUsingBlock: ^(NSDictionary *element, NSArray *items, BOOL *stop) {
        count += items.count;
        
        if (buttonIndex < count) {
            menuItem = items[buttonIndex + (items.count - count)];
            menuItemElement = element;
            *stop = YES;
        }
    }];
    
    //执行block
    if (menuItem && menuItem.actionHandler) {
        menuItem.actionHandler(self, menuItemElement);
    }
    
}

#pragma mark - Context Menu

+ (NSString *)contextMenuInjectionScript
{
    static dispatch_once_t onceToken;
    static NSString *script;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"OTMWebView+ContextMenu" ofType:@"js"];
        NSError *error;
        script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"unable to load context menu script: %@", error.localizedDescription);
        }
    });
    
    return script;
}

- (void)setCustomContextMenuEnabled:(BOOL)customContextMenuEnabled
{
    self.contextMenuGestureRecognizer.enabled = customContextMenuEnabled;
}

- (BOOL)customContextMenuEnabled
{
    return self.contextMenuGestureRecognizer.enabled;
}

//长按链接
- (void)contextMenuGestureRecognizerAction:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [gestureRecognizer locationInView:self];
        
        CGFloat windowWidth = [self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"].floatValue;
        CGFloat windowHeight = [self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"].floatValue;
        
        UIEdgeInsets inset = self.scrollView.contentInset;
        
        CGFloat width = CGRectGetWidth(self.frame) - inset.left - inset.right;
        CGFloat height = CGRectGetHeight(self.frame) - inset.top - inset.bottom;
        
        CGFloat widthScale = windowWidth / width;
        CGFloat heightScale = windowHeight / height;
        
        location.x = (location.x - inset.left) * widthScale;
        location.y = (location.y - inset.top) * heightScale;
        
        NSString *jsonString = [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"otm_elementsAtPoint(%li, %li)", (long)location.x, (long)location.y]];
        
        NSArray *elements = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        self.actionSheet = [[AHKActionSheet alloc] init];
        NSMutableArray *selectedElements = [NSMutableArray array];
        NSMutableDictionary *elementItemMap = [NSMutableDictionary dictionary];
        //判断链接类型，通过block回调
        [elements enumerateObjectsUsingBlock: ^(NSDictionary *element, NSUInteger idx, BOOL *stop) {
            NSArray *menuItems;
            
            if ([self.delegate respondsToSelector:@selector(webView:contextMenuItemsForElement:defaultMenuItems:)]) {
                menuItems = [(id < OTMWebViewDelegate >)self.delegate webView : self contextMenuItemsForElement : element defaultMenuItems : menuItems];
            }
            else {
                menuItems = [[self class]defaultContextMenuItemsForElement:element];
            }
            
            if (menuItems) {
                //block回调返回，当前长按链接类型对应的功能菜单选项
                [menuItems enumerateObjectsUsingBlock: ^(OTMWebViewContextMenuItem *item, NSUInteger idx, BOOL *stop) {
                    NSString *title = item.titleForElement ? item.titleForElement(self, element) : item.title;
                    __weak typeof(self) weakSelf = self;
                    [self.actionSheet addButtonWithTitle:title type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet, NSString *row) {
                        NSInteger buttonIndex = [row integerValue];
                        [weakSelf TapCellWithButtonIndex:buttonIndex withDictionary:elementItemMap];
                        
                        
                    }];
                }];
                
                [selectedElements addObject:element];
                
                elementItemMap[element] = menuItems;
            }
        }];
        
        if (selectedElements.count > 0) {
            [self.actionSheet show];
            self.isLongPress = YES;
        }
        
        gestureRecognizer.enabled = NO;
        gestureRecognizer.enabled = YES;
    }
}

+ (NSArray *)defaultContextMenuItemsForElement:(NSDictionary *)element
{
    if ([element[OTMWebViewElementTagNameKey] isEqualToString:@"A"]) {
        return @[[[self class] openContextMenuItem], [[self class]copyURLContextMenuItem]];
    }
    else if ([element[OTMWebViewElementTagNameKey] isEqualToString:@"IMG"]) {
        return @[[[self class]openContextMenuItem], [[self class]saveImageContextMenuItem], [[self class]copyImageContextMenuItem], [[self class]copyURLContextMenuItem]];
    }
    
    return nil;
}
//新标签打开网页
+ (OTMWebViewContextMenuItem *)openContextMenuItem
{
    static OTMWebViewContextMenuItem *openItem;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        openItem = [[OTMWebViewContextMenuItem alloc]initWithTitle:nil actionHandler: ^(OTMWebView *webView, NSDictionary *element) {
            if ([element[OTMWebViewElementTagNameKey] isEqualToString:@"A"]) {
                
                NSString *elementId = element[OTMWebViewElementIDKey];
                [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('%@').dispatchEvent(new Event('click'))", elementId]];
                //notification gustWebController open page in new Tab
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationOpenPageInNewTab" object:self];

            }
            else if ([element[OTMWebViewElementTagNameKey] isEqualToString:@"IMG"]) {
                NSURL *imageURL = [NSURL URLWithString:element[OTMWebViewElementSRCKey] relativeToURL:[NSURL URLWithString:element[OTMWebViewElementDocumentURL]]];
                //新窗口图片打开网页.
                [webView loadRequest:[NSURLRequest requestWithURL:imageURL]];
                
            }
        }];
        
        openItem.titleForElement = ^NSString *(OTMWebView *webView, NSDictionary *element) {
            NSString *tagName = element[OTMWebViewElementTagNameKey];
            
            if ([tagName isEqualToString:@"A"]) {
                return LOCALIZATION(@"BackOpenLink");
            }
            else if ([tagName isEqualToString:@"IMG"]) {
                return LOCALIZATION(@"OpenImage");
            }
            
            return nil;
        };
    });
    
    return openItem;
}
//保存图片
+ (OTMWebViewContextMenuItem *)saveImageContextMenuItem
{
    static OTMWebViewContextMenuItem *saveImageItem;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        saveImageItem = [[OTMWebViewContextMenuItem alloc]initWithTitle: LOCALIZATION(@"SaveImage") actionHandler: ^(OTMWebView *webView, NSDictionary *element) {
            NSString *dataURL = element[OTMWebViewElementSRCKey];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataURL]];
            UIImage *image = [[UIImage alloc]initWithData:data scale:[UIScreen mainScreen].scale];
            
            UIImageWriteToSavedPhotosAlbum(image, nil, NULL, nil);
        }];
    });
    
    return saveImageItem;
}
//复制链接
+ (OTMWebViewContextMenuItem *)copyURLContextMenuItem
{
    static OTMWebViewContextMenuItem *copyLinkItem;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        copyLinkItem = [[OTMWebViewContextMenuItem alloc]initWithTitle:nil actionHandler: ^(OTMWebView *webView, NSDictionary *element) {
            NSString *link = nil;
            
            NSString *tagName = element[OTMWebViewElementTagNameKey];
            
            if ([tagName isEqualToString:@"A"]) {
                link = element[OTMWebViewElementHREFKey];
            }
            else if ([tagName isEqualToString:@"IMG"]) {
                link = element[OTMWebViewElementSRCKey];
            }
            
            [UIPasteboard generalPasteboard].URL = [NSURL URLWithString:link relativeToURL:[NSURL URLWithString:element[OTMWebViewElementDocumentURL]]];
        }];
        
        copyLinkItem.titleForElement = ^NSString * (OTMWebView *webView, NSDictionary *element) {
            NSString *tagName = element[OTMWebViewElementTagNameKey];
            
            if ([tagName isEqualToString:@"A"]) {
                return LOCALIZATION(@"CopyLink");
            }
            else if ([tagName isEqualToString:@"IMG"]) {
                return LOCALIZATION(@"CopyImageLink");
            }
            return nil;
        };
    });
    
    return copyLinkItem;
}
//复制图片
+ (OTMWebViewContextMenuItem *)copyImageContextMenuItem
{
    static OTMWebViewContextMenuItem *copyImageContextMenuItem;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        copyImageContextMenuItem = [[OTMWebViewContextMenuItem alloc]initWithTitle: LOCALIZATION(@"CopyImage") actionHandler: ^(OTMWebView *webView, NSDictionary *element) {
            
            NSString *dataURL = element[OTMWebViewElementSRCKey];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataURL]];
            
            UIImage *image = [[UIImage alloc]initWithData:data scale:[UIScreen mainScreen].scale];
            
            NSURL *imageURL = [NSURL URLWithString:element[OTMWebViewElementSRCKey] relativeToURL:[NSURL URLWithString:element[OTMWebViewElementDocumentURL]]];
            
            [[UIPasteboard generalPasteboard]setItems:@[@{
                                                            (__bridge NSString *)kUTTypePNG: UIImagePNGRepresentation(image),
                                                            (__bridge NSString *)kUTTypeURL: imageURL
                                                            }]];
        }];
    });
    
    return copyImageContextMenuItem;
}
@end

