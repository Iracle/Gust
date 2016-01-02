//
//  HomeCollectionViewCell.m
//  Gust
//
//  Created by Iracle on 15/3/6.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "GustConfigure.h"
#import "UIImageView+WebCache.h"

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _cellContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, CollectionContentView_WIDTH, CollectionContentView_WIDTH)];
//        _cellContentView.bounds = CGRectMake(0, 0, CollectionContentView_WIDTH, CollectionContentView_WIDTH);
//        _cellContentView.center = CGPointMake(frame.origin.x, frame.origin.y);
        _cellContentView.backgroundColor = [UIColor whiteColor];
        _cellContentView.layer.shadowColor = HOME_COLLECTIONCELL_SHADOW_COLOR.CGColor;
        _cellContentView.layer.shadowOffset = CGSizeMake(0, 1);
        _cellContentView.layer.shadowOpacity = 0.3;
        _cellContentView.layer.cornerRadius = 3;
        [self.contentView addSubview:_cellContentView];
        
        _pageNameLabel = [[UILabel alloc] initWithFrame:_cellContentView.bounds];
        _pageNameLabel.backgroundColor = [UIColor clearColor];
        _pageNameLabel.textAlignment = NSTextAlignmentCenter;
        _pageNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _pageNameLabel.font = [UIFont systemFontOfSize:14];
        _pageNameLabel.textColor = HOME_COLLECTIONCELL_COLOR;
        [_cellContentView addSubview:_pageNameLabel];
        
    }
    return self;
}

- (void)configCollectionViewCell:(NSDictionary *)dic
{
    _pageUrlString = dic[PageUrl];
    _pageNameLabel.text = dic[PageName];
                    
}

@end
