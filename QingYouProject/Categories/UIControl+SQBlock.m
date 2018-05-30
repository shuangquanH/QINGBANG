//
//  UIControl+SQBlock.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/30.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "UIControl+SQBlock.h"
#import <objc/runtime.h>

#define SQ_UICONTROL_EVENT(methodName, eventName)                                \
-(void)methodName : (void (^)(void))eventBlock {                              \
objc_setAssociatedObject(self, @selector(methodName:), eventBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);\
[self addTarget:self                                                        \
action:@selector(methodName##Action:)                                       \
forControlEvents:UIControlEvent##eventName];                                \
}                                                                               \
-(void)methodName##Action:(id)sender {                                        \
void (^block)(void) = objc_getAssociatedObject(self, @selector(methodName:));  \
if (block) {                                                                \
block();                                                                \
}                                                                           \
}


@implementation UIControl (SQBlock)


SQ_UICONTROL_EVENT(sq_touchDown, TouchDown)
SQ_UICONTROL_EVENT(sq_touchDownRepeat, TouchDownRepeat)
SQ_UICONTROL_EVENT(sq_touchDragInside, TouchDragInside)
SQ_UICONTROL_EVENT(sq_touchDragOutside, TouchDragOutside)
SQ_UICONTROL_EVENT(sq_touchDragEnter, TouchDragEnter)
SQ_UICONTROL_EVENT(sq_touchDragExit, TouchDragExit)
SQ_UICONTROL_EVENT(sq_touchUpInside, TouchUpInside)
SQ_UICONTROL_EVENT(sq_touchUpOutside, TouchUpOutside)
SQ_UICONTROL_EVENT(sq_touchCancel, TouchCancel)
SQ_UICONTROL_EVENT(sq_valueChanged, ValueChanged)
SQ_UICONTROL_EVENT(sq_editingDidBegin, EditingDidBegin)
SQ_UICONTROL_EVENT(sq_editingChanged, EditingChanged)
SQ_UICONTROL_EVENT(sq_editingDidEnd, EditingDidEnd)
SQ_UICONTROL_EVENT(sq_editingDidEndOnExit, EditingDidEndOnExit)


@end
