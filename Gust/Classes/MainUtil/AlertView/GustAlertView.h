//
//  GustAlertView.h
//  Gust
//
//  Created by Iracle on 15/4/9.
//  Copyright (c) 2015年 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    AlertRectangle = 0,
    AlertSquare
    
}RectType;

@interface GustAlertView : UIVisualEffectView

- (void)showInView:(UIView *)view type:(RectType) type title:(NSString *)info;
@end
