//
//  UILabel+Factory.m
//  HaveCar
//
//  Created by yzl on 17/9/17.
//  Copyright © 2017年 lwk. All rights reserved.
//

#import "UILabel+Factory.h"

@implementation UILabel (Factory)
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.numberOfLines = 0;
    [label sizeToFit];
    return label;
}
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor];
    label.text = text;
    return label;
}
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor];
    label.textAlignment = textAlignment;
    return label;
}
+ (UILabel *)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text {
    UILabel *label = [UILabel labelWithFont:font textColor:textColor text:text];
    label.textAlignment = textAlignment;
    return label;
}

+ (UILabel *)ld_labelWithTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAligement font:(UIFont *)font numberOfLines:(NSInteger)numberOflines{
    
    UILabel * label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.textAlignment = textAligement;
    label.font = font;
    label.numberOfLines = numberOflines;
    
    return label;
    
}

@end
