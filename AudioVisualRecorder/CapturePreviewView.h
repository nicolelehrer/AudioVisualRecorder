//
//  CapturePreviewView.h
//  AudioVisualRecorder
//
//  Created by Nicole Lehrer on 12/27/14.
//  Copyright (c) 2014 Nicole Lehrer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureSession;
@interface CapturePreviewView : UIView
@property(nonatomic) AVCaptureSession * session;

@end

