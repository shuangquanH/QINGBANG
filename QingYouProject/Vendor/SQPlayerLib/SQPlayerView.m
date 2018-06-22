//
//  SQPlayerView.m
//  SQPlayerDemo
//
//  Created by qwer on 2017/2/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "SQPlayerView.h"

// 手势的方向，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};
// 播放器的几种状态
typedef NS_ENUM(NSInteger, SQPlayerState) {
    SQPlayerStateFailed,     // 播放失败
    SQPlayerStateBuffering,  // 缓冲中
    SQPlayerStatePlaying,    // 播放中
    SQPlayerStateStopped,    // 停止播放
    SQPlayerStatePause       // 暂停播放
};

@interface SQPlayerView ()<UIGestureRecognizerDelegate,UIAlertViewDelegate>



/** 播放属性 */
@property (nonatomic, strong) AVPlayer            *player;
/** 播放属性 */
@property (nonatomic, strong) AVPlayerItem        *playerItem;

/** 滑杆 */
@property (nonatomic, strong) UISlider            *volumeViewSlider;
/** 用来保存快进的总时长 */
@property (nonatomic, assign) CGFloat             sumTime;
/** 定义一个实例变量，保存枚举值 */
@property (nonatomic, assign) PanDirection        panDirection;
/** 播发器的几种状态 */
@property (nonatomic, assign) SQPlayerState       state;
/** 是否为全屏 */
@property (nonatomic, assign) BOOL                isFullScreen;
/** 是否显示controlView*/
@property (nonatomic, assign) BOOL                isMaskShowing;
/** 是否被用户暂停 */
@property (nonatomic, assign) BOOL                isPauseByUser;
/** slider上次的值 */
@property (nonatomic, assign) CGFloat             sliderLastValue;
/** 是否再次设置URL播放视频 */
@property (nonatomic, assign) BOOL                repeatToPlay;
/** 播放完了*/
@property (nonatomic, assign) BOOL                playDidEnd;
/** 进入后台*/
@property (nonatomic, assign) BOOL                didEnterBackground;
/** 是否自动播放 */
@property (nonatomic, assign) BOOL                isAutoPlay;

@property (nonatomic, assign) CGRect            startFrame;
@property (nonatomic, weak) UIView            *startView;

@end

@implementation SQPlayerView

#pragma mark -初始化和dealloc方法
/***单例，用于列表cell上多个视频*/
+ (instancetype)sharedPlayerView{
    static SQPlayerView *playerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[SQPlayerView alloc] init];
    });
    return playerView;
}
/***代码初始化调用此方法*/
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initializeThePlayer];
    }
    return self;
}
/***storyboard、xib加载playerView会调用此方法*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [self initializeThePlayer];
}
/***初始化player*/
- (void)initializeThePlayer{
    //每次开始播放时都设置屏幕为竖直方向
    if (self.isFullScreen) {
        [self backToNormalWindowPlayer];
    }
}
- (void)dealloc{
    self.playerItem = nil;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - layoutSubviews方法，屏幕旋转就会调用该方法
- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 只要屏幕旋转就显示控制层
    self.isMaskShowing = NO;
    // 延迟隐藏controlView
    [self animateShow];
    // 4s，屏幕宽高比不是16：9的问题,player加到控制器上时候
    if (iPhone4s) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(ScreenWidth*2/3);
        }];
    }
    // fix iOS7 crash bug
    [self layoutIfNeeded];
    
    if (!self.startFrame.size.height) {
        self.startFrame = self.frame;
        self.startView = self.superview;
    }
}



#pragma mark - 对外提供的方法
/**
 设置自动播放
 */
- (void)autoPlayTheVideo{
    self.isAutoPlay = YES;
    //配置播放器相关播放信息
    [self configSQPlayer];
    self.state = SQPlayerStateBuffering;
}
/**
 设置播放器相关播放信息
 */
- (void)configSQPlayer{
    //playerItem的set方法中添加缓冲和播放相关状态监控
    self.playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    self.state = SQPlayerStateBuffering;
    //初始化显示控制层
    self.isMaskShowing = YES;
    //延时隐藏控制层
    [self autoFadeOutControlBar];
    
    //添加单双击手势
    [self createGesture];
    // 添加播放进度计时器
    [self createTimer];
    //    //开始播放
    [self play];
    self.controlView.startBtn.selected = YES;
    
    self.isPauseByUser                 = NO;
    self.controlView.playeBtn.hidden   = YES;
    
    // 强制让系统调用layoutSubviews 两个方法必须同时写
    [self setNeedsLayout]; //是标记 异步刷新 会调但是慢
    [self layoutIfNeeded]; //加上此代码立刻刷新
}

/**
 *  重置player
 */
- (void)resetPlayer{
    // 改为未播放完
    self.playDidEnd         = NO;
    self.playerItem         = nil;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    self.isAutoPlay         = NO;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    
    //MARK:重新播放的重点
    // 移除原来的layer
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.player = nil;
    // 重置控制层View
    [self.controlView resetControlView];
    
    // 非重播时，移除当前playerView
    if (!self.repeatToPlay) { [self removeFromSuperview]; }
}
/**
 *  在当前页面，设置新的Player的URL调用此方法
 */
- (void)resetToPlayNewURL{
    self.repeatToPlay = YES;
    [self resetPlayer];
}

#pragma mark -定时器
/**
 添加定时器，控制滑竿移动，以及播放时间显示
 */
- (void)createTimer{
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0){
            // 当前时长进度progress
            NSInteger proMin                       = (NSInteger)CMTimeGetSeconds([currentItem currentTime]) / 60;//当前秒
            NSInteger proSec                       = (NSInteger)CMTimeGetSeconds([currentItem currentTime]) % 60;//当前分钟
            // duration 总时长
            NSInteger durMin                       = (NSInteger)currentItem.duration.value / currentItem.duration.timescale / 60;//总秒
            NSInteger durSec                       = (NSInteger)currentItem.duration.value / currentItem.duration.timescale % 60;//总分钟
            // 更新slider
            weakSelf.controlView.videoSlider.value     = CMTimeGetSeconds([currentItem currentTime]) / (currentItem.duration.value / currentItem.duration.timescale);
            // 更新当前播放时间
            weakSelf.controlView.currentTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
            // 更新总时间
            weakSelf.controlView.totalTimeLabel.text   = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        }
    }];
}



#pragma mark- 手势事件和控制层控件事件
/**
 单击控制显示层显示和隐藏事件
 */
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        self.isMaskShowing ? ([self hideControlView]) : ([self animateShow]);
    }
}
/**
 *  双击控制播放和暂停手势
 */
- (void)doubleTapAction:(UITapGestureRecognizer *)gesture{
    // 显示控制层
    [self animateShow];
    [self startAction:self.controlView.startBtn];
}
/**
 *  左下角播放或暂停按钮事件
 */
- (void)startAction:(UIButton *)button{
    button.selected    = !button.selected;
    self.isPauseByUser = !self.isPauseByUser;
    if (button.selected) {
        [self play];
        if (self.state == SQPlayerStatePause) { self.state = SQPlayerStatePlaying; }
    } else {
        [self pause];
        if (self.state == SQPlayerStatePlaying) { self.state = SQPlayerStatePause;}
    }
}
/**
 播放方法
 */
- (void)play{
    self.controlView.startBtn.selected = YES;
    self.isPauseByUser = NO;
    
    if (self.playerItem) {
        [_player play];
    } else {
        [self configSQPlayer];
    }
}
/**
 暂停方法
 */
- (void)pause{
    self.controlView.startBtn.selected = NO;
    self.isPauseByUser = YES;
    [_player pause];
}
/**
 *  返回按钮点击事件
 说明：如果处于全屏状态，点击返回变为竖屏状态。如果为竖屏状态点击返回则变成横屏状态。
 */
- (void)backButtonAction{
    //非全屏状态
    if (!self.isFullScreen) {
        // player加到控制器上，只有一个player时候
        [self pause];
        if (self.goBackBlock) {
            self.goBackBlock();
        }
    }else {//全屏状态
        [self backToNormalWindowPlayer];
    }
}

/**
 全屏按钮点击事件
 */
- (void)fullScreenAction:(UIButton *)sender{
    if (_isCellVideo) {
        if (_fullScreenBtnBlock) {
            self.fullScreenBtnBlock(sender);
            return;
        }
    }
    sender.selected = !sender.selected;
    self.isFullScreen = sender.selected;
    (self.isFullScreen)?[self changeToFullScreenPlayer]:[self backToNormalWindowPlayer];
}

/** 切换到全屏  */
- (void)changeToFullScreenPlayer {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self layoutIfNeeded];
    self.controlView.fullScreenBtn.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        self.controlView.fullScreenBtn.hidden = NO;
    }];
}

/** 恢复窗口播放  */
- (void)backToNormalWindowPlayer {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self removeFromSuperview];
    [self.startView addSubview:self];
    [self layoutIfNeeded];
    self.controlView.fullScreenBtn.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.frame = self.startFrame;
    } completion:^(BOOL finished) {
        self.controlView.fullScreenBtn.hidden = NO;
    }];
}
/**
 重播按钮回调事件
 */
- (void)repeatPlay:(UIButton *)sender{
    // 没有播放完
    self.playDidEnd    = NO;
    // 重播改为NO
    self.repeatToPlay  = NO;
    // 准备显示控制层
    self.isMaskShowing = NO;
    [self animateShow];
    // 重置控制层View
    [self.controlView resetControlView];
    [self.controlView.activity stopAnimating];
    [self seekToTime:0 completionHandler:nil];
}

#pragma mark - UISlider相关事件
/**
 开始滑动slider
 */
- (void)progressSliderTouchBegan:(UISlider *)slider{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
/**
 slider滑动中事件 （滑动中暂停播放）
 */
- (void)progressSliderValueChanged:(UISlider *)slider{
    //拖动改变视频播放进度
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        NSString *style = @"";
        CGFloat value   = slider.value - self.sliderLastValue;
        if (value > 0) { style = @">>"; }
        if (value < 0) { style = @"<<"; }
        if (value == 0) { return; }
        self.sliderLastValue    = slider.value;
        // 暂停
        [self pause];
        CGFloat total           = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime     = CMTimeMake(dragedSeconds, 1);
        // 拖拽的时长
        NSInteger proMin        = (NSInteger)CMTimeGetSeconds(dragedCMTime) / 60;//当前秒
        NSInteger proSec        = (NSInteger)CMTimeGetSeconds(dragedCMTime) % 60;//当前分钟
        //duration 总时长
        NSInteger durMin        = (NSInteger)total / 60;//总秒
        NSInteger durSec        = (NSInteger)total % 60;//总分钟
        NSString *currentTime   = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        NSString *totalTime     = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        if (total > 0) {
            // 当总时长 > 0时候才能拖动slider
            self.controlView.currentTimeLabel.text  = currentTime;
            self.controlView.horizontalLabel.hidden = NO;
            self.controlView.horizontalLabel.text   = [NSString stringWithFormat:@"%@ %@ / %@",style, currentTime, totalTime];
        }else {
            // 此时设置slider值为0
            slider.value = 0;
        }
    }else { // player状态加载失败
        // 此时设置slider值为0
        slider.value = 0;
    }
}
/**
 *  slider结束滑动事件（开始播放特定时间的视频）
 */
- (void)progressSliderTouchEnded:(UISlider *)slider{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.controlView.horizontalLabel.hidden = YES;
        });
        // 结束滑动时候把开始播放按钮改为播放状态
        self.controlView.startBtn.selected = YES;
        self.isPauseByUser                 = NO;
        // 滑动结束延时隐藏controlView
        [self autoFadeOutControlBar];
        // 视频总时间长度
        CGFloat total           = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        [self seekToTime:dragedSeconds completionHandler:nil];
    }
}
/**
 *  从多少秒开始播放视频
 */
- (void)seekToTime:(NSInteger)dragedSeconds completionHandler:(void (^)(BOOL finished))completionHandler{
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [self.player seekToTime:dragedCMTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            // 视频跳转回调
            if (completionHandler) { completionHandler(finished); }
            [self play];
            self.seekTime = 0;
            //缓冲状态
            if (!self.playerItem.isPlaybackLikelyToKeepUp) { self.state = SQPlayerStateBuffering; }
        }];
    }
}



#pragma mark -进入后台和前台相关通知
/**
 *  退到后台
 */
- (void)appDidEnterBackground
{
    self.didEnterBackground = YES;
    [_player pause];
    self.state = SQPlayerStatePause;
    [self cancelAutoFadeOutControlBar];
    self.controlView.startBtn.selected = NO;
}
/**
 *  进入前台
 */
- (void)appDidEnterPlayGround{
    self.didEnterBackground = NO;
    self.isMaskShowing = NO;
    // 延迟隐藏controlView
    [self animateShow];
    if (!self.isPauseByUser) {
        self.state                         = SQPlayerStatePlaying;
        self.controlView.startBtn.selected = YES;
        self.isPauseByUser                 = NO;
        [self play];
    }
}



#pragma mark - 当前视屏播放完毕的通知
/**
 *  当前视屏播放完毕的通知
 */
- (void)moviePlayDidEnd:(NSNotification *)notification{
    self.state            = SQPlayerStateStopped;
    //如果实在cell上播放，调用播放完成的回调
    if (_isCellVideo) {
        if (self.playCompletedBlock) {
            self.playCompletedBlock();
            return;
        }
    }
    
    //更改背景颜色，产生蒙板效果
    self.controlView.backgroundColor  = RGBA(0, 0, 0, .6);
    self.playDidEnd                   = YES;
    //显示重播按钮
    self.controlView.repeatBtn.hidden = NO;
    // 初始化显示controlView为YES
    self.isMaskShowing                = NO;
    // 延迟隐藏controlView
    // 播放完了，隐藏控制层的上部和底部，不包含返回和重播按钮
    [self animateShow];
}




#pragma mark - 显示或隐藏ControlView
- (void)autoFadeOutControlBar{
    if (!self.isMaskShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
    [self performSelector:@selector(hideControlView) withObject:nil afterDelay:SQPlayerAnimationTimeInterval];
}
/***取消延时隐藏controlView的方法*/
- (void)cancelAutoFadeOutControlBar{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
/***隐藏控制层*/
- (void)hideControlView{
    if (!self.isMaskShowing) { return; }
    [UIView animateWithDuration:SQPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self.controlView hideControlView];
        if (self.isFullScreen) { //全屏状态
            self.controlView.backBtn.alpha = 0;
        }else {
            self.controlView.backBtn.alpha = 0;
        }
    }completion:^(BOOL finished) {
        self.isMaskShowing = NO;
    }];
}
/***动画显示控制层*/
- (void)animateShow{
    if (self.isMaskShowing) { return; }
    [UIView animateWithDuration:SQPlayerControlBarAutoFadeOutTimeInterval animations:^{
        self.controlView.backBtn.alpha = 1;
        if (self.playDidEnd) {
            [self.controlView hideControlView];
        } // 播放完了，隐藏控制层的上部和底部，不包含返回和重播按钮
        else { [self.controlView showControlView]; }
    } completion:^(BOOL finished) {
        self.isMaskShowing = YES;
        [self autoFadeOutControlBar];
    }];
}




#pragma mark - 观察者、通知、控制层控件添加相关事件
/**
 *  添加观察者、通知、控制层控件添加相关事件
 */
- (void)addNotifications{
    // 退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    //进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    // slider开始滑动事件
    [self.controlView.videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    // slider滑动中事件
    [self.controlView.videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    // slider结束滑动事件
    [self.controlView.videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    // 播放按钮点击事件
    [self.controlView.startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 返回按钮点击事件
    [self.controlView.backBtn addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    // 全屏按钮点击事件
    [self.controlView.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    // 重播
    [self.controlView.repeatBtn addTarget:self action:@selector(repeatPlay:) forControlEvents:UIControlEventTouchUpInside];
    // 中间按钮播放
    [self.controlView.playeBtn addTarget:self action:@selector(configSQPlayer) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self) weakSelf = self;
    // 点击slider快进
    self.controlView.tapBlock = ^(CGFloat value) {
        [weakSelf pause];
        // 视频总时间长度
        CGFloat total           = (CGFloat)weakSelf.playerItem.duration.value / weakSelf.playerItem.duration.timescale;
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * value);
        weakSelf.controlView.startBtn.selected = YES;
        [weakSelf seekToTime:dragedSeconds completionHandler:^(BOOL finished) {}];
    };
}




#pragma mark - KVO监听视频的播放和缓冲状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                self.state = SQPlayerStatePlaying;
                //MARK:-暂时没有添加拖动手势
                // 加载完成后，再添加平移手势
                // 添加平移手势，用来控制音量、亮度、快进快退
                //                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
                //                pan.delegate                = self;
                //                [self addGestureRecognizer:pan];
                // 跳到多少秒播放视频
                if (self.seekTime) {
                    [self seekToTime:self.seekTime completionHandler:nil];
                }
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed){
                self.state = SQPlayerStateFailed;
                NSError *error = [self.player.currentItem error];
                NSLog(@"视频加载失败===%@",error.description);
                self.controlView.horizontalLabel.hidden = NO;
                self.controlView.horizontalLabel.text = @"视频加载失败";
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            [self.controlView.progressView setProgress:timeInterval / totalDuration animated:NO];
            // 如果缓冲和当前slider的差值超过0.1,自动播放，解决弱网情况下不会自动播放问题
            if (!self.isPauseByUser && !self.didEnterBackground && (self.controlView.progressView.progress-self.controlView.videoSlider.value > 0.05)) {
                [self play];
            }
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            // 当缓冲是空的时候
            if (self.playerItem.playbackBufferEmpty) {
                self.state = SQPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            // 当缓冲好的时候
            if (self.playerItem.playbackLikelyToKeepUp && self.state == SQPlayerStateBuffering){
                self.state = SQPlayerStatePlaying;
            }
        }
    }
}
/**
 *  计算缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond{
    
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    [self.controlView.activity startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 如果此时用户已经暂停了，则不再需要开启播放了
        if (self.isPauseByUser) {
            isBuffering = NO;
            return;
        }
        [self play];
        [self.controlView.activity stopAnimating];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingSomeSecond]; }
    });
}



#pragma mark - 懒加载
/**
 控制层懒加载方法
 */
- (SQPlayerControlView *)controlView{
    if (!_controlView) {
        _controlView = [[SQPlayerControlView alloc] init];
        [self addSubview:_controlView];
        _controlView.frame = self.bounds;
        [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.bottom.equalTo(self);
        }];
    }
    return _controlView;
}


#pragma mark -setter方法
/**
 *  设置视频播放的URL地址
 注意：设置播放地址URL时，内部会调用品目方向发生变化的方法。
 */
- (void)setVideoURL:(NSURL *)videoURL{
    _videoURL = videoURL;
    //如果没有设置占位图，则设置默认占位图
    if (!self.placeholderImageName) {
        UIImage *image = [UIImage imageNamed:SQPlayerSrcName(@"ZFPlayer_loading_bgView")];
        self.layer.contents = (id) image.CGImage;
    }
    // 每次加载视频URL都设置重播为NO
    self.repeatToPlay = NO;
    self.playDidEnd   = NO;
    [self addNotifications];
    
    // 根据屏幕的方向设置相关UI
    if (self.isFullScreen) {
        [self backToNormalWindowPlayer];
    }
    self.isPauseByUser = YES;
    self.controlView.playeBtn.hidden = NO;
    [self.controlView hideControlView];
}
/**
 设置占位图
 */
- (void)setPlaceholderImageName:(NSString *)placeholderImageName{
    _placeholderImageName = placeholderImageName;
    if (placeholderImageName) {//如果外部设置了，就使用外部的图片
        UIImage *image = [UIImage imageNamed:self.placeholderImageName];
        self.layer.contents = (id) image.CGImage;
    }
}
/*
 设置视频的填充模式
 */
- (void)setPlayerLayerGravity:(SQPlayerLayerGravity)playerLayerGravity{
    _playerLayerGravity = playerLayerGravity;
    // AVLayerVideoGravityResize 非均匀模式。两个维度完全填充至整个视图区域
    // AVLayerVideoGravityResizeAspect 等比例填充，直到一个维度到达区域边界
    // AVLayerVideoGravityResizeAspectFill 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
    switch (playerLayerGravity) {
        case SQPlayerLayerGravityResize:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case SQPlayerLayerGravityResizeAspect:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case SQPlayerLayerGravityResizeAspectFill:
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        default:
            break;
    }
}
/**
 *  设置播放的状态
 */
- (void)setState:(SQPlayerState)state{
    _state = state;
    // 处于播放状态的时候改为黑色的背景，遮挡住占位图；否则因为视频填充模式的缘故会露出占位图
    if (state == SQPlayerStatePlaying) {
        UIImage *image = [self buttonImageFromColor:[UIColor blackColor]];
        self.layer.contents = (id) image.CGImage;
        
    } else if (state == SQPlayerStateFailed) {
        
    }
    // 控制菊花显示、隐藏
    //首次这里没有调用？？？？？？？？
    state == SQPlayerStateBuffering ? ([self.controlView.activity startAnimating]) : ([self.controlView.activity stopAnimating]);
}
/**
 *  根据playerItem，来添加移除观察者。监听播放状态（播放完毕、播放中、失败、暂停）、缓存状态。
 缓存不足够时要暂停播放，播放结束，显示重新播放和返回按钮，其他控件隐藏
 */
- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    //当_playerItem没有变化的时候，就不用再次添加、移除观察者了
    if (_playerItem == playerItem) {return;}
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}


#pragma mark - other
/**
 *  创建单击和双击手势
 */
- (void)createGesture{
    // 单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    // 双击(播放/暂停)
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];
}
/**
 *  通过颜色来生成一个纯色图片
 */
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}



@end

