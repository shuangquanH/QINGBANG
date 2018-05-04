//
//  UIView+Animate.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/9/26.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "UIView+Animate.h"

@implementation UIView (Animate)

-(void)showQAnimate
{
    //需要实现的帧动画,这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 0.5;
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:nil];
}

-(void)showFadeAnimate
{
    self.alpha = 0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.alpha = 1;
    } completion:nil];
}

@end
