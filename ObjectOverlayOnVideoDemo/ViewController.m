//
//  ViewController.m
//  ObjectOverlayOnVideoDemo
//
//  Created by Krupa-iMac on 06/05/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize vwVideo;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnStartProcessingClicked:(id)sender
{
    [sender setHidden:YES];
    [self editVideo];
}

- (void) editVideo
{
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"Missile_Preview" withExtension:@"m4v"];
    
    movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
    movieFile.runBenchmark = YES;
    movieFile.playAtActualSpeed = NO;
    
    filter = [[GPUImageBrightnessFilter alloc] init];
    [(GPUImageBrightnessFilter*)filter setBrightness:0.0];
    
    GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    blendFilter.mix = 1.0;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-20)];
    contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *ivTemp = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 147, 59)];
    ivTemp.image = [UIImage imageNamed:@"logo.png"];
    [contentView addSubview:ivTemp];
    
    UILabel *lblDemo = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    lblDemo.text = @"Blast";
    lblDemo.font = [UIFont systemFontOfSize:30];
    lblDemo.textColor = [UIColor redColor];
    lblDemo.tag = 1;
    lblDemo.hidden = YES;
    lblDemo.backgroundColor = [UIColor clearColor];
    [contentView addSubview:lblDemo];
    
    uiElementInput = [[GPUImageUIElement alloc] initWithView:contentView];
    [filter addTarget:blendFilter];
    [uiElementInput addTarget:blendFilter];
    
    [movieFile addTarget:filter];
    
    // Only rotate the video for display, leave orientation the same for recording
    GPUImageView *filterView = (GPUImageView *)vwVideo;
    [filter addTarget:filterView];
    [blendFilter addTarget:filterView];
    
    [filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
        if (frameTime.value/frameTime.timescale == 2) {
            [contentView viewWithTag:1].hidden = NO;
        }
        [uiElementInput update];
    }];
    
    // In addition to displaying to the screen, write out a processed version of the movie to disk
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:pathToMovie] size:CGSizeMake(640.0, 480.0)];
    [filter addTarget:movieWriter];
    [blendFilter addTarget:movieWriter];
    
    // Configure this for video from the movie file, where we want to preserve all video frames and audio samples
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    [movieWriter setCompletionBlock:^{
        UISaveVideoAtPathToSavedPhotosAlbum(pathToMovie, nil, nil, nil);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
