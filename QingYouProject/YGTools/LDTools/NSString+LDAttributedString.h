//
//  NSString+LDAttributedString.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LDAttributedString)

/**
 
 通过一个 NSString对象 创建一个 NSAttributedString对象
 注意 : location 要大于字符串的长度,否则会崩溃
 这个方法封装的是 两种不同样式的富文本效果,例如 A 和 B两种样式
 @param normalString 普通字符串
 @param location 不同样式的字符串开始字符的位置
 @param forwardFont 前一种样式(A)的字体
 @param backFont 后一种样式(B)的字体
 @param forwardColor 前一种样式(A)字体颜色
 @param backColor 后一种样式(A)字体颜色
 @return 返回一个 NSAttributedString 对象
 */
- (NSAttributedString *)ld_attributedStringFromNSString:(NSString *)normalString startLocation:(NSInteger)location forwardFont:(UIFont *)forwardFont backFont:(UIFont *)backFont forwardColor:(UIColor *)forwardColor backColor:(UIColor *)backColor;




- (NSAttributedString *)ld_getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;

@end
