//
//  UIButton+SQImagePosition.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  button图片位置

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SQImagePositionLeft = 0,              //图片在左，文字在右，默认
    SQImagePositionRight = 1,             //图片在右，文字在左
    SQImagePositionTop = 2,               //图片在上，文字在下
    SQImagePositionBottom = 3,            //图片在下，文字在上
} SQButtonImagePositionType;

@interface UIButton (SQImagePosition)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)sq_setImagePosition:(SQButtonImagePositionType)postion spacing:(CGFloat)spacing;

@end
