//
// Created by zhangkaifeng on 2017/10/25.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YGDatePickerView : UIView

/**
 * 展示方法
 * @param startDate 起始日期
 * @param endDate 结束日期
 * @param titleString 标题文字
 * @param datePickerMode 模式
 * @param handler 确定block
 * @return
 */
+ (instancetype)showWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate titleString:(NSString *)titleString datePickerMode:(UIDatePickerMode)datePickerMode handler:(void (^)(NSDate * selectedDate))handler;

/**
 * 选中某日期
 * @param selectDate 日期
 */
- (void)selectWithDate:(NSDate *)selectDate;


@end