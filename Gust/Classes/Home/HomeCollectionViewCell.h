//
//  HomeCollectionViewCell.h
//  Gust
//
//  Created by Iracle on 15/3/6.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *pageNameLabel;
@property (nonatomic, copy) NSString *pageNames;
@property (nonatomic, copy) NSString *pageUrlString;
@property (nonatomic, strong) UIView *cellContentView;

- (void)configCollectionViewCell:(NSDictionary *)dic;

@end
