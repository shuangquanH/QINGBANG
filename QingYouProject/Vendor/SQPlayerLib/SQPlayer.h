//
//  SQPlayer.h
//  SQPlayerDemo
//
//  Created by qwer on 2017/2/9.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#ifndef SQPlayer_h
#define SQPlayer_h


#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 监听TableView的contentOffset
#define kSQPlayerViewContentOffset          @"contentOffset"
// 屏幕的宽
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 图片路径
#define SQPlayerSrcName(file)               [@"SQPlayer.bundle" stringByAppendingPathComponent:file]

#import "Masonry.h"
#import "SQPlayerView.h"
#import "SQPlayerControlView.h"


/** 是否显示返回按钮  */
#define KPLAYERSHOWBACKBUTTON 0

/** 是否显示全屏按钮  */
#define KPLAYERSHOWFULLSCREENBUTTON 1

/** 延时隐藏控制视图时间  */
#define SQPlayerAnimationTimeInterval 3

/** 显示控制视图动画时间  */
#define SQPlayerControlBarAutoFadeOutTimeInterval 0.3


#endif /* SQPlayer_h */
