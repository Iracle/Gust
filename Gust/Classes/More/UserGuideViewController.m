//
//  UserGuideViewController.m
//  Gust
//
//  Created by Iracle Zhang on 16/4/10.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "UserGuideViewController.h"
#import "Localisator.h"

@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = LOCALIZATION(@"UserGuide");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://iracleme.com/gusthelp/"]]];
}



@end
