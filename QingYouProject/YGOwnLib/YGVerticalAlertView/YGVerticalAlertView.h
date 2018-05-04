//
//  YGVerticalAlertView.h
//  FindingSomething
//
//  Created by zhangkaifeng on 16/7/6.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGVerticalAlertView : UIView

@property (nonatomic,strong) NSArray * titlesArray;

@property (nonatomic,strong) NSArray * colorsArray;

@property (nonatomic,strong) NSString * titleString;

/**
 *  初始化方法
 *
 *  @param titleString       alert的标题
 *  @param buttonTitlesArray 按钮上的标题
 *  @param buttonColorsArray 按钮的颜色
 *  @param handler           点击按钮的block
 */
+ (void)showAlertWithTitle:(NSString *)titleString buttonTitlesArray:(NSArray *)buttonTitlesArray buttonColorsArray:(NSArray *)buttonColorsArray handler:(void (^)(NSInteger buttonIndex))handler;

@end
