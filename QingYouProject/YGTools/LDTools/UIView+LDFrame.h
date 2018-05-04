//
//  UIView+LDFrame.h
//  OC_Project2017
//
//  Created by LDSmallCat on 17/2/8.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LDFrame)
@property (nonatomic,assign) CGFloat ld_x;
@property (nonatomic,assign) CGFloat ld_y;
@property (nonatomic,assign) CGFloat ld_width;
@property (nonatomic,assign) CGFloat ld_height;
@property (nonatomic, assign) CGFloat ld_centerX;
@property (nonatomic, assign) CGFloat ld_centerY;
@property (nonatomic, assign) CGFloat ld_right;
@property (nonatomic, assign) CGFloat ld_bottom;
@property (nonatomic,assign) CGSize ld_size;
+ (instancetype)ld_viewFromXib;

@end
