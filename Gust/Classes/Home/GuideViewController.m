//
//  GuideViewController.m
//  Gust
//
//  Created by Iracle on 15/5/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "GuideViewController.h"
#import "HomeViewController.h"
#import "GustConfigure.h"
#import <POP/POP.h>

#define ANIMATIONVIEW_H (SCREEN_WIDTH - 60)/4
#define ANIMATIONVIEW_Y (SCREEN_HEIGHT/2 - ANIMATIONVIEW_H)

@interface GuideViewController ()

@property (nonatomic, strong) UILabel *gLabel;
@property (nonatomic, strong) UILabel *uLabel;
@property (nonatomic, strong) UILabel *sLabel;
@property (nonatomic, strong) UILabel *tLabel;

@end

@implementation GuideViewController

- (UILabel *)gLabel {
    if (!_gLabel) {
        _gLabel = [[UILabel alloc] init];
        _gLabel.bounds = CGRectMake(0, 0, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
        _gLabel.center = CGPointMake(SCREEN_WIDTH / 2, ANIMATIONVIEW_Y);
        _gLabel.backgroundColor = [UIColor blackColor];
        _gLabel.textColor = [UIColor whiteColor];
        _gLabel.font = [UIFont systemFontOfSize:47.0 weight:UIFontWeightMedium];
        _gLabel.textAlignment = NSTextAlignmentCenter;
        _gLabel.text = @"G";
    }
    return _gLabel;
}

- (UILabel *)uLabel {
    if (!_uLabel) {
        _uLabel = [[UILabel alloc] init];
        _uLabel.bounds = CGRectMake(0, 0, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
        _uLabel.center = CGPointMake(SCREEN_WIDTH / 2, ANIMATIONVIEW_Y);
        _uLabel.backgroundColor = [UIColor blackColor];
        _uLabel.textColor = [UIColor whiteColor];
        _uLabel.font = [UIFont systemFontOfSize:47.0 weight:UIFontWeightMedium];
        _uLabel.textAlignment = NSTextAlignmentCenter;
        _uLabel.text = @"U";
    }
    return _uLabel;
}

- (UILabel *)sLabel {
    if (!_sLabel) {
        _sLabel = [[UILabel alloc] init];
        _sLabel.bounds = CGRectMake(0, 0, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
        _sLabel.center = CGPointMake(SCREEN_WIDTH / 2, ANIMATIONVIEW_Y);
        _sLabel.backgroundColor = [UIColor blackColor];
        _sLabel.textColor = [UIColor whiteColor];
        _sLabel.font = [UIFont systemFontOfSize:47.0 weight:UIFontWeightMedium];
        _sLabel.textAlignment = NSTextAlignmentCenter;
        _sLabel.text = @"S";
    }
    return _sLabel;
}

- (UILabel *)tLabel {
    if (!_tLabel) {
        _tLabel = [[UILabel alloc] init];
        _tLabel.bounds = CGRectMake(0, 0, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
        _tLabel.center = CGPointMake(SCREEN_WIDTH / 2, ANIMATIONVIEW_Y);
        _tLabel.backgroundColor = [UIColor blackColor];
        _tLabel.textColor = [UIColor whiteColor];
        _tLabel.font = [UIFont systemFontOfSize:47.0 weight:UIFontWeightMedium];
        _tLabel.textAlignment = NSTextAlignmentCenter;
        _tLabel.text = @"T";
    }
    return _tLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.gLabel.alpha = 0.01;
    self.uLabel.alpha = 0.01;
    self.sLabel.alpha = 0.01;
    self.tLabel.alpha = 0.01;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
        self.gLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.gLabel.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.uLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.uLabel.hidden = YES;
            [UIView animateWithDuration:0.5 animations:^{
                self.sLabel.alpha = 1.0;
            } completion:^(BOOL finished) {
                self.sLabel.hidden = YES;
                [UIView animateWithDuration:0.5 animations:^{
                    self.tLabel.alpha = 1.0;
                } completion:^(BOOL finished) {
                    self.tLabel.hidden = YES;
                    [weakSelf showAllAnimationView];
                    
                }];
            }];
            
        }];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.gLabel];
    [self.view addSubview:self.uLabel];
    [self.view addSubview:self.sLabel];
    [self.view addSubview:self.tLabel];

}

- (void)showAllAnimationView {
    self.gLabel.frame = CGRectMake(15.0, ANIMATIONVIEW_Y, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
    self.uLabel.frame = CGRectMake(CGRectGetMaxX(self.gLabel.frame) + 10.0, ANIMATIONVIEW_Y, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
    self.sLabel.frame = CGRectMake(CGRectGetMaxX(self.uLabel.frame) + 10.0, ANIMATIONVIEW_Y, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
    self.tLabel.frame = CGRectMake(CGRectGetMaxX(self.sLabel.frame) + 10.0, ANIMATIONVIEW_Y, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
    
    self.gLabel.hidden = NO;
    self.uLabel.hidden = NO;
    self.sLabel.hidden = NO;
    self.tLabel.hidden = NO;
    
    self.gLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.uLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.sLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.tLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
//    [UIView animateWithDuration:10 animations:^{
//        self.gLabel.transform = CGAffineTransformIdentity;
//        self.uLabel.transform = CGAffineTransformIdentity;
//        self.sLabel.transform = CGAffineTransformIdentity;
//        self.tLabel.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        
//    }];
    
        POPBasicAnimation *animation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        animation1.beginTime = CACurrentMediaTime() + 0.0;
        animation1.duration = 25.0;
        animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.gLabel.layer pop_addAnimation:animation1 forKey:@"decay"];
        [self.uLabel.layer pop_addAnimation:animation1 forKey:@"decay"];
        [self.sLabel.layer pop_addAnimation:animation1 forKey:@"decay"];
        [self.tLabel.layer pop_addAnimation:animation1 forKey:@"decay"];
    
    //    POPDecayAnimation *animation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    animation.velocity = [NSValue valueWithCGSize:CGSizeMake(0.42, 0.42)];
//    animation.deceleration = 0.998;
//    animation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//        if (finished) {
//            
//        }
//    };
//    [self.gLabel.layer pop_addAnimation:animation forKey:@"decay"];
//    [self.uLabel.layer pop_addAnimation:animation forKey:@"decay"];
//    [self.sLabel.layer pop_addAnimation:animation forKey:@"decay"];
//    [self.tLabel.layer pop_addAnimation:animation forKey:@"decay"];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    nav.navigationBar.hidden = YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

@end
