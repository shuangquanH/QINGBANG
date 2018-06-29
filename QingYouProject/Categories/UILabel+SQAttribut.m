//
//  UILabel+SQAttribut.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/11.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "UILabel+SQAttribut.h"
#import "NSString+SQAttributeString.h"

@implementation UILabel (SQAttribut)
- (void)setText:(NSString   *)text appendImage:(UIImage *)image withType:(SQAppendImageType)type {
    NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc] initWithString:text];
    [mustring appendImage:image withType:type];
    self.attributedText = mustring;
}
- (void)setText:(NSString   *)text andFont:(UIFont *)font withRange:(NSRange)range {
    NSAttributedString *mustring = [text setTextFont:font andRange:range];
    self.attributedText = mustring;
}
- (void)setText:(NSString   *)text andColor:(UIColor *)color withRange:(NSRange)range {
    NSAttributedString *mustring = [text setTextColor:color andRange:range];
    self.attributedText = mustring;
}
- (void)setText:(NSString   *)text andTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range {
    NSAttributedString *mustring = [text setTextColor:color andFont:font withRange:range];
    self.attributedText = mustring;
}

- (void)appendImage:(UIImage    *)image withType:(SQAppendImageType)type {
    NSMutableAttributedString *mustring = (self.attributedText)?self.attributedText.mutableCopy:[[NSMutableAttributedString alloc] initWithString:self.text];
    [self labelAppendImage:image withType:type mutubleString:mustring];
    self.attributedText = mustring;
}
- (void)appendImage:(UIImage *)image imageFrame:(CGRect)imageFrame withType:(SQAppendImageType)type {
    NSMutableAttributedString *mustring = (self.attributedText)?self.attributedText.mutableCopy:[[NSMutableAttributedString alloc] initWithString:self.text];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    if (type==SQAppendImageInLeft) {
        attachment.bounds = imageFrame;
        [mustring insertAttributedString:attachmentString atIndex:0];
    } else {
        attachment.bounds = imageFrame;
        [mustring insertAttributedString:attachmentString atIndex:mustring.length];
    }
    self.attributedText = mustring;
}
- (void)setTextFont:(UIFont *)font andRange:(NSRange)range {
    NSAttributedString *mustring = [self.text setTextFont:font andRange:range];
    self.attributedText = mustring;
}
- (void)setTextColor:(UIColor *)color andRange:(NSRange)range {
NSAttributedString *mustring = [self.text setTextColor:color andRange:range];
    self.attributedText = mustring;
}
- (void)setTextColor:(UIColor *)color andFont:(UIFont *)font withRange:(NSRange)range {
    NSAttributedString *mustring = [self.text setTextColor:color andFont:font withRange:range];
    self.attributedText = mustring;
}

- (void)labelAppendImage:(UIImage *)image withType:(SQAppendImageType)type mutubleString:(NSMutableAttributedString *)mustring {
    //创建NSTextAttachment
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    CGFloat imgH = self.font.pointSize;
    CGFloat imgW = (image.size.width / image.size.height) * imgH;
    CGFloat textPaddingTop = (self.font.lineHeight - self.font.pointSize) / 2;
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    if (type==SQAppendImageInLeft) {
        attachment.bounds = CGRectMake(0, -textPaddingTop , imgW, imgH);
        [mustring insertAttributedString:attachmentString atIndex:0];
    } else {
        attachment.bounds = CGRectMake(0, -textPaddingTop , imgW, imgH);
        [mustring insertAttributedString:attachmentString atIndex:mustring.length];
    }
}

@end
