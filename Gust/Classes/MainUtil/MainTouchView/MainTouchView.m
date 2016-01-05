//
//  MainTouchView.m
//  Gust
//
//  Created by Iracle on 15/3/4.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import "MainTouchView.h"
#import "GustConfigure.h"

@implementation MainTouchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initMainTouchView];
    }
    return self;
}

- (void)initMainTouchView
{
    self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"mainTouchHome"].CGImage);
    self.layer.cornerRadius = MainTouchViewRadius / 2;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                                                action: @selector(handleSingleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [doubleTap setNumberOfTouchesRequired:1];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget: self
                                                                                action: @selector(handleLongPressed:)];
    longPress.minimumPressDuration = 0.1;
    
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeUp setNumberOfTouchesRequired:1];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setNumberOfTouchesRequired:1];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self addGestureRecognizer:singleTap];
    [self  addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:longPress];
    [self addGestureRecognizer:swipeUp];
    [self addGestureRecognizer:swipeDown];
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
}

- (void)addAllGesture {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        recognizer.enabled = YES;
    }
 }

- (void)removeAllGesture {
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        recognizer.enabled = NO;
    }
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SingleTapMainTouchView:withGesture:)]) {
        
        [self.delegate SingleTapMainTouchView:self withGesture:gestureRecognizer];
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DoubleTapMainTouchView:withGesture:)]) {
        
        [self.delegate DoubleTapMainTouchView:self withGesture:gestureRecognizer];
    }

}

- (void)handleLongPressed:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LongPressMainTouchView:withGesture:)]) {
        
        [self.delegate LongPressMainTouchView:self withGesture:gestureRecognizer];
    }

}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            if (self.delegate && [self.delegate respondsToSelector:@selector(SwipeLeftMainTouchView:withGesture:)]) {
                
                [self.delegate SwipeLeftMainTouchView:self withGesture:gestureRecognizer];
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if (self.delegate && [self.delegate respondsToSelector:@selector(SwipeRightMainTouchView:withGesture:)]) {
                
                [self.delegate SwipeRightMainTouchView:self withGesture:gestureRecognizer];
            }

            break;
        case UISwipeGestureRecognizerDirectionUp:
            if (self.delegate && [self.delegate respondsToSelector:@selector(SwipeUpMainTouchView:withGesture:)]) {
                
                [self.delegate SwipeUpMainTouchView:self withGesture:gestureRecognizer];
            }

            break;
        case UISwipeGestureRecognizerDirectionDown:
            if (self.delegate && [self.delegate respondsToSelector:@selector(SwipeDownMainTouchView:withGesture:)]) {
                
                [self.delegate SwipeDownMainTouchView:self withGesture:gestureRecognizer];
            }

            break;
            
        default:
            break;
    }
}

@end




















