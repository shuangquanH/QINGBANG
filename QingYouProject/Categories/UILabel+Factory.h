//
//  UILabel+Factory.h
//  HaveCar
//
//  Created by yzl on 17/9/17.
//  Copyright © 2017年 lwk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Factory)

+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor;
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text;
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment;
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text;


+ (UILabel *)ld_labelWithTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAligement font:(UIFont *)font numberOfLines:(NSInteger)numberOflines;

@end
