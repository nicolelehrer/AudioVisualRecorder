//
//  PlayerView.m
//  AudioVisualRecorder
//
//  Created by Nicole Lehrer on 12/22/14.
//  Copyright (c) 2014 Nicole Lehrer. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end

