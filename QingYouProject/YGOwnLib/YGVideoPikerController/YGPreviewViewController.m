//
//  YGPreviewViewController.m
//  customvideo
//
//  Created by zhangkaifeng on 16/7/4.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGPreviewViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface YGPreviewViewController ()

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器

@end

@implementation YGPreviewViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [_moviePlayer stop];
    //点x说明不要 删掉
    [[NSFileManager defaultManager]removeItemAtPath:[_videoFileURL path] error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self configUI];
}

-(void)configUI
{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    //视频
    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:_videoFileURL];
    _moviePlayer.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _moviePlayer.view.backgroundColor = [UIColor clearColor];
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    _moviePlayer.repeatMode = MPMovieRepeatModeOne;
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer play];
    
    //视频大button
    UIButton *movieButton = [[UIButton alloc]initWithFrame:_moviePlayer.view.frame];
    [movieButton addTarget:self action:@selector(movieButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:movieButton];
    
    //x号
    //关闭按钮
    UIButton *xButton = [[UIButton alloc]init];
    [xButton setBackgroundImage:[UIImage imageNamed:@"xianzhi_luzhi_quxiao.png"] forState:UIControlStateNormal];
    [xButton sizeToFit];
    xButton.frame = CGRectMake(20, self.view.frame.size.height - 20 - xButton.frame.size.height, xButton.frame.size.width, xButton.frame.size.height);
    [xButton addTarget:self action:@selector(xButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xButton];
    
    //确认按钮
    UIButton *yesButton = [[UIButton alloc]init];
    [yesButton setBackgroundImage:[UIImage imageNamed:@"xianzhi_luzhi_right.png"] forState:UIControlStateNormal];
    [yesButton sizeToFit];
    yesButton.frame = CGRectMake(self.view.frame.size.width - yesButton.frame.size.width - xButton.frame.origin.x, xButton.frame.origin.y, yesButton.frame.size.width, yesButton.frame.size.height);
    [yesButton addTarget:self action:@selector(yesButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yesButton];
    
}

-(void)xButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)yesButtonClick
{
    NSString *MP4PathString = [NSTemporaryDirectory() stringByAppendingPathComponent:@"ygtempmovie.mp4"];
    //先把上次的删了
    [[NSFileManager defaultManager] removeItemAtPath:MP4PathString error:nil];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoFileURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    NSLog(@"%@",compatiblePresets);
    if ([compatiblePresets containsObject:AVAssetExportPreset640x480])
    {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
        exportSession.outputURL = [NSURL fileURLWithPath:MP4PathString];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     
                     //跳回主线程
                     [self performSelectorOnMainThread:@selector(completeConventWithPathString:) withObject:MP4PathString waitUntilDone:NO];
                 }
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCancelled:
                     
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     
                     break;
             }
             
         }];
        
        
    }
}

-(void)completeConventWithPathString:(NSString *)MP4PathString
{
    //显示缩略图
    UIImage *thumbImage = [self getImage:MP4PathString];
    //执行代理
    [_delegate YGPreviewViewController:self didPressYesButtonWithMP4FilePath:MP4PathString thumbImage:thumbImage];
}

-(void)movieButtonClick
{
    switch (_moviePlayer.playbackState) {
        case MPMoviePlaybackStateStopped: {
            [_moviePlayer play];
            break;
        }
        case MPMoviePlaybackStatePlaying: {
            [_moviePlayer pause];
            break;
        }
        case MPMoviePlaybackStatePaused: {
            [_moviePlayer play];
            break;
        }
        case MPMoviePlaybackStateInterrupted: {
            
            break;
        }
        case MPMoviePlaybackStateSeekingForward: {
            
            break;
        }
        case MPMoviePlaybackStateSeekingBackward: {
            
            break;
        }
    }
}

//缩略图
-(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}

@end
