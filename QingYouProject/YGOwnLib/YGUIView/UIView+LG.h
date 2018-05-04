//
//  UIView+LG.h
//  微博
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 wyzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LG)
@property(assign,nonatomic)CGFloat x;
@property(assign,nonatomic)CGFloat y;
@property(assign,nonatomic)CGFloat centerx;
@property(assign,nonatomic)CGFloat centery;
@property(assign,nonatomic)CGFloat width;
@property(assign,nonatomic)CGFloat height;
@property(assign,nonatomic)CGSize size;
@property(assign,nonatomic)CGPoint origin;

/**
 *  距右多少
 *
 *  @param view   距离的view
 *  @param margin 距离
 */
-(float)rightMarginWithView:(UIView *)view width:(float)width margin:(float)margin;

/**
 *  距下多少
 *
 *  @param view   距离的view
 *  @param margin 距离
 */
-(float)bottomMarginWithView:(UIView *)view height:(float)height margin:(float)margin;

/**
 *  距底相同
 *
 *  @param view   距离的view
 *  @param height 高度
 */
-(float)equalBottomWithView:(UIView *)view height:(float)height;

@end
