//
//  UILabel+LDLabel.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LDLabel)
+ (UILabel *)ld_labelWithTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAligement font:(UIFont *)font numberOfLines:(NSInteger)numberOflines;
@end
