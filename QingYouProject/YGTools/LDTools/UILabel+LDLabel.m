//
//  UILabel+LDLabel.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "UILabel+LDLabel.h"

@implementation UILabel (LDLabel)

+ (UILabel *)ld_labelWithTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAligement font:(UIFont *)font numberOfLines:(NSInteger)numberOflines{
    
    UILabel * label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.textAlignment = textAligement;
    label.font = font;
    label.numberOfLines = numberOflines;
    
    return label;
    
}

@end
