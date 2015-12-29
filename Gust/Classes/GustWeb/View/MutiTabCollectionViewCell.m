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
        _webPageShotImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        _webPageShotImageView.backgroundColor = [UIColor orangeColor];
        _webPageShotImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_webPageShotImageView];
        
        _webTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(_webPageShotImageView.bounds), 25)];
        _webTitleLabel.backgroundColor = [UIColor blackColor];
        _webTitleLabel.textAlignment = NSTextAlignmentCenter;
        _webTitleLabel.font = [UIFont systemFontOfSize:14];
        _webTitleLabel.textColor = [UIColor whiteColor];
        _webTitleLabel.text = @"百度一下";
        [_webPageShotImageView addSubview:_webTitleLabel];
        
        _deleteTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteTabButton.bounds = CGRectMake(0, 0, 30, 30);
        _deleteTabButton.center = CGPointMake(CGRectGetMidX(_webPageShotImageView.frame), CGRectGetMaxY(_webPageShotImageView.frame) - CGRectGetWidth(_deleteTabButton.bounds));
        _deleteTabButton.layer.cornerRadius = 15;
        _deleteTabButton.backgroundColor = [UIColor redColor];
        _deleteTabButton.layer.borderWidth = 3;
        _deleteTabButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _deleteTabButton.layer.shadowColor = [UIColor blackColor].CGColor;
        _deleteTabButton.layer.shadowOpacity = 0.7;
        _deleteTabButton.layer.shadowOffset = CGSizeMake(3, 3);
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
