//
//  WaitToDealCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"
@class WaitToDealModel;

@protocol WaitToDealCellDelegate <NSObject>//协议
- (void)WaitToDealCellDelegateDealIngBtnClick:(UIButton *)btn withrow:(int)row;//处理中协议方法
- (void)WaitToDealCellDelegateAlreadyDealBtnClick:(UIButton *)btn withrow:(int)row;//已处理协议方法
@end

@interface WaitToDealCell : SQBaseTableViewCell
@property (nonatomic, assign) id<WaitToDealCellDelegate>delegate;//代理属性
@property (nonatomic,strong) WaitToDealModel * model;
@property (nonatomic, assign) int row;

@end

