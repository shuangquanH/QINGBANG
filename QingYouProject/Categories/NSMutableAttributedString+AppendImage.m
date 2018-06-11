//
//  NSMutableAttributedString+AppendImage.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "NSMutableAttributedString+AppendImage.h"

@implementation NSMutableAttributedString (AppendImage)

- (void)appendImage:(UIImage    *)image withType:(SQAppendImageType)type {
    
    //创建NSTextAttachment
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    if (type==SQAppendImageInLeft) {
        attachment.bounds = CGRectMake(-4, -4, image.size.width, image.size.height);
    } else {
        attachment.bounds = CGRectMake(4, -4, image.size.width, image.size.height);
    }
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    if (type==SQAppendImageInLeft) {
        [self insertAttributedString:attachmentString atIndex:0];
    } else {
        [self insertAttributedString:attachmentString atIndex:self.string.length];
    }
    
    
}

@end
