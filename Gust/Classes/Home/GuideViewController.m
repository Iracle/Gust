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
#import "FBShimmering.h"
#import "FBShimmeringView.h"

#define ANIMATIONVIEW_H (SCREEN_WIDTH - 60)/4
#define ANIMATIONVIEW_RH (SCREEN_WIDTH - 85)/4

#define ANIMATIONVIEW_Y (SCREEN_HEIGHT/2 - ANIMATIONVIEW_H)
#define ANIMATIONVIEW_FY (SCREEN_HEIGHT/2 - ANIMATIONVIEW_RH * 2)


@interface GuideViewController ()

@property (nonatomic, strong) UILabel *gLabel;
@property (nonatomic, strong) UILabel *uLabel;
@property (nonatomic, strong) UILabel *sLabel;
@property (nonatomic, strong) UILabel *tLabel;

@property (nonatomic, strong) FBShimmeringView *gGhimmeringView;
@property (nonatomic, strong) FBShimmeringView *uGhimmeringView;
@property (nonatomic, strong) FBShimmeringView *sGhimmeringView;
@property (nonatomic, strong) FBShimmeringView *tGhimmeringView;


@property (nonatomic, strong) UILabel *displayLabel;

@end

@implementation GuideViewController

- (FBShimmeringView *)gGhimmeringView {
    if (!_gGhimmeringView) {
        _gGhimmeringView = [[FBShimmeringView alloc] init];
        _gGhimmeringView.bounds = CGRectMake(0, 0, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
        _gGhimmeringView.center = CGPointMake(SCREEN_WIDTH / 2, ANIMATIONVIEW_Y);
        _gGhimmeringView.backgroundColor = [UIColor colorWithRed:0.1447 green:0.1447 blue:0.1447 alpha:1.0];
        _gGhimmeringView.shimmeringBeginFadeDuration = 0.25;
        _gGhimmeringView.shimmeringOpacity = 0.9;
        _gGhimmeringView.layer.cornerRadius = 1.5;
//        _gGhimmeringView.shimmeringSpeed = 350.0;
    }
    return _gGhimmeringView;
}

- (FBShimmeringView *)uGhimmeringView {
    if (!_uGhimmeringView) {
        _uGhimmeringView = [[FBShimmeringView alloc] init];
        _uGhimmeringView.bounds = CGRectMake(0, 0, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
        _uGhimmeringView.center = CGPointMake(SCREEN_WIDTH / 2, ANIMATIONVIEW_Y);
        _uGhimmeringView.backgroundColor = [UIColor blackColor];
        _uGhimmeringView.shimmeringBeginFadeDuration = 0.5;
        _uGhimmeringView.shimmeringOpacity = 0.9;
        _uGhimmeringView.layer.cornerRadius = 1.5;
    }
    return _uGhimmeringView;
}
- (FBShimmeringView *)sGhimmeringView {
    if (!_sGhimmeringView) {
        _sGhimmeringView = [[FBShimmeringView alloc] init];
        _sGhimmeringView.bounds = CGRectMake(0, 0, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
        _sGhimmeringView.center = CGPointMake(SCREEN_WIDTH / 2, ANIMATIONVIEW_Y);
        _sGhimmeringView.backgroundColor = [UIColor colorWithRed:0.1447 green:0.1447 blue:0.1447 alpha:1.0];
        _sGhimmeringView.shimmeringBeginFadeDuration = 0.75;
        _sGhimmeringView.shimmeringOpacity = 0.9;
        _sGhimmeringView.layer.cornerRadius = 1.5;

    }
    return _sGhimmeringView;
}
- (FBShimmeringView *)tGhimmeringView {
    if (!_tGhimmeringView) {
        _tGhimmeringView = [[FBShimmeringView alloc] init];
        _tGhimmeringView.bounds = CGRectMake(0, 0, ANIMATIONVIEW_H, ANIMATIONVIEW_H);
        _tGhimmeringView.center = CGPointMake(SCREEN_WIDTH / 2, ANIMATIONVIEW_Y);
        _tGhimmeringView.backgroundColor = [UIColor blackColor];
        _tGhimmeringView.shimmeringBeginFadeDuration = 1.0;
        _tGhimmeringView.shimmeringOpacity = 0.9;
        _tGhimmeringView.layer.cornerRadius = 1.5;

    }
    return _tGhimmeringView;
}


- (UILabel *)gLabel {
    if (!_gLabel) {
        _gLabel = [[UILabel alloc] initWithFrame:self.gGhimmeringView.bounds];
        _gLabel.backgroundColor = [UIColor clearColor];
        _gLabel.textColor = [UIColor whiteColor];
        _gLabel.font = [UIFont fontWithName:@"avenir" size:47.0];
        _gLabel.textAlignment = NSTextAlignmentCenter;
        _gLabel.text = @"G";
    }
    return _gLabel;
}

- (UILabel *)uLabel {
    if (!_uLabel) {
        _uLabel = [[UILabel alloc] initWithFrame:self.uGhimmeringView.bounds];
        _uLabel.backgroundColor = [UIColor clearColor];
        _uLabel.textColor = [UIColor whiteColor];
        _uLabel.textAlignment = NSTextAlignmentCenter;
        _uLabel.text = @"U";
        _uLabel.font = [UIFont fontWithName:@"avenir" size:47.0];
    }
    return _uLabel;
}

- (UILabel *)sLabel {
    if (!_sLabel) {
        _sLabel = [[UILabel alloc] initWithFrame:self.sGhimmeringView.bounds];
        _sLabel.backgroundColor = [UIColor clearColor];
        _sLabel.textColor = [UIColor whiteColor];
        _sLabel.font = [UIFont fontWithName:@"avenir" size:47.0];
        _sLabel.textAlignment = NSTextAlignmentCenter;
        _sLabel.text = @"S";
    }
    return _sLabel;
}

- (UILabel *)tLabel {
    if (!_tLabel) {
        _tLabel = [[UILabel alloc] initWithFrame:self.tGhimmeringView.bounds];
        _tLabel.backgroundColor = [UIColor clearColor];
        _tLabel.textColor = [UIColor whiteColor];
        _tLabel.font = [UIFont fontWithName:@"avenir" size:47.0];
        _tLabel.textAlignment = NSTextAlignmentCenter;
        _tLabel.text = @"T";
    }
    return _tLabel;
}

- (UILabel *)displayLabel {
    if (!_displayLabel) {
        _displayLabel = [[UILabel alloc] init];
        _displayLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.7, 30.0);
        _displayLabel.center = CGPointMake(SCREEN_MID_X, SCREEN_MID_Y - 15.0);
        _displayLabel.text = @"The Garden Of Sinners";
        _displayLabel.textAlignment = NSTextAlignmentCenter;
        _displayLabel.textColor = [UIColor colorWithRed:0.0752 green:0.0752 blue:0.0752 alpha:1.0];
        _displayLabel.font = [UIFont fontWithName:@"Bangla Sangam MN" size:17.0];
        
    }
    
    return _displayLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.gGhimmeringView.alpha = 0.0;
    self.uGhimmeringView.alpha = 0.0;
    self.sGhimmeringView.alpha = 0.0;
    self.tGhimmeringView.alpha = 0.0;
    
    self.gGhimmeringView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.uGhimmeringView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.sGhimmeringView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.tGhimmeringView.transform = CGAffineTransformMakeScale(0.8, 0.8);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.beginTime = CACurrentMediaTime() + 0.5;
    animation.springBounciness = 5;
    animation.springSpeed = 20;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.beginTime = CACurrentMediaTime() + 0.5;
    opacityAnimation.duration = 0.5;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1.0);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        [weakSelf startuLabelAnimation];
    };
    
    [self.gGhimmeringView.layer pop_addAnimation:animation forKey:@"animationscale"];
    [self.gGhimmeringView.layer pop_addAnimation:opacityAnimation forKey:@"animationopacity"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.gGhimmeringView];
    [self.view addSubview:self.uGhimmeringView];
    [self.view addSubview:self.sGhimmeringView];
    [self.view addSubview:self.tGhimmeringView];
    
    self.gGhimmeringView.contentView = self.gLabel;
    self.uGhimmeringView.contentView = self.uLabel;
    self.sGhimmeringView.contentView = self.sLabel;
    self.tGhimmeringView.contentView = self.tLabel;
    
    UIView *pointView = [[UIView alloc] init];
    pointView.center = self.view.center;
    pointView.bounds = CGRectMake(0, 0, 5, 5);
    pointView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:pointView];

}

- (void)startuLabelAnimation {
    self.gGhimmeringView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.beginTime = CACurrentMediaTime() + 0.0;
    animation.springBounciness = 5;
    animation.springSpeed = 20;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.beginTime = CACurrentMediaTime() + 0.0;
    opacityAnimation.duration = 0.5;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1.0);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        [weakSelf startsLabelAnimation];
    };
    
    [self.uGhimmeringView.layer pop_addAnimation:animation forKey:@"animationscale"];
    [self.uGhimmeringView.layer pop_addAnimation:opacityAnimation forKey:@"animationopacity"];
    
}

- (void)startsLabelAnimation {
    self.uGhimmeringView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.beginTime = CACurrentMediaTime() + 0.0;
    animation.springBounciness = 5;
    animation.springSpeed = 20;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.beginTime = CACurrentMediaTime() + 0.0;
    opacityAnimation.duration = 0.5;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1.0);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        [weakSelf starttLabelAnimation];
    };
    
    [self.sGhimmeringView.layer pop_addAnimation:animation forKey:@"animationscale"];
    [self.sGhimmeringView.layer pop_addAnimation:opacityAnimation forKey:@"animationopacity"];
    
}

- (void)starttLabelAnimation {
    self.sGhimmeringView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    animation.beginTime = CACurrentMediaTime() + 0.0;
    animation.springBounciness = 5;
    animation.springSpeed = 20;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.beginTime = CACurrentMediaTime() + 0.0;
    opacityAnimation.duration = 0.5;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1.0);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        self.tGhimmeringView.hidden = YES;
        [weakSelf showAllAnimationView];
    };
    
    [self.tGhimmeringView.layer pop_addAnimation:animation forKey:@"animationscale"];
    [self.tGhimmeringView.layer pop_addAnimation:opacityAnimation forKey:@"animationopacity"];
    
}

- (void)showAllAnimationView {
    
    self.gGhimmeringView.hidden = NO;
    self.uGhimmeringView.hidden = NO;
    self.sGhimmeringView.hidden = NO;
    self.tGhimmeringView.hidden = NO;

    [UIView animateWithDuration:0.5 animations:^{

        self.gGhimmeringView.frame = CGRectMake(20.0, ANIMATIONVIEW_FY, ANIMATIONVIEW_RH, ANIMATIONVIEW_RH);
        self.uGhimmeringView.frame = CGRectMake(CGRectGetMaxX(self.gGhimmeringView.frame) + 15.0, ANIMATIONVIEW_FY, ANIMATIONVIEW_RH, ANIMATIONVIEW_RH);
        self.sGhimmeringView.frame = CGRectMake(CGRectGetMaxX(self.uGhimmeringView.frame) + 15.0, ANIMATIONVIEW_FY, ANIMATIONVIEW_RH, ANIMATIONVIEW_RH);
        self.tGhimmeringView.frame = CGRectMake(CGRectGetMaxX(self.sGhimmeringView.frame) + 15.0, ANIMATIONVIEW_FY, ANIMATIONVIEW_RH, ANIMATIONVIEW_RH);
        
    } completion:^(BOOL finished) {
        
        self.gGhimmeringView.shimmering = YES;
        self.uGhimmeringView.shimmering = YES;
        self.sGhimmeringView.shimmering = YES;
        self.tGhimmeringView.shimmering = YES;

    }];
    
    //display snogan label
    [self.view addSubview:self.displayLabel];
    self.displayLabel.alpha = 0.0;
    
     __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        self.displayLabel.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
//        [weakSelf performSelector:@selector(backToHomepage) withObject:nil afterDelay:1.5];
    }];
}

- (void)backToHomepage {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    nav.navigationBar.hidden = YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    nav.navigationBar.hidden = YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
}

@end






