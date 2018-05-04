//
//  UILabel+SizeToFit.h
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/28.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SizeToFit)

/**
 根据宽纵向自适应，多行

 @param width 宽
 */
- (void)sizeToFitVerticalWithMaxWidth:(float)width;

/**
 根据宽横向自适应，一行
 */
- (void)sizeToFitHorizontal;



- (void)addAttributedWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;

/**
 label多个颜色创建

 @param string label要显示的文字
 @param range 要更改文字颜色的区间
 @param color 要更改的颜色
 */
- (void)addAttributedWithString:(NSString *)string range:(NSRange)range color:(UIColor *)color;

/**
 计算文字宽度和高度
 
 @param string 传进来的文字
 @param font 字体
 @param numberOfLines 行数
 @return 文字的高度和宽度
 */
+ (CGSize)calculateWidthWithString:(NSString *)string textFont:(UIFont *)font numerOfLines:(NSInteger)numberOfLines;
+ (CGSize)calculateWidthWithString:(NSString *)string textFont:(UIFont *)font numerOfLines:(NSInteger)numberOfLines maxWidth:(float)maxWidth;

@end
