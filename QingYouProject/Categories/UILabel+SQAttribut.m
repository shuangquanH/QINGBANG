//
//  UILabel+SQAttribut.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/11.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "UILabel+SQAttribut.h"
#import "NSMutableAttributedString+SQAttributColorFont.h"

@implementation UILabel (SQAttribut)
- (void)setText:(NSString   *)text appendImage:(UIImage *)image withType:(SQAppendImageType)type {
    NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc] initWithString:text];
    [mustring appendImage:image withType:type];
    self.attributedText = mustring;
}
- (void)setText:(NSString   *)text andFont:(UIFont *)font withRange:(NSRange)range {
    NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc] initWithString:text];
    [mustring setTextFont:font andRange:range];
    self.attributedText = mustring;
}
- (void)setText:(NSString   *)text andColor:(UIColor *)color withRange:(NSRange)range {
    NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc] initWithString:text];
    [mustring setTextColor:color andRange:range];
    self.attributedText = mustring;
}
- (void)setText:(NSString   *)text andTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range {
    NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc] initWithString:text];
    [mustring setTextColor:color andFont:font withRange:range];
    self.attributedText = mustring;
}

- (void)appendImage:(UIImage    *)image withType:(SQAppendImageType)type {
    NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc] initWithString:self.text];
    [mustring appendImage:image withType:type];
    self.attributedText = mustring;
}
- (void)setTextFont:(UIFont *)font andRange:(NSRange)range {
    NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc] initWithString:self.text];
    [mustring setTextFont:font andRange:range];
    self.attributedText = mustring;
}
- (void)setTextColor:(UIColor *)color andRange:(NSRange)range {
    NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc] initWithString:self.text];
    [mustring setTextColor:color andRange:range];
    self.attributedText = mustring;
}
- (void)setTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range {
    NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc] initWithString:self.text];
    [mustring setTextColor:color andFont:font withRange:range];
    self.attributedText = mustring;
}

@end
