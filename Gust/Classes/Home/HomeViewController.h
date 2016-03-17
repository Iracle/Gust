//
//  HomeViewController.h
//  Gust
//
//  Created by Iracle on 15/3/3.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSearchBar.h"


@interface HomeViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic) CGRect cellPopAnimationViewRect;
@property (nonatomic, strong) MainSearchBar *searchBar;

//baidu voice debug
@property (strong, nonatomic)  UITextView *logCatView;
@end
