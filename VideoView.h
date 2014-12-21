//
//  VideoView.h
//  AudioVisualRecorder
//
//  Created by Nicole Lehrer on 12/20/14.
//  Copyright (c) 2014 Nicole Lehrer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureSession;
@interface VideoView : UIView
@property(nonatomic) AVCaptureSession * session;
@end
