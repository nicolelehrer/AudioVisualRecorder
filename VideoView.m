//
//  VideoView.m
//  AudioVisualRecorder
//
//  Created by Nicole Lehrer on 12/20/14.
//  Copyright (c) 2014 Nicole Lehrer. All rights reserved.
//

#import "VideoView.h"
#import <AVFoundation/AVFoundation.h>

@implementation VideoView

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
