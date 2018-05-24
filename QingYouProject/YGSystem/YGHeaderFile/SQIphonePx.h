//
//  SQIphonePx.h
//  SQAPPSTART
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SQIphonePx : NSObject

+ (instancetype)shareInstance;



@property (nonatomic, assign) CGFloat   phoneWidth;

@property (nonatomic, assign) CGFloat   phoneHeight;

@property (nonatomic, assign) CGFloat   navHeight;

@property (nonatomic, assign) CGFloat   tabHeight;

@property (nonatomic, assign) CGFloat   statuHeight;

/// 是否是iPhoneX
@property (nonatomic, assign) BOOL      isiPhoneX;

/// 相对UI设计图缩放比例
@property (nonatomic, assign) CGFloat   uiScaling;



@end
