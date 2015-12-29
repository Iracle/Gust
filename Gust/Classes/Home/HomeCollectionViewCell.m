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
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = HOME_COLLECTIONCELL_SHADOW_COLOR.CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.3;
        self.layer.cornerRadius = 3;
        
        _pageNameLabel = [[UILabel alloc] init];
        _pageNameLabel.center = CGPointMake(self.contentView.center.x, self.contentView.center.y);
        _pageNameLabel.bounds = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds) * 0.8, CGRectGetHeight(self.contentView.bounds));
        _pageNameLabel.textAlignment = NSTextAlignmentCenter;
        _pageNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _pageNameLabel.font = [UIFont systemFontOfSize:14];
        _pageNameLabel.textColor = HOME_COLLECTIONCELL_COLOR;
        [self.contentView addSubview:_pageNameLabel];
        
    }
    return self;
}

- (void)configCollectionViewCell:(NSDictionary *)dic
{
    [_pageImageView sd_setImageWithURL:[NSURL URLWithString:dic[ImageUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _pageImageView.layer.contentsGravity = kCAGravityCenter;
        _pageImageView.layer.contentsScale = [UIScreen mainScreen].scale * 0.3;
        _pageImageView.clipsToBounds = YES;
    }];
    _pageUrlString = dic[PageUrl];
    _pageNameLabel.text = dic[PageName];
                    
}

@end
