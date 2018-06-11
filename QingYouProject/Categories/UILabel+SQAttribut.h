//
//  UILabel+SQAttribut.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/11.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSMutableAttributedString+AppendImage.h"

@interface UILabel (SQAttribut)

/** uilabel添加图片  */
- (void)appendImage:(UIImage    *)image withType:(SQAppendImageType)type;
/** 设置文字 并拼接图片  */
- (void)setText:(NSString   *)text appendImage:(UIImage *)image withType:(SQAppendImageType)type;


/** 设置颜色  */
- (void)setTextFont:(UIFont *)font andRange:(NSRange)range;
/** 设置文字并添加颜色  */
- (void)setText:(NSString   *)text andFont:(UIFont *)font withRange:(NSRange)range;


/** 设置字体  */
- (void)setTextColor:(UIColor *)color andRange:(NSRange)range;
/** 设置文字并改变字体  */
- (void)setText:(NSString   *)text andColor:(UIColor *)color withRange:(NSRange)range;


/** 设置颜色和字体  */
- (void)setTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range;
/** 设置文字并改变字体和颜色  */
- (void)setText:(NSString   *)text andTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range;



@end
