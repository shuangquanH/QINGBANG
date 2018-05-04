//
// Created by zhangkaifeng on 2017/10/19.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YGActionSheetView : UIView <UITableViewDelegate,UITableViewDataSource>

+ (void)showAlertWithTitlesArray:(NSArray *)titlesArray handler:(void (^)(NSInteger selectedIndex, NSString *selectedString))handler;
- (instancetype)initWithTitlesArray:(NSArray *)titlesArray handler:(void (^)(NSInteger selectedIndex, NSString *selectedString))handler;

@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, assign) int selectedIndex;
- (void)dismiss;

@end
