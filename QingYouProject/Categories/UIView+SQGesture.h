//
//  UIView+SQGesture.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/30.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SQGestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);


@interface UIView (SQGesture)

/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)sq_addTapActionWithBlock:(SQGestureActionBlock)block;
/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)sq_addLongPressActionWithBlock:(SQGestureActionBlock)block;

@end
