//
//  BDVoiceRecognitionClientHelper.m
//  Gust
//
//  Created by Iracle Zhang on 3/16/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "BDVoiceRecognitionClientHelper.h"
#import "BDVoiceRecognitionClient.h"
#import "BDVRLogger.h"
#import "BDVRSConfig.h"

@implementation BDVoiceRecognitionClientHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupBaiduVoice];
    }
    return self;
}

- (void)setupBaiduVoice {
    // 设置开发者信息
    [[BDVoiceRecognitionClient sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
    
    // 设置语音识别模式，默认是输入模式
    [[BDVoiceRecognitionClient sharedInstance] setPropertyList:@[[BDVRSConfig sharedInstance].recognitionProperty]];
    
    // 设置城市ID，当识别属性包含EVoiceRecognitionPropertyMap时有效
    [[BDVoiceRecognitionClient sharedInstance] setCityID: 1];
    
    
    // 设置是否需要语义理解，只在搜索模式有效
    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"nlu" withFlag:[BDVRSConfig sharedInstance].isNeedNLU];
    
    // 开启联系人识别
    //    [[BDVoiceRecognitionClient sharedInstance] setConfig:@"enable_contacts" withFlag:YES];
    
    // 设置识别语言
    [[BDVoiceRecognitionClient sharedInstance] setLanguage:[BDVRSConfig sharedInstance].recognitionLanguage];
    
    // 是否打开语音音量监听功能，可选
    [BDVRSConfig sharedInstance].voiceLevelMeter = YES;
    if ([BDVRSConfig sharedInstance].voiceLevelMeter)
    {
        BOOL res = [[BDVoiceRecognitionClient sharedInstance] listenCurrentDBLevelMeter];
        
        if (res == NO)  // 如果监听失败，则恢复开关值
        {
            [BDVRSConfig sharedInstance].voiceLevelMeter = NO;
        }
    }
    else
    {
        [[BDVoiceRecognitionClient sharedInstance] cancelListenCurrentDBLevelMeter];
    }
    
    // 设置播放开始说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecStart isPlay:YES];
    // 设置播放结束说话提示音开关，可选
    [[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecEnd isPlay: YES];

    
}


@end
