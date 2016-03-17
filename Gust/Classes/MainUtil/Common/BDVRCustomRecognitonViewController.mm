//
//  BDVRCustomRecognitonViewController.m
//  Gust
//
//  Created by Iracle Zhang on 3/16/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import "BDVRCustomRecognitonViewController.h"
#import "BDVoiceRecognitionClient.h"
#import "BDVRSConfig.h"
#import "Localisator.h"
#import "GustConfigure.h"

static const CGFloat kDefaultAmplitude          =  0.0f ;
#define VOICE_LEVEL_INTERVAL 0.1 // 音量监听频率为1秒中10次

@interface BDVRCustomRecognitonViewController () <MVoiceRecognitionClientDelegate>

@property (nonatomic, strong) UIVisualEffectView *bgVisualEffectView;
@property (nonatomic, strong) UILabel *continusManualResutLabel;


- (void)createInitView; // 创建初始化界面，播放提示音时会用到
- (void)createRecordView;  // 创建录音界面
- (void)createRecognitionView; // 创建识别界面
- (void)createErrorViewWithErrorType:(int)aStatus; // 在识别view中显示详细错误信息
- (void)createRunLogWithStatus:(int)aStatus; // 在状态view中显示详细状态信息

- (void)finishRecord:(id)sender; // 用户点击完成动作
- (void)cancel:(id)sender; // 用户点击取消动作

- (void)startVoiceLevelMeterTimer;
- (void)freeVoiceLevelMeterTimerTimer;

@end

@implementation BDVRCustomRecognitonViewController {
    CADisplayLink *displaylink;
}


- (UIVisualEffectView *)bgVisualEffectView {
    if (!_bgVisualEffectView) {
        _bgVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        _bgVisualEffectView.frame = [UIScreen mainScreen].bounds;
        _bgVisualEffectView.alpha = 0.9;
    }
    return _bgVisualEffectView;
}

- (UILabel *)continusManualResutLabel {
    if (!_continusManualResutLabel) {
        _continusManualResutLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, SCREEN_WIDTH - 40, 50)];
        _continusManualResutLabel.textAlignment = NSTextAlignmentCenter;
        _continusManualResutLabel.font = [UIFont systemFontOfSize:23 weight:UIFontWeightLight];
        _continusManualResutLabel.textColor = [UIColor colorWithRed:0.2553 green:0.2553 blue:0.2553 alpha:1.0];
        
    }
    return _continusManualResutLabel;
}

- (void)dealloc
{
    [displaylink invalidate];
    displaylink = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bgVisualEffectView];
    [self.bgVisualEffectView addSubview:self.continusManualResutLabel];
    [self showCustomVoicePanAnimation];
    
    self.voiceNumber = kDefaultAmplitude;
    _waveformView = [[SCSiriWaveformView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 400)];
    _waveformView.backgroundColor = [UIColor clearColor];
    [_waveformView setPrimaryWaveLineWidth:3.0f];
    [_waveformView setSecondaryWaveLineWidth:1.0];
    [_waveformView setWaveColor:[UIColor clearColor]];
    [self.bgVisualEffectView addSubview:_waveformView];
    
     displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    // 开始语音识别功能，之前必须实现MVoiceRecognitionClientDelegate协议中的VoiceRecognitionClientWorkStatus:obj方法
    int startStatus = -1;
    startStatus = [[BDVoiceRecognitionClient sharedInstance] startVoiceRecognition:self];
    if (startStatus != EVoiceRecognitionStartWorking) // 创建失败则报告错误
    {
        NSString *statusString = [NSString stringWithFormat:@"%d",startStatus];
        [self performSelector:@selector(firstStartError:) withObject:statusString afterDelay:0.3];  // 延迟0.3秒，以便能在出错时正常删除view
        return;
    }
    
    // 是否需要播放开始说话提示音，如果是，则提示用户不要说话，在播放完成后再开始说话, 也就是收到EVoiceRecognitionClientWorkStatusStartWorkIng通知后再开始说话。
    if ([BDVRSConfig sharedInstance].playStartMusicSwitch)
    {
        [self createInitView];
    }
    else
    {
        [self createRecordView];
    }
    
}
- (void)showCustomVoicePanAnimation {
    self.view.alpha = 0.0;
    [UIView animateWithDuration:0.35 delay:0 options:0 animations:^{
        self.view.alpha = 1.0;
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    //内存警告，停止语音识别
    [super didReceiveMemoryWarning];
    [self cancel:nil];
    
}

#pragma mark - button action methods

- (void)finishRecord:(id)sender
{
    [[BDVoiceRecognitionClient sharedInstance] speakFinish];

}

- (void)cancel:(id)sender
{
    [[BDVoiceRecognitionClient sharedInstance] stopVoiceRecognition];
    [self removeCustomVoicePan];
}
#pragma mark - MVoiceRecognitionClientDelegate

- (void)VoiceRecognitionClientErrorStatus:(int) aStatus subStatus:(int)aSubStatus
{
    // 为了更加具体的显示错误信息，此处没有使用aStatus参数
    [self createErrorViewWithErrorType:aSubStatus];
}

- (void)VoiceRecognitionClientWorkStatus:(int)aStatus obj:(id)aObj
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusFlushData: // 连续上屏中间结果
        {
            NSString *text = [aObj objectAtIndex:0];
            
            if ([text length] > 0)
            {
                //iracle: 连续上屏中间结果
                [self logOutToContinusManualResut:text];
            }
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: // 识别正常完成并获得结果
        {
            //iracle: 在状态view中显示详细状态信息
            [self createRunLogWithStatus:aStatus];
            
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            
            if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
            {
                //  搜索模式下的结果为数组，示例为
                // ["公园", "公元"]
                NSMutableArray *audioResultData = (NSMutableArray *)aObj;
                NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
                
                for (int i = 0; i < [audioResultData count]; i++)
                {
                    //只取返回结果数组的第一个元素
                    if (i == 0) {
                        [tmpString appendString:audioResultData[i]];
                    }
                    
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(recongnitionController:logOutToManualResut:)]) {
                    [self.delegate recongnitionController:self logOutToManualResut:tmpString];
                }
            }
            else
            {
                NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
                //iracle: 连续上屏中间结果
                [self logOutToContinusManualResut:tmpString];
            }
            [self removeCustomVoicePan];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData:
        {
            // 此状态只有在输入模式下使用
            // 输入模式下的结果为带置信度的结果，示例如下：
            //  [
            //      [
            //         {
            //             "百度" = "0.6055192947387695";
            //         },
            //         {
            //             "摆渡" = "0.3625582158565521";
            //         },
            //      ]
            //      [
            //         {
            //             "一下" = "0.7665404081344604";
            //         }
            //      ],
            //   ]
            
            NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aObj];
             //iracle: 连续上屏中间结果
            [self logOutToContinusManualResut:tmpString];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: // 用户说话完成，等待服务器返回识别结果
        {
            //iracle:在状态view中显示详细状态信息
            [self createRunLogWithStatus:aStatus];
            
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            //iracle:  创建识别界面
            [self createRecognitionView];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:
        {
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            
            [self createRunLogWithStatus:aStatus];
            [self removeCustomVoicePan];
            break;
        }
        case EVoiceRecognitionClientWorkStatusStartWorkIng: // 识别库开始识别工作，用户可以说话
        {
            if ([BDVRSConfig sharedInstance].playStartMusicSwitch) // 如果播放了提示音，此时再给用户提示可以说话
            {
                //iracle: 创建录音界面
                [self createRecordView];
            }
            
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)  // 开启语音音量监听
            {
                //iracle:开启语音音量监听
                [self startVoiceLevelMeterTimer];
            }
            
            [self createRunLogWithStatus:aStatus];
            
            break;
        }
        case EVoiceRecognitionClientWorkStatusNone:
        case EVoiceRecognitionClientWorkPlayStartTone:
        case EVoiceRecognitionClientWorkPlayStartToneFinish:
        case EVoiceRecognitionClientWorkStatusStart:
        case EVoiceRecognitionClientWorkPlayEndToneFinish:
        case EVoiceRecognitionClientWorkPlayEndTone:
        {
            //iracle: 播放结束提示音
            [self createRunLogWithStatus:aStatus];
            break;
        }
        case EVoiceRecognitionClientWorkStatusNewRecordData:
        {
            //iracle:录音数据回调
            
            break;
        }
        default:
        {
            [self createRunLogWithStatus:aStatus];
            if ([BDVRSConfig sharedInstance].voiceLevelMeter)
            {
                [self freeVoiceLevelMeterTimerTimer];
            }
            
            break;
        }
    }
}

//iracle: 网络工作状态
- (void)VoiceRecognitionClientNetWorkStatus:(int) aStatus
{
    switch (aStatus)
    {
        case EVoiceRecognitionClientNetWorkStatusStart:
        {
            [self createRunLogWithStatus:aStatus];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:
        {
            [self createRunLogWithStatus:aStatus];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
    }
}

#pragma mark - voice search error result

- (void)firstStartError:(NSString *)statusString
{
    
    [self createErrorViewWithErrorType:[statusString intValue]];
}

- (void)createErrorViewWithErrorType:(int)aStatus
{
    NSString *errorMsg = @"";
    
    switch (aStatus)
    {
        case EVoiceRecognitionClientErrorStatusIntrerruption:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonInterruptRecord", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusChangeNotAvailable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonChangeNotAvailable", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusUnKnow:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonStatusError", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusNoSpeech:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoSpeech", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusShort:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoShort", nil);
            break;
        }
        case EVoiceRecognitionClientErrorStatusException:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonException", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusError:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNetWorkError", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusUnusable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoNetWork", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusTimeOut:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNetWorkTimeOut", nil);
            break;
        }
        case EVoiceRecognitionClientErrorNetWorkStatusParseError:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonParseError", nil);
            break;
        }
        case EVoiceRecognitionStartWorkNoAPIKEY:
        {
            errorMsg = NSLocalizedString(@"StringAudioSearchNoAPIKEY", nil);
            break;
        }
        case EVoiceRecognitionStartWorkGetAccessTokenFailed:
        {
            errorMsg = NSLocalizedString(@"StringAudioSearchGetTokenFailed", nil);
            break;
        }
        case EVoiceRecognitionStartWorkDelegateInvaild:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoDelegateMethods", nil);
            break;
        }
        case EVoiceRecognitionStartWorkNetUnusable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonNoNetWork", nil);
            break;
        }
        case EVoiceRecognitionStartWorkRecorderUnusable:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonCantRecord", nil);
            break;
        }
        case EVoiceRecognitionStartWorkNOMicrophonePermission:
        {
            errorMsg = NSLocalizedString(@"StringAudioSearchNOMicrophonePermission", nil);
            break;
        }
            //服务器返回错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerNoFindResult:     //没有找到匹配结果
        case EVoiceRecognitionClientErrorNetWorkStatusServerSpeechQualityProblem:    //声音过小
            
        case EVoiceRecognitionClientErrorNetWorkStatusServerParamError:       //协议参数错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerRecognError:      //识别过程出错
        case EVoiceRecognitionClientErrorNetWorkStatusServerAppNameUnknownError: //appName验证错误
        case EVoiceRecognitionClientErrorNetWorkStatusServerUnknownError:      //未知错误
        {
            errorMsg = [NSString stringWithFormat:@"%@-%d",NSLocalizedString(@"StringVoiceRecognitonServerError", nil),aStatus] ;
            break;
        }
        default:
        {
            errorMsg = NSLocalizedString(@"StringVoiceRecognitonDefaultError", nil);
            break;
        }
    }
    
    //iracle: 打印错误信息
     self.continusManualResutLabel.text =  errorMsg;
    [self performSelector:@selector(removeCustomVoicePan) withObject:nil afterDelay:1.0];
}

- (void)removeCustomVoicePan {
    
    [UIView animateWithDuration:0.15 delay:0 options:0 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.view.superview)
        {
            [self.view removeFromSuperview];
            [displaylink invalidate];
            displaylink = nil;
        }
    }];
}

#pragma mark - voice search log

- (void)createRunLogWithStatus:(int)aStatus
{
    NSString *statusMsg = nil;
    switch (aStatus)
    {
        case EVoiceRecognitionClientWorkStatusNone: //空闲
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNone", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayStartTone:  //播放开始提示音
        {
            statusMsg = NSLocalizedString(@"StringLogStatusPlayStartTone", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayStartToneFinish: //播放开始提示音完成
        {
            statusMsg = NSLocalizedString(@"StringLogStatusPlayStartToneFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusStartWorkIng: //识别工作开始，开始采集及处理数据
        {
            statusMsg = NSLocalizedString(@"StringLogStatusStartWorkIng", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusStart: //检测到用户开始说话
        {
            statusMsg = NSLocalizedString(@"StringLogStatusStart", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayEndTone: //播放结束提示音
        {
            statusMsg = NSLocalizedString(@"StringLogStatusPlayEndTone", nil);
            break;
        }
        case EVoiceRecognitionClientWorkPlayEndToneFinish: //播放结束提示音完成
        {
            statusMsg = NSLocalizedString(@"StringLogStatusPlayEndToneFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusReceiveData: //语音识别功能完成，服务器返回正确结果
        {
            statusMsg = NSLocalizedString(@"StringLogStatusSentenceFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: //语音识别功能完成，服务器返回正确结果
        {
            statusMsg = NSLocalizedString(@"StringLogStatusFinish", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusEnd: //本地声音采集结束结束，等待识别结果返回并结束录音
        {
            statusMsg = NSLocalizedString(@"StringLogStatusEnd", nil);
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusStart: //网络开始工作
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusStart", nil);
            break;
        }
        case EVoiceRecognitionClientNetWorkStatusEnd:  //网络工作完成
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusEnd", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusCancel:  // 用户取消
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusCancel", nil);
            break;
        }
        case EVoiceRecognitionClientWorkStatusError: // 出现错误
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusErorr", nil);
            break;
        }
        default:
        {
            statusMsg = NSLocalizedString(@"StringLogStatusNetWorkStatusDefaultErorr", nil);
            break;
        }
    }
    
    if (statusMsg)
    {
       // iracle：搜索打印
        if (self.delegate && [self.delegate respondsToSelector:@selector(recongnitionController:logOutToLogView:)]) {
            [self.delegate recongnitionController:self logOutToLogView:statusMsg];
        }
  
    }
}
//iracle:语音音量监听
- (void)startVoiceLevelMeterTimer
{
    [self freeVoiceLevelMeterTimerTimer];
    
    NSDate *tmpDate = [[NSDate alloc] initWithTimeIntervalSinceNow:VOICE_LEVEL_INTERVAL];
    NSTimer *tmpTimer = [[NSTimer alloc] initWithFireDate:tmpDate interval:VOICE_LEVEL_INTERVAL target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    self.voiceLevelMeterTimer = tmpTimer;
    [[NSRunLoop currentRunLoop] addTimer:_voiceLevelMeterTimer forMode:NSDefaultRunLoopMode];
}

- (void)freeVoiceLevelMeterTimerTimer
{
    if(_voiceLevelMeterTimer)
    {
        if([_voiceLevelMeterTimer isValid])
            [_voiceLevelMeterTimer invalidate];
        self.voiceLevelMeterTimer = nil;
    }
}

- (void)timerFired:(id)sender
{
    //iracle: 获取语音音量级别
    int voiceLevel = [[BDVoiceRecognitionClient sharedInstance] getCurrentDBLevelMeter];
    self.voiceNumber = (CGFloat)voiceLevel / 120;
}

- (void)updateMeters {
    [_waveformView setWaveColor:[UIColor redColor]];
    [self.waveformView updateWithLevel:self.voiceNumber];
}

#pragma mark - voice search views

- (void)createInitView
{
    

    
}

- (void)createRecordView
{
    //完成，取消
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - SCREEN_WIDTH / 2, SCREEN_WIDTH / 2, SCREEN_WIDTH / 2);
    sureButton.titleEdgeInsets = UIEdgeInsetsMake(25.0, 0, 0.0, 5);
    [sureButton setTitle: LOCALIZATION(@"Done") forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:31.0 weight:UIFontWeightThin];
    [sureButton setTitleColor:[UIColor colorWithRed:93 / 255.0 green:148 / 255.0 blue:140 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(finishRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH / 2, SCREEN_WIDTH / 2, SCREEN_WIDTH / 2);
    cancelButton.titleEdgeInsets = UIEdgeInsetsMake(25.0, 0, 0.0, 5);
    [cancelButton setTitle: LOCALIZATION(@"Cancel") forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:31.0 weight:UIFontWeightThin];
    [cancelButton setTitleColor:[UIColor colorWithRed:93 / 255.0 green:148 / 255.0 blue:140 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
}

- (void)createRecognitionView
{
    
}

- (void)logOutToContinusManualResut:(NSString *)result {
    
    self.continusManualResutLabel.text = result;
}





@end
