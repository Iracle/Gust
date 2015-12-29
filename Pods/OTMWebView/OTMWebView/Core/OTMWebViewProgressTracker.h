//
// OTMWebViewProgressTracker.h
//
// Copyright (c) 2014 Ryan Coffman
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@class OTMWebView;
@protocol OTMWebViewProgressTrackerDelegate;

@interface OTMWebViewProgressTracker : NSObject
- (void)startProgress;
- (void)finishProgress;
- (void)progressStartedWithRequest:(NSURLRequest *)request;
- (void)progressCompletedWithRequest:(NSURLRequest *)request;
- (void)incrementProgressForRequest:(NSURLRequest *)request withResponse:(NSURLResponse *)response;
- (void)incrementProgressForRequest:(NSURLRequest *)request withBytesReceived:(NSUInteger)bytesReceived;
- (void)reset;
@property (readonly, nonatomic) double progress;
@property (readonly, nonatomic) BOOL isTrackingProgress;
@property (weak, nonatomic) id <OTMWebViewProgressTrackerDelegate> delegate;
@end

@protocol OTMWebViewProgressTrackerDelegate <NSObject>
@optional;
- (void)progressTrackerProgressDidStart:(OTMWebViewProgressTracker *)tracker;
- (void)progressTrackerProgressDidFinish:(OTMWebViewProgressTracker *)tracker;
- (void)progressTracker:(OTMWebViewProgressTracker *)progressTracker progressDidChange:(double)progress;

@end
