//
//  GustStringHandle.m
//  Gust
//
//  Created by Iracle Zhang on 3/24/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "GustStringHandle.h"

@implementation GustStringHandle

- (NSString *)getTheCurrentWebName:(NSString *)webTitle {
    
    NSString *returnWebTitle;
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@"【" withString:@""];
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@"】" withString:@""];
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@"《" withString:@""];
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@"》" withString:@""];
    webTitle = [webTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([self convertToInt:webTitle] > 10) {
        if ([self convertToInt:webTitle] > webTitle.length) {
            NSString *resultTitle = [NSString stringWithFormat:@"%@%@",[webTitle substringToIndex:5], @"..."];
            returnWebTitle = resultTitle;
        } else {
            NSString *resultTitle = [NSString stringWithFormat:@"%@%@",[webTitle substringToIndex:10], @"..."];
            returnWebTitle = resultTitle;
        }
    } else {
        returnWebTitle = webTitle;
    }
    return returnWebTitle;
}

- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

@end
