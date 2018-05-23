//
//  NSString+SQStringSize.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/21.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "NSString+SQStringSize.h"

@implementation NSString (SQStringSize)

- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size {
    //特殊的格式要求都写在属性字典中
    NSDictionary*attrs =@{NSFontAttributeName: font};
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return  [self  boundingRectWithSize:size  options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs   context:nil].size;
}
@end
