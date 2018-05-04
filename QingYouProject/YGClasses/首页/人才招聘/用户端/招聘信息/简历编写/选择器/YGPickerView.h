//
//  YGPickerView.h
//
//  Created by 张楷枫 on 16/3/4.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YGPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *pickerViewDataSource;
@property (nonatomic, strong) NSString *titleString;

/**
 * 展示方法
 * @param pickerViewDataSource 数据源
 * @param titleString 标题
 * @param handler 确定block
 * @return 本view
 */
+ (instancetype)showWithPickerViewDataSource:(NSArray *)pickerViewDataSource titleString:(NSString *)titleString handler:(void (^)(NSInteger selectedRow, NSString *selectedString))handler;

/**
 * 选中某row
 * @param titleString 选中的字符串
 */
- (void)selectWithTitleString:(NSString *)titleString;

/**
 * 选中某row
 * @param row 选中的row
 */
- (void)selectWithRow:(NSInteger)row;

@end
