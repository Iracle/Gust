//
//  GustActivity.m
//  Gust
//
//  Created by Iracle Zhang on 3/4/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "GustActivity.h"

@implementation GustActivity

-(instancetype)initWithImage:(UIImage *)shareImage atURL:(NSString *)URL atTitle:(NSString *)title atShareContentArray:(NSArray *)shareContentArray
{
    if(self = [super init]){
        _shareImage = shareImage;
        _URL = URL;
        _title = title;
        _getShareArray = [[NSArray alloc]initWithArray:shareContentArray];
    }
    return self;
}

+(UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

-(NSString *)activityType
{
    return _title;
}

-(NSString *)activityTitle
{
    return _title;
}

-(UIImage *)activityImage
{
    return _shareImage;
}

-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (UIViewController *)activityViewController
{
    return nil;
}

-(void)performActivity
{
    if(nil == _title) {
        return;
    }
    
    NSLog(@"要分享的内容-----%@",_getShareArray);
    NSLog(@"分享的类型------ %@",_title);
    
    if([_title isEqualToString:@"share Weichat"]){

    }else if([_title isEqualToString:@"share Cicle"]){

    }
}

@end
