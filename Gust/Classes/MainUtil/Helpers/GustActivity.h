//
//  GustActivity.h
//  Gust
//
//  Created by Iracle Zhang on 3/4/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActivityShareBlock)(NSString *theErrorMessage);

@interface GustActivity : UIActivity

@property (nonatomic,strong) UIImage *shareImage;
@property (nonatomic,copy)NSString *URL;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)ActivityShareBlock shareBlock;
@property (nonatomic,strong)NSArray *getShareArray;

-(instancetype)initWithImage:(UIImage *)shareImage atURL:(NSString *)URL atTitle:(NSString *)title atShareContentArray:(NSArray *)shareContentArray;

@end
