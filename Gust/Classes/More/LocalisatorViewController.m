//
//  LocalisatorViewController.m
//  Gust
//
//  Created by Iracle Zhang on 2/26/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "LocalisatorViewController.h"

@interface LocalisatorViewController ()

@end

@implementation LocalisatorViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"语言";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:250 / 255.0 blue:250 / 255.0 alpha:1.0];

}


@end
