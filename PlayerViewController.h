//
//  PlayerViewController.h
//  AudioVisualRecorder
//
//  Created by Nicole Lehrer on 12/22/14.
//  Copyright (c) 2014 Nicole Lehrer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PlayerView;
@interface PlayerViewController : UIViewController
@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;
@property (nonatomic, strong) IBOutlet PlayerView *playerView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) NSURL *fileURL;

//audio
@property (nonatomic) NSMutableArray * audioLevelSummary;


- (IBAction)loadAssetFromFile:sender;
- (IBAction)play:sender;
- (void)syncUI;
@end
