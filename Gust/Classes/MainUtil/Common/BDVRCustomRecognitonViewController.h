//
//  BDVRCustomRecognitonViewController.h
//  Gust
//
//  Created by Iracle Zhang on 3/16/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSiriWaveformView.h"

@class BDVRCustomRecognitonViewController;
@protocol BDVRCustomRecognitonViewControllerDelegate <NSObject>

- (void)recongnitionController:(BDVRCustomRecognitonViewController *)controller logOutToManualResut:(NSString *)aResult;
- (void)recongnitionController:(BDVRCustomRecognitonViewController *)controller logOutToLogView:(NSString *)aLog;

@end

@interface BDVRCustomRecognitonViewController : UIViewController

@property (nonatomic, strong) NSTimer *voiceLevelMeterTimer;
@property (nonatomic, strong) SCSiriWaveformView *waveformView;
@property (nonatomic) CGFloat voiceNumber;

@property (nonatomic, assign) id<BDVRCustomRecognitonViewControllerDelegate> delegate;

@end
