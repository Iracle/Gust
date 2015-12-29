//
//  PrivacyPasswordView.m
//  Gust
//
//  Created by Iracle Zhang on 15/11/6.
//  Copyright © 2015年 Iralce. All rights reserved.
//

#import "PrivacyPasswordView.h"
#import "CHKeychain.h"

@interface PrivacyPasswordView ()
@property (nonatomic) NSInteger textFiledIndext;
@property (nonatomic, copy) NSMutableString *currentPassword;

@end


@implementation PrivacyPasswordView

- (void)dealloc
{
    
}
- (void)awakeFromNib {
    _textFiledIndext = 0;
    _currentPassword = [NSMutableString string];
    [_textFields enumerateObjectsUsingBlock:^(UITextField  *textFied, NSUInteger idx, BOOL * stop) {
        //hidde InputTraits
        [[textFied valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        textFied.delegate = self;
        if (idx == 0) {
            [textFied becomeFirstResponder];
        }
    }];
    
    //check is first save keychain
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(polivacyTextfieldDidChange:) name:UITextFieldTextDidChangeNotification  object:nil];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location > 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)polivacyTextfieldDidChange:(NSNotification *)notification {

    if (_textFiledIndext == 3) {
        //save current password
        [_textFields enumerateObjectsUsingBlock:^(UITextField  *textFied, NSUInteger idx, BOOL * stop) {
            [_currentPassword appendString:textFied.text];
            if (_currentPassword.length == 4) {
                [self checkPrivacypassword];
            }
        }];
              return;
    }
    UITextField *currentField = _textFields[_textFiledIndext + 1];
    NSString *passwordText = [notification.object valueForKey:@"text"];
    if (passwordText) {
        [currentField becomeFirstResponder];
    }
    _textFiledIndext ++;
}

- (void)checkPrivacypassword {
    NSDictionary *savePovicy = (NSDictionary *)[CHKeychain load:@"KEY_PRIVACY"];
    if ([savePovicy[@"privacypasswrd"] isEqualToString:_currentPassword]) {
        [self performSelector:@selector(removePrivacyView) withObject:nil afterDelay:0.15];
        [self performSelector:@selector(showDelegate) withObject:nil afterDelay:0.25];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码错误，是否继续输入密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_textFields enumerateObjectsUsingBlock:^(UITextField  *textFied, NSUInteger idx, BOOL * stop) {
                textFied.text = nil;
                if (idx == 0) {
                    [textFied becomeFirstResponder];
                    [_currentPassword deleteCharactersInRange:NSMakeRange(0, _currentPassword.length)];
                    _textFiledIndext = 0;
                }
            }];
            
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self removePrivacyView];
        }];
        [alertController addAction:sureAction];
        [alertController addAction:cancelAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void)removePrivacyView {
    [_textFields enumerateObjectsUsingBlock:^(UITextField  *textFied, NSUInteger idx, BOOL * stop) {
        [textFied resignFirstResponder];
    }];
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, -180);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showDelegate {
    
    if (_delegate && [_delegate respondsToSelector:@selector(privacyPasswordView:sucess:)]) {
        [_delegate privacyPasswordView:self sucess:YES];
    }
    
}

@end
