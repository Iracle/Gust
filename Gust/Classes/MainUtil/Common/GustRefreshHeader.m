//
//  GustRefreshHeader.m
//  Gust
//
//  Created by Iracle on 3/11/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import "GustRefreshHeader.h"
#import "Localisator.h"

@interface GustRefreshHeader()

@property CGFloat lastPosition;
@property CGFloat headerHeight;
@property CGFloat contentHeight;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerLabel;
@property BOOL isRefresh;

@end
@implementation GustRefreshHeader

- (void)addHeadView{
    self.pullBackOffset = 1.5;
    
    _isRefresh=NO;
    _lastPosition=0;
    _headerHeight=35;
    float scrollWidth= [UIApplication sharedApplication].keyWindow.bounds.size.width;
    float labelHeight=_headerHeight;

    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, -_headerHeight-10, scrollWidth, _headerHeight)];
    [_scrollView addSubview:_headerView];
    
    _headerLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollWidth, labelHeight)];
    [_headerView addSubview:_headerLabel];
    _headerLabel.textAlignment=NSTextAlignmentCenter;
    _headerLabel.text= LOCALIZATION(@"PullRelease");
    _headerLabel.font=[UIFont systemFontOfSize:14.0 weight:UIFontWeightThin];
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![@"contentOffset" isEqualToString:keyPath]){
        
        return;
        
    }
    _contentHeight=_scrollView.contentSize.height;
    
    if (_scrollView.dragging) {
        
        int currentPostion = _scrollView.contentOffset.y;
        if (!_isRefresh) {
            [UIView animateWithDuration:0.3 animations:^{
                if (currentPostion < - 85 * _pullBackOffset) {
                    
                    _headerLabel.text = LOCALIZATION(@"LooseRelease");
                    
                } else {
                    
                    _headerLabel.text = LOCALIZATION(@"PullRelease");
                }
            }];
        }
        
    }else{
        
        if ([_headerLabel.text isEqualToString: LOCALIZATION(@"LooseRelease")]) {
            [self beginRefreshing];
        }
    }
}

- (void)beginRefreshing{
    
    if (!_isRefresh) {
        _isRefresh=YES;
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.contentInset = UIEdgeInsetsMake(75 * 1.5, 0, 0, 0);
        }];
        
        _beginRefreshingBlock();
    }
    
}

- (void)endRefreshing{
    
    _isRefresh=NO;
    dispatch_async(dispatch_get_main_queue(), ^{
            _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _headerLabel.text= LOCALIZATION(@"PullRelease");
    });
}


@end
