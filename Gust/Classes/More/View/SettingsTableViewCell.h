//
//  SettingsTableViewCell.h
//  Gust
//
//  Created by Iracle Zhang on 1/18/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *webTitle;
@property (nonatomic, strong) UIImageView *leftImage;

- (void)configCell:(NSString *)webTitle;

@end
