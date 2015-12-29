//
//  GuideViewController.m
//  Gust
//
//  Created by Iracle on 15/5/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * 4, CGRectGetHeight(self.view.bounds));
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < 4; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) * i, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i + 1]];
        imageView.tag = 120;
        [_scrollView addSubview:imageView];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger ctx = _scrollView.contentOffset.x  - CGRectGetWidth(self.view.bounds) * 3;
    if (ctx > 30) {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:123];
        [UIView animateWithDuration:5 animations:^{
            self.view.alpha = 0.1;
            _scrollView.alpha = 0.1;
            imageView.alpha = 0.1;
        } completion:^(BOOL finished) {
            
            if (finished) {
                [self performSelector:@selector(dismissCurrentViewController) withObject:nil afterDelay:0.5];
            }

            
        }];
    }
}

- (void)dismissCurrentViewController{
    /*
    NSUserDefaults *userDetaults = [NSUserDefaults standardUserDefaults];
    [userDetaults setObject:@"YES" forKey:@"Guide"];
    [userDetaults synchronize];
     */
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];

}


@end
