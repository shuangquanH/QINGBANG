//
//  YGButton.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/4/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "YGButton.h"

@implementation YGButton

static const char *BackgroundColorNormalKey = "BackgroundColorNormalKey\0";
static const char *BackgroundColorSelectedKey = "BackgroundColorSelectedKey\0";
static const char *BorderColorNormalKey = "BorderColorNormalKey\0";
static const char *BorderColorSelectedKey = "BorderColorSelectedKey\0";


- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    if (state == UIControlStateNormal)
    {
        self.backgroundColor = color;
        objc_setAssociatedObject(self, &BackgroundColorNormalKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (state == UIControlStateSelected)
    {
        objc_setAssociatedObject(self, &BackgroundColorSelectedKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state
{
    if (state == UIControlStateNormal)
    {
        self.layer.borderColor = color.CGColor;
        objc_setAssociatedObject(self, &BorderColorNormalKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (state == UIControlStateSelected)
    {
        objc_setAssociatedObject(self, &BorderColorSelectedKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (self.isSelected)
    {
        if (objc_getAssociatedObject(self, &BackgroundColorSelectedKey))
        {
            self.backgroundColor = objc_getAssociatedObject(self, &BackgroundColorSelectedKey);
        }
        
        if (objc_getAssociatedObject(self, &BorderColorSelectedKey))
        {
            self.layer.borderColor = [objc_getAssociatedObject(self, &BorderColorSelectedKey) CGColor];
        }
    }
    else
    {
        if (objc_getAssociatedObject(self, &BackgroundColorNormalKey))
        {
            self.backgroundColor = objc_getAssociatedObject(self, &BackgroundColorNormalKey);
        }
        
        if (objc_getAssociatedObject(self, &BorderColorNormalKey))
        {
            self.layer.borderColor = [objc_getAssociatedObject(self, &BorderColorNormalKey) CGColor];
        }
    }
}

@end
