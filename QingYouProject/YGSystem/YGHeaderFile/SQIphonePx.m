//
//  SQIphonePx.m
//  SQAPPSTART
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SQIphonePx.h"

@implementation SQIphonePx

+ (instancetype)shareInstance {
    static SQIphonePx *iphonePx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iphonePx = [[SQIphonePx alloc] init];
    });
    return iphonePx;
}

- (instancetype)init {
    if (self = [super init]) {
        _phoneWidth = [UIScreen mainScreen].bounds.size.width;
        _phoneHeight = [UIScreen mainScreen].bounds.size.height;
        _isiPhoneX = [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
        _navHeight = (_isiPhoneX == YES ? 88.0f : 64.0f);
        _tabHeight = (_isiPhoneX == YES ? 83.0f : 49.0f);
        _statuHeight = (_isiPhoneX == YES ? 44.0f : 20.0f);
        _uiScaling = (self.phoneWidth/750.0);
    }
    return self;
}


@end
