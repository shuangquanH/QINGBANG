//
//  YGButton.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/4/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGButton : UIButton

/**
 设置不同状态的背景色，目前仅支持selected和normal
 
 @param color 颜色
 @param state 按钮状态
 */
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

/**
 设置不同状态的边框色，目前仅支持selected和normal
 
 @param color 颜色
 @param state 按钮状态
 */
- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state;

@end
