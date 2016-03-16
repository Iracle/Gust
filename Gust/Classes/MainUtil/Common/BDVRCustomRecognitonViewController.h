//
//  BDVRCustomRecognitonViewController.h
//  Gust
//
//  Created by Iracle Zhang on 3/16/16.
//  Copyright © 2016 Iralce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "SCSiriWaveformView.h"

@interface BDVRCustomRecognitonViewController : UIViewController

@property (nonatomic, strong) HomeViewController *clientSampleViewController;
@property (nonatomic, strong) NSTimer *voiceLevelMeterTimer;
@property (nonatomic, strong) SCSiriWaveformView *waveformView;
@property (nonatomic) CGFloat voiceNumber;


@end
