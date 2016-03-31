//
//  GustFeedbackHelper.m
//  Gust
//
//  Created by Iracle Zhang on 3/12/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "GustFeedbackHelper.h"
#import "Localisator.h"

@implementation GustFeedbackHelper 

- (void)sendEmailAction:(UIViewController *) viewController {
    
    self.rootViewController = viewController;
    
    if ([MFMailComposeViewController canSendMail]) {
        [self sendEmailAction];
    }
    
}

- (void)sendEmailAction
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];

    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self.rootViewController];
    
    // 设置邮件主题
    [mailCompose setSubject: LOCALIZATION(@"Feedback")];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"iracle.zhang@gmail.com"]];
//    // 设置抄送人
//    [mailCompose setCcRecipients:@[@"邮箱号码"]];
//    // 设置密抄送
//    [mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    /**
     *  设置邮件的正文内容
     */
    //    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    //    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
//    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    UIImage *image = [UIImage imageNamed:@"image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    NSData *pdf = [NSData dataWithContentsOfFile:file];
    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"7天精通IOS233333"];
    
    // 弹出邮件发送视图
    [self.rootViewController presentViewController:mailCompose animated:YES completion:nil];
}




@end
