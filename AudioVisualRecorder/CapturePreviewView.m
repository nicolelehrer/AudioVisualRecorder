//
//  CapturePreviewView.m
//  AudioVisualRecorder
//
//  Created by Nicole Lehrer on 12/27/14.
//  Copyright (c) 2014 Nicole Lehrer. All rights reserved.
//

#import "CapturePreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation CapturePreviewView

+(Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

-(AVCaptureSession*)session
{
    return [(AVCaptureVideoPreviewLayer*)[self layer] session];
}

-(void)setSession:(AVCaptureSession*)session
{
    [(AVCaptureVideoPreviewLayer*)[self layer] setSession:session];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end