//
//  UITextField+YG.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/4/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "UITextField+YG.h"
#import <objc/runtime.h>

static void *limitTextLengthKey = &limitTextLengthKey;
static void *tempIntegerKey = &limitTextLengthKey;
static void *placeHolderColorKey = &placeHolderColorKey;

@implementation UITextField (YG)

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    [self setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    objc_setAssociatedObject(self, &placeHolderColorKey, placeHolderColor, OBJC_ASSOCIATION_COPY);
}

- (UIColor *)placeHolderColor
{
    return objc_getAssociatedObject(self, &placeHolderColorKey);
}

- (void)setLimitTextLength:(NSInteger)limitTextLength
{
    NSNumber *limitTextLengthNumber = [NSNumber numberWithInteger:limitTextLength];
    objc_setAssociatedObject(self, &limitTextLengthKey, limitTextLengthNumber, OBJC_ASSOCIATION_COPY);
    self.tempInteger = limitTextLength;

    [self removeTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textFieldDidChanged) forControlEvents:UIControlEventEditingChanged];
}

- (NSInteger)limitTextLength
{
    NSNumber *limitTextLengthNumber = objc_getAssociatedObject(self, &limitTextLengthKey);
    return [limitTextLengthNumber integerValue];
}

- (void)setTempInteger:(NSInteger)tempInteger
{
    NSNumber *tempIntegerNumber = [NSNumber numberWithInteger:tempInteger];
    objc_setAssociatedObject(self, &tempIntegerKey, tempIntegerNumber, OBJC_ASSOCIATION_COPY);
}

- (NSInteger)tempInteger
{
    NSNumber *tempIntegerNumber = objc_getAssociatedObject(self, &tempIntegerKey);
    return [tempIntegerNumber integerValue];
}

- (void)textFieldDidChanged
{
    if (self.text.length > self.tempInteger)
    {
        if (self.markedTextRange == nil)
        {
            self.text = [self.text substringToIndex:self.tempInteger];
        }
        //        else
        //        {
        //            NSRange markedTextRange = [self selectedRange:self];
        //            NSString *markedText = [self.text substringWithRange:NSMakeRange(markedTextRange.location,10 - markedTextRange.location)];
        //            [self setMarkedText:markedText selectedRange:NSMakeRange(markedText.length, markedText.length)];
        //        }
    }
}

@end
