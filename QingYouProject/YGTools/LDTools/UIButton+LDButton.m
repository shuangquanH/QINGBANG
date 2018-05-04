//
//  UIButton+LDButton.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "UIButton+LDButton.h"

@implementation UIButton (LDButton)
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
@end
