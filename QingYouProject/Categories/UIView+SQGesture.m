//
//  UIView+SQGesture.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/30.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "UIView+SQGesture.h"
#import <objc/runtime.h>
static char sq_kActionHandlerTapBlockKey;
static char sq_kActionHandlerTapGestureKey;
static char sq_kActionHandlerLongPressBlockKey;
static char sq_kActionHandlerLongPressGestureKey;

@implementation UIView (SQGesture)


- (void)sq_addTapActionWithBlock:(SQGestureActionBlock)block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &sq_kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sq_handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &sq_kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &sq_kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)sq_handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        SQGestureActionBlock block = objc_getAssociatedObject(self, &sq_kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}
- (void)sq_addLongPressActionWithBlock:(SQGestureActionBlock)block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &sq_kActionHandlerLongPressGestureKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sq_handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &sq_kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &sq_kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)sq_handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        SQGestureActionBlock block = objc_getAssociatedObject(self, &sq_kActionHandlerLongPressBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}


@end
