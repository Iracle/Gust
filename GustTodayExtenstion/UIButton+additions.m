//
//  UIButton+additions.m
//  Gust
//
//  Created by Iracle Zhang on 1/27/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "UIButton+additions.h"
#import <objc/runtime.h>

static void *strKey = &strKey;

@implementation UIButton (additions)


-(void)setStr:(NSString *)str
{
    objc_setAssociatedObject(self, &strKey, str, OBJC_ASSOCIATION_COPY);
}

-(NSString *)str
{
    return objc_getAssociatedObject(self, &strKey);
}
@end
