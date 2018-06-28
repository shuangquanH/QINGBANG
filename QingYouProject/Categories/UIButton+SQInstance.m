//
//  UIButton+SQInstance.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "UIButton+SQInstance.h"

@implementation UIButton (SQInstance)

+ (instancetype)buttonWithType:(UIButtonType) buttonType normalImage:(NSString *)normalImageStr selectedImage:(NSString *)selectedImageStr normalTitle:(NSString *)normalTitle selectedTitle:(NSString *)selectedTitle normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor backGroundColor:(UIColor *)backGroundColor normalBackGroundImageStr:(NSString *)normalBackGroundImageStr selectedBackGroundImageStr:(NSString *)selectedBackGroundImageStr titleFont:(CGFloat)fontNum{
    
    
    
    //创建button
    UIButton * button = [UIButton buttonWithType:buttonType];
    //设置背景图片
    normalBackGroundImageStr = normalBackGroundImageStr == nil ? @"" : normalBackGroundImageStr;
    
    selectedBackGroundImageStr = selectedBackGroundImageStr == nil ? @"" : selectedBackGroundImageStr;
    
    [button setBackgroundImage:[UIImage imageNamed:normalBackGroundImageStr] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:selectedBackGroundImageStr] forState:UIControlStateSelected];
    //设置背景颜色
    button.backgroundColor = backGroundColor == nil ? [UIColor whiteColor] :
    backGroundColor;
    
    //设置image
    normalImageStr = normalImageStr == nil ? @"" : normalImageStr;
    selectedImageStr = selectedImageStr == nil ? @"" : selectedImageStr;
    [button setImage:[UIImage imageNamed:normalImageStr] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImageStr] forState:UIControlStateSelected];
    
    //设置title
    normalTitle = normalTitle == nil ? @"" : normalTitle;
    selectedTitle = selectedTitle == nil ? @"" : selectedTitle;
    [button setTitle:normalTitle forState:UIControlStateNormal];
    [button setTitle:selectedTitle forState:UIControlStateSelected];
    
    //设置title字体颜色
    normalTitleColor = normalTitleColor == nil ? [UIColor whiteColor] : normalTitleColor;
    selectedTitleColor = selectedTitleColor == nil ? [UIColor whiteColor] : selectedTitleColor;
    [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [button setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontNum]];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)titleColor {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor {
    UIButton *btn = [UIButton buttonWithTitle:title titleFont:titleFont titleColor:titleColor];
    [btn setBackgroundColor:bgColor];
    return btn;
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleFont:(CGFloat)titleFont titleColor:(UIColor *)titleColor normalImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage {
    UIButton *button = [UIButton buttonWithTitle:title titleFont:titleFont titleColor:titleColor];
    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    if (highlightImage) {
        [button setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    }
    return button;
}


@end