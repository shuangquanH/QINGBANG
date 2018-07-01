//
//  UIView+SQAnimations.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/30.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SQAnimations)



//q弹效果
-(void)showQAnimate;

//渐变效果
-(void)showFadeAnimate;

/** 水波动画  */
- (void)showWaveAnimation;

/** 3D旋转动画  */
- (void)showRoateAnimation;

/** 从下向上偏移动画  */
- (void)showExcursionAnimation;


@end
