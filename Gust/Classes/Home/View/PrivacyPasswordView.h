//
//  PrivacyPasswordView.h
//  Gust
//
//  Created by Iracle Zhang on 15/11/6.
//  Copyright © 2015年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrivacyPasswordView;
@protocol PrivacyPasswordViewDelegate <NSObject>

- (void)privacyPasswordView:(PrivacyPasswordView *)privacyView sucess:(BOOL)success;

@end

@interface PrivacyPasswordView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *privacyTitleLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (nonatomic, assign) id<PrivacyPasswordViewDelegate> delegate;



@end
