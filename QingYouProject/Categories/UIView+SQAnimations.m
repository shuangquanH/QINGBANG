//
//  UIView+SQAnimations.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/30.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "UIView+SQAnimations.h"

@implementation UIView (SQAnimations)

-(void)showQAnimate {
    //需要实现的帧动画,这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 0.5;
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:nil];
}

-(void)showFadeAnimate {
    self.alpha = 0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.alpha = 1;
    } completion:nil];
}

- (void)showWaveAnimation {
    [self showCATransitionAnimationWithType:@"rippleEffect" subtype:@"fromLeft"];
}

- (void)showExcursionAnimation {
    CATransform3D rotation = CATransform3DMakeTranslation(0 ,20 ,20);
    [self showCATransform3DAnimationWithRotation:rotation];
}

- (void)showRoateAnimation {
    CATransform3D rotation = CATransform3DMakeRotation(M_PI, 0, 0.5, 0.0);
    [self showCATransform3DAnimationWithRotation:rotation];
    //位置移动
    //    rotation = CATransform3DMakeTranslation(0 ,50 ,20);
    //3D旋转
    //    rotation = CATransform3DRotate(rotation,M_PI, 0, 0.5, 0.0);
    //逆时针旋转
    //    rotation =CATransform3DScale(rotation,0.9,0.9,1);
    //由远及近
    //    rotation.m34 =1.0/ -600;
    
    //    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    //    self.layer.shadowOffset =CGSizeMake(10,10);
    //    self.layer.shadowOffset =CGSizeMake(0,0);
}

- (void)showCATransform3DAnimationWithRotation:(CATransform3D)rotation {
    self.layer.transform = rotation;
    self.alpha =0.6;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.layer.transform =CATransform3DIdentity;
        self.alpha =1;
    }];
}

- (void)showCATransitionAnimationWithType:(NSString *)type subtype:(NSString *)subtype {
    CATransition *transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.duration = 1.0f;
    transition.type = type; // 指定动画类型 @"rippleEffect"
        transition.subtype = subtype; // 指定过渡方向@"fromLeft"
    // 设置开始和结束的进度，范围都是0.0-1.0
    transition.startProgress = 0.2f;
    transition.endProgress = 1.0f;
    NSString *keyStr = NSStringFromClass([self class]);
    [self.layer addAnimation:transition forKey:keyStr];
}

@end
