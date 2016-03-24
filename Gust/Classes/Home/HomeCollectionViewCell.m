//
//  HomeCollectionViewCell.m
//  Gust
//
//  Created by Iracle on 15/3/6.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "GustConfigure.h"
#import "GustStringHandle.h"

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _cellContentView = [[UIView alloc] initWithFrame:CGRectMake(COLLECTION_CONTENT_OFFSET, COLLECTION_CONTENT_OFFSET, COLLECTION_CONTENT_WIDTH, COLLECTION_CONTENT_WIDTH)];
        _cellContentView.backgroundColor = [UIColor whiteColor];
        _cellContentView.layer.shadowColor = HOME_COLLECTIONCELL_SHADOW_COLOR.CGColor;
        _cellContentView.layer.shadowOffset = CGSizeMake(0, 1);
        _cellContentView.layer.shadowOpacity = 0.8;
        _cellContentView.layer.cornerRadius = 3;
        [self.contentView addSubview:_cellContentView];
        
        _pageNameLabel = [[UILabel alloc] initWithFrame:_cellContentView.bounds];
        _pageNameLabel.backgroundColor = [UIColor clearColor];
        _pageNameLabel.textAlignment = NSTextAlignmentCenter;
        _pageNameLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightThin];
        _pageNameLabel.textColor = HOME_COLLECTIONCELL_COLOR;
        _pageNameLabel.numberOfLines = 0;  
      
        [_cellContentView addSubview:_pageNameLabel];
        
    }
    return self;
}

- (void)configCollectionViewCell:(NSDictionary *)dic
{
    _pageUrlString = dic[PageUrl];
    _pageNames = dic[PageName];
    NSString *webTitle =[dic[PageName] copy];
    _pageNameLabel.text =  [[GustStringHandle new] getTheCurrentWebName:webTitle];
                    
}



@end
