//
//  MutiTabCollectionViewCell.h
//  Gust
//
//  Created by Iracle on 4/26/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MutiTabCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *webTitleLabel;
@property (nonatomic, strong) UIImageView *webPageShotImageView;
@property (nonatomic, strong) UIButton *deleteTabButton;

- (void)configcell:(NSDictionary *)dic;
@end
