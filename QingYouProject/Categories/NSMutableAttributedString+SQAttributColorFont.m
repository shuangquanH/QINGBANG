//
//  NSMutableAttributedString+SQAttributColorFont.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/11.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "NSMutableAttributedString+SQAttributColorFont.h"

@implementation NSMutableAttributedString (SQAttributColorFont)


- (void)setTextColor:(UIColor *)color andRange:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName
                 value:color
                 range:range];
}

- (void)setTextFont:(UIFont *)font andRange:(NSRange)range {
    [self addAttribute:NSFontAttributeName
                value:font
                range:range];
}

- (void)setTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range {
    [self setTextColor:color andRange:range];
    [self setTextFont:font andRange:range];
}


@end
