//
//  PlayerViewController.m
//  AudioVisualRecorder
//
//  Created by Nicole Lehrer on 12/22/14.
//  Copyright (c) 2014 Nicole Lehrer. All rights reserved.
//

#import "PlayerView.h"
#import "PlayerViewController.h"
#import "Constants.h"
static const NSString *ItemStatusContext;

@interface PlayerViewController ()
@property (nonatomic) float assetLength;
@property (nonatomic) float playBackCounter;
@property (nonatomic) NSTimer * audioSampleTimer;
@end
@implementation PlayerViewController

@synthesize player = _player;
@synthesize playerItem = _playerItem;
@synthesize playerView = _playerView;
@synthesize fileURL = _fileURL;
@synthesize audioLevelSummary = _audioLevelSummary;
@synthesize playBackCounter = _playBackCounter;

//test for new branch

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self syncUI];
    
    
//    self.playerView = [[PlayerView alloc] initWithFrame:CGRectMake(100, 100, 200,200)];
    
//    self.playerView = [[PlayerView alloc] init];
    
    self.playerView.backgroundColor = [UIColor blackColor];
    
//    [self.view addSubview:self.playerView];
    
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(playerItemDidReachEnd:)
//     name:AVPlayerItemDidPlayToEndTimeNotification
//     object:[self.player currentItem]];

    
    [self loadAssetFromFile];
    
    
    
//    i think it's important to display the full stream before playback because visually it allows the patient to look at the biggest drop or peak in the audio levels and focus their attention in advance of hearing the audio that caused it. then when the audio plays back, you should provide a real-time updater (each audio level segment corresponds to .25 second sample, so draw a another highlight bar when that segment is being played) so that the patient can then be ready to hear to word(s) that caused this drop in volume or peak. 
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)syncUI {
    if ((self.player.currentItem != nil) &&
        ([self.player.currentItem status] == AVPlayerItemStatusReadyToPlay)) {
        self.playButton.enabled = YES;
    }
    else {
        self.playButton.enabled = NO;
    }
}

- (void)loadAssetFromFile {
    
  //add if we are observing then remove observer to prevent errors.
    
//    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mov"];
    
    if(self.fileURL){
        NSLog(@"valid url is %@", self.fileURL);
    }
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.fileURL options:nil];
    NSString *tracksKey = @"tracks";
    
    [asset loadValuesAsynchronouslyForKeys:@[tracksKey] completionHandler:
     ^{
         // The completion block goes here.
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            NSError *error;
                            AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];
                            
                            if (status == AVKeyValueStatusLoaded) {
                                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                                // ensure that this is done before the playerItem is associated with the player
                                [self.playerItem addObserver:self forKeyPath:@"status"
                                                     options:NSKeyValueObservingOptionInitial context:&ItemStatusContext];
                                
                                [[NSNotificationCenter defaultCenter] addObserver:self
                                                                         selector:@selector(playerItemDidReachEnd:)
                                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                                           object:self.playerItem];
                                
                                
        
                                
                                
                                
                                
                                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                                [self.playerView setPlayer:self.player];
                            }
                            else {
                                // You should deal with the error appropriately.
                                NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
                            }
                        });

     }];
    
    
    
    self.assetLength = CMTimeGetSeconds(asset.duration);
    NSLog(@"length of asset: %f sec", self.assetLength);
    [self playBackDrawing];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.player pause];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        
        if (self.player != nil && [self.player currentItem] != nil){
            [self.playerItem removeObserver:self forKeyPath:@"status"];
        }
        
        
        [self.audioSampleTimer invalidate];
        
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (context == &ItemStatusContext) {
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self syncUI];
                           
                       });
        return;
    }
    
    
    
    
    
    [super observeValueForKeyPath:keyPath ofObject:object
                           change:change context:context];
    return;
}

- (IBAction)play:sender {
    [self.player play];
    [self startAnimation];
    
}

-(void)startAnimation
{
    self.audioSampleTimer = [NSTimer scheduledTimerWithTimeInterval:SAMPLE_FREQ target:self selector:@selector(realTimeplayBackDrawing) userInfo:nil repeats:YES];

}

-(void)realTimeplayBackDrawing
{
    
    if (CMTimeGetSeconds(self.playerItem.currentTime) < self.assetLength && CMTimeGetSeconds(self.playerItem.currentTime) > 0) {
        NSLog(@"comparing this current time %f to total time %f", CMTimeGetSeconds(self.playerItem.currentTime), self.assetLength);
        
        
        float viewWidth = self.view.frame.size.width;
        float viewSamplePerSoundSample = viewWidth/[self.audioLevelSummary count];
        
        
            int spacer = 1;
            int baseHeight = self.view.frame.size.height-100;
            float barHeight = 90+[[self.audioLevelSummary objectAtIndex:self.playBackCounter] floatValue]; //-90 is the max decibel level on meter
            
            
            UIView * block = [[UIView alloc] initWithFrame:CGRectMake(self.playBackCounter*(spacer+viewSamplePerSoundSample), baseHeight-barHeight/2, viewSamplePerSoundSample-spacer, barHeight)];
            
            block.backgroundColor = [UIColor blueColor];
            [self.view addSubview:block];
            
        self.playBackCounter++;
        
        
        
        
    }

}

-(void)playBackDrawing
{
    float viewWidth = self.view.frame.size.width;
    NSLog(@"viewWidth is %f",  viewWidth);
    float viewSamplePerSoundSample = viewWidth/[self.audioLevelSummary count];
    int i;
    for (i = 0; i<[self.audioLevelSummary count]; i++) {
        
        int spacer = 1;
        int baseHeight = self.view.frame.size.height-100;
        float barHeight = 90+[[self.audioLevelSummary objectAtIndex:i] floatValue]; //-90 is the max decibel level on meter
    
        
        UIView * block = [[UIView alloc] initWithFrame:CGRectMake(i*(spacer+viewSamplePerSoundSample), baseHeight-barHeight/2, viewSamplePerSoundSample-spacer, barHeight)];
        
        block.backgroundColor = [UIColor blackColor];
        [self.view addSubview:block];
        
    }
    

}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
