//
//  NSMutableAttributedString+SQAttributColorFont.h
//  QingYouProject
//
//  Created by qwuser on 2018/6/11.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (SQAttributColorFont)


- (void)setTextColor:(UIColor *)color andRange:(NSRange)range;

- (void)setTextFont:(UIFont *)font andRange:(NSRange)range;

- (void)setTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range;

@end
