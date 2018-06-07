//
//  UIButton+LDButton.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LDButton)

+ (instancetype)buttonWithType:(UIButtonType) buttonType normalImage:(NSString *)normalImageStr selectedImage:(NSString *)selectedImageStr normalTitle:(NSString *)normalTitle selectedTitle:(NSString *)selectedTitle normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor backGroundColor:(UIColor *)backGroundColor normalBackGroundImageStr:(NSString *)normalBackGroundImageStr selectedBackGroundImageStr:(NSString *)selectedBackGroundImageStr titleFont:(CGFloat)fontNum;

+ (UIButton *)buttonWithTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)titleColor;
+ (UIButton *)buttonWithTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor;
+ (UIButton *)buttonWithTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)titleColor normalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage;

@end
