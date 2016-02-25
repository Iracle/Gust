//
//  MutiTabCollectionViewCell.m
//  Gust
//
//  Created by Iracle on 4/26/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import "MutiTabCollectionViewCell.h"
#import "GustConfigure.h"

@implementation MutiTabCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        _webPageShotImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        _webPageShotImageView.backgroundColor = [UIColor orangeColor];
        _webPageShotImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_webPageShotImageView];
        
        _webTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(_webPageShotImageView.bounds), 25)];
        _webTitleLabel.backgroundColor = [UIColor blackColor];
        _webTitleLabel.textAlignment = NSTextAlignmentCenter;
        _webTitleLabel.font = [UIFont systemFontOfSize:14];
        _webTitleLabel.textColor = [UIColor whiteColor];
        _webTitleLabel.layer.shadowRadius = 2;
        _webTitleLabel.layer.shadowOpacity = 0.8;
        _webTitleLabel.layer.shadowOffset = CGSizeMake(0, 2);
        _webTitleLabel.layer.shadowColor = [UIColor colorWithRed:0.347 green:0.347 blue:0.347 alpha:1.0].CGColor;
        [_webPageShotImageView addSubview:_webTitleLabel];
        
        _deleteTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteTabButton.bounds = CGRectMake(0, 0, 30, 30);
        _deleteTabButton.center = CGPointMake(CGRectGetMidX(_webPageShotImageView.frame), CGRectGetMaxY(_webPageShotImageView.frame) - CGRectGetWidth(_deleteTabButton.bounds) / 1.7);
        [_deleteTabButton setBackgroundImage:IMAGENAMED(@"MutiTabdelete") forState:UIControlStateNormal];
        _deleteTabButton.layer.cornerRadius = 15;
        _deleteTabButton.layer.borderWidth = 1.5;
        _deleteTabButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _deleteTabButton.layer.shadowColor = [UIColor colorWithRed:0.3808 green:0.3808 blue:0.3808 alpha:1.0].CGColor;
        _deleteTabButton.layer.shadowOpacity = 0.7;
        _deleteTabButton.layer.shadowRadius = 3.0;
        _deleteTabButton.layer.shadowOffset = CGSizeMake(1.5, 2);
        [_webPageShotImageView addSubview:_deleteTabButton];
        
    }
    return self;
}

- (void)configcell:(NSDictionary *)dic
{
    _webPageShotImageView.image = dic[CurrentViewShot];
    _webTitleLabel.text = dic[PageName];
}








@end
