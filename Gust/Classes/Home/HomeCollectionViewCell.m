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

        _cellContentView = [[UIView alloc] initWithFrame:CGRectMake(CollectionCell_OFFSET, CollectionCell_OFFSET, CollectionContentView_WIDTH, CollectionContentView_WIDTH)];
//        _cellContentView.bounds = CGRectMake(0, 0, CollectionContentView_WIDTH, CollectionContentView_WIDTH);
//        _cellContentView.center = CGPointMake(frame.origin.x, frame.origin.y);
        _cellContentView.backgroundColor = [UIColor whiteColor];
        _cellContentView.layer.shadowColor = HOME_COLLECTIONCELL_SHADOW_COLOR.CGColor;
        _cellContentView.layer.shadowOffset = CGSizeMake(0, 1);
        _cellContentView.layer.shadowOpacity = 0.8;
        _cellContentView.layer.cornerRadius = 3;
        [self.contentView addSubview:_cellContentView];
        
        _pageNameLabel = [[UILabel alloc] initWithFrame:_cellContentView.bounds];
        _pageNameLabel.backgroundColor = [UIColor clearColor];
        _pageNameLabel.textAlignment = NSTextAlignmentCenter;
        _pageNameLabel.font = [UIFont systemFontOfSize:14];
        _pageNameLabel.textColor = HOME_COLLECTIONCELL_COLOR;
        _pageNameLabel.numberOfLines = 0;
        [_cellContentView addSubview:_pageNameLabel];
        
    }
    return self;
}

- (void)configCollectionViewCell:(NSDictionary *)dic
{
    _pageUrlString = dic[PageUrl];
    NSString *webTitle =[dic[PageName] copy];
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@"【" withString:@""];
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@"】" withString:@""];
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@"《" withString:@""];
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@"》" withString:@""];
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self convertToInt:webTitle] > 10) {
        if ([self convertToInt:webTitle] > webTitle.length) {
            NSString *resultTitle = [NSString stringWithFormat:@"%@%@",[webTitle substringToIndex:5], @"..."];
            _pageNameLabel.text = resultTitle;
        } else {
            NSString *resultTitle = [NSString stringWithFormat:@"%@%@",[webTitle substringToIndex:10], @"..."];
            _pageNameLabel.text = resultTitle;
        }
    } else {
        _pageNameLabel.text = webTitle;
    }
                    
}

- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

@end
