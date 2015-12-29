//
//  SetPrivacyPasswordViewController.m
//  Gust
//
//  Created by Iracle Zhang on 15/11/5.
//  Copyright © 2015年 Iralce. All rights reserved.
//

#import "SetPrivacyPasswordViewController.h"
#import "CHKeychain.h"
#import "GustConfigure.h"
#import "GustAlertView.h"

#define TEXTFIELD_INDEX 0
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface SetPrivacyPasswordViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleInfo;
@property (weak, nonatomic) IBOutlet UILabel *errorInfo;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (nonatomic) NSInteger textFiledIndext;
@property (nonatomic, copy) NSMutableString *currentPassword;
@property (nonatomic) BOOL isfirstSavedsucess;
@property (nonatomic) BOOL isfirstInput;
@end

@implementation SetPrivacyPasswordViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _errorInfo.layer.masksToBounds = YES;
    _errorInfo.layer.cornerRadius = 8;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPassword = [NSMutableString string];
    _textFiledIndext = 0;
    _isfirstInput = YES;
    
    _errorInfo.hidden = YES;
    //check is first save keychain
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChange:) name:UITextFieldTextDidChangeNotification  object:nil];
    
    [_textFields enumerateObjectsUsingBlock:^(UITextField  *textFied, NSUInteger idx, BOOL * stop) {
        //hidde InputTraits
        [[textFied valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
        textFied.delegate = self;
        if (idx == 0) {
            [textFied becomeFirstResponder];
        }
    }];

}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location > 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (void)textfieldDidChange:(NSNotification *)notification {
    _errorInfo.text = nil;
    _errorInfo.hidden = YES;
    if (_textFiledIndext == 3) {
        //save current password
        [_textFields enumerateObjectsUsingBlock:^(UITextField  *textFied, NSUInteger idx, BOOL * stop) {
            [_currentPassword appendString:textFied.text];
            if (_currentPassword.length == 8) {
                [self checkpassword];
            }
        }];
        if (!_isfirstSavedsucess) {
            [self bgViewAnimation];
        }
        return;
    }
    UITextField *currentField = _textFields[_textFiledIndext + 1];
    NSString *passwordText = [notification.object valueForKey:@"text"];
    if (passwordText) {
        [currentField becomeFirstResponder];
    }
    _textFiledIndext ++;
    
}

- (void)bgViewAnimation {
    [UIView animateWithDuration:0.25 animations:^{
        _bgView.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
        
    } completion:^(BOOL finished) {
        _bgView.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH, 0);
        [UIView animateWithDuration:0.25 animations:^{
            _bgView.transform = CGAffineTransformIdentity;
        }];
        _textFiledIndext = 0;
        _isfirstInput = NO;
        UITextField *currentField = _textFields[_textFiledIndext];
        [currentField becomeFirstResponder];
        [_textFields enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.text = nil;
        }];
        _titleInfo.text = @"请再次输入密码";
        
    }];
}

//check first and second password is equal
- (void)checkpassword {
    NSString *firstpassword = [_currentPassword substringToIndex:4];
    NSRange range = NSMakeRange(4, 4);
    NSString *secondpassword = [_currentPassword substringWithRange:range];
    if ([firstpassword isEqualToString:secondpassword]) {
        _isfirstSavedsucess = YES;
        //save privacypassword
        [CHKeychain save:@"KEY_PRIVACY" data:@{@"privacypasswrd": firstpassword}];
        GustAlertView *alertView = [[GustAlertView alloc] init];
        [alertView showInView:self.view type:1 title:@"设置隐私模式密码成功"];
        [self performSelector:@selector(popToSetting) withObject:nil afterDelay:2];
        
        
    } else {
        //retry
        [_currentPassword deleteCharactersInRange:NSMakeRange(0, _currentPassword.length)];
        [self performSelector:@selector(changeErrorLabel) withObject:nil afterDelay:0.35];
        
    }
    
}

- (void)changeErrorLabel {
    _titleInfo.text = @"请输入密码";
    _errorInfo.hidden = NO;
    _errorInfo.text = @"两次密码不匹配，请重新输入";
}

- (void)popToSetting {
    [self.navigationController popViewControllerAnimated:YES];
}

@end











