//
//  NSString+SQAttributeString.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/28.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SQAttributeString)


/** 设置颜色并创建一个NSAttributedString  */
- (NSAttributedString *)setTextColor:(UIColor *)color andRange:(NSRange)range;

/** 设置字体并创建一个NSAttributedString  */
- (NSAttributedString *)setTextFont:(UIFont *)font andRange:(NSRange)range;

/** 设置颜色和字体并创建一个NSAttributedString  */
- (NSAttributedString *)setTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range;




/**通过string创建一个NSAttributedString index:分割点  */
- (NSAttributedString *)sqAttributeStringWithCutIndex:(NSInteger)index withLeftFont:(UIFont *)lfont rightFont:(UIFont *)rfont leftColor:(UIColor *)lcolor rightColor:(UIColor *)rcolor;



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


/** 不要用这个, 上上面的那个方法  */
- (NSAttributedString *)attributedStringFromNSString:(NSString *)normalString startLocation:(NSInteger)location forwardFont:(UIFont *)forwardFont backFont:(UIFont *)backFont forwardColor:(UIColor *)forwardColor backColor:(UIColor *)backColor;




- (NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace;


@end
