//
//  GustActivity.m
//  Gust
//
//  Created by Iracle Zhang on 3/4/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "GustActivity.h"
#import "OpenShareHeader.h"

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
    
     NSLog(@"get share data: %@",_getShareArray);
    OSMessage *msg=[[OSMessage alloc]init];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@", _getShareArray[2]];
    msg.title = @"Gust Browser";
    msg.desc = _getShareArray[0];
    msg.image = UIImagePNGRepresentation([UIImage imageNamed:@"AboutAppIcon"]);
    msg.link = url;
    
    if([_title isEqualToString:@"WeChat"]){
        [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
            NSLog(@"微信分享到会话成功：\n%@",message);
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"微信分享到会话失败：\n%@\n%@",error,message);
        }];

    }else if([_title isEqualToString:@"Moments"]){
        [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
            NSLog(@"微信分享到朋友圈成功：\n%@",message);
        } Fail:^(OSMessage *message, NSError *error) {
            NSLog(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
        }];
    }
}

@end







