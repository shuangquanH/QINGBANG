//
//  UIBarButtonItem+LDItem.h
//  OC_Project2017
//
//  Created by LDSmallCat on 17/2/8.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LDItem)
// 快速创建UIBarButtonItem
+ (UIBarButtonItem *)itemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithimage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title normalColor:(UIColor *)normalColor highColor:(UIColor *)highColor titleFont:(UIFont *)titleFont;

@end
