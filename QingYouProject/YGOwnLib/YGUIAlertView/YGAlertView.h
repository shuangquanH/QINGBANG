//
//  CustomAlertView.h
//  FindingSomething
//
//  Created by ccyogee on 15/12/11.
//  Copyright © 2015年 张楷枫. All rights reserved.
//

#import <UIKit/UIKit.h>


//按钮为 左右排版 的弹出框
@interface YGAlertView : UIView

@property (nonatomic, strong) NSArray *buttonTitlesArray; //按钮数组
@property (nonatomic, strong) NSArray *buttonColorsArray; //按钮文字颜色
@property (nonatomic, strong) NSString *titleString; //信息文本

/**
 *  一句话初始化
 *
 *  @param titleString       显示的文字
 *  @param buttonTitlesArray 按钮文字数组
 *  @param buttonColorsArray 按钮颜色数组
 *  @param handler           点击事件回调block
 */
+ (void)showAlertWithTitle:(NSString *)titleString buttonTitlesArray:(NSArray *)buttonTitlesArray buttonColorsArray:(NSArray *)buttonColorsArray handler:(void (^)(NSInteger buttonIndex))handler;

@end
