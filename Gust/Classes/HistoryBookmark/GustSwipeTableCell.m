//
//  GustSwipeTableCell.m
//  Gust
//
//  Created by Iracle Zhang on 16/1/12.
//  Copyright © 2016年 Iralce. All rights reserved.
//

#import "GustSwipeTableCell.h"
#import "GustConfigure.h"
@interface GustSwipeTableCell ()

@property (nonatomic, strong) UIView *cellBackgroundView;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UILabel *webTitle;


@end

@implementation GustSwipeTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCellUserInterface];
    }
    return self;
}

- (void)setupCellUserInterface {
    self.backgroundColor = [UIColor clearColor];
    _cellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 2.0, SCREEN_WIDTH, 52.0)];
    _cellBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_cellBackgroundView];
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(15.0, 13.5, 25.0, 25.0)];
    [_cellBackgroundView addSubview:_leftImage];
    
    _webTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 15.0, 11.0, SCREEN_WIDTH / 1.5, 30.0)];
    _webTitle.textColor = [UIColor colorWithRed:150 /255.0 green:150 /255.0 blue:150 /255.0 alpha:1.0];
    _webTitle.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
    [_cellBackgroundView addSubview:_webTitle];
    
}

- (void)configCell:(NSString *)webTitle {
    _webTitle.text = [webTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)isBookmarks:(BOOL)isBook {
    if (isBook) {
        _leftImage.image = IMAGENAMED(@"webBookmark");
        
    } else {
        _leftImage.image = IMAGENAMED(@"webhistory");

    }
}

@end





