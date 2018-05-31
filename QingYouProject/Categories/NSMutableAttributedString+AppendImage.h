//
//  NSMutableAttributedString+AppendImage.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SQAppendImageInLeft,
    SQAppendImageInRight
} SQAppendImageType;

@interface NSMutableAttributedString (AppendImage)

- (void)appendImage:(UIImage    *)image withType:(SQAppendImageType)type;

@end
