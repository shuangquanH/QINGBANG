//
//  DeiledRepairOrderTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"
@class WaitToDealModel;
@protocol DeiledRepairOrderTableViewCellDelegate <NSObject>//协议
- (void)DeiledRepairOrderTableViewCellDelegateDeleteBtnClick:(UIButton *)btn withrow:(int)row;//协议方法
- (void)DeiledRepairOrderTableViewCellDelegateJudgeBtnClick:(UIButton *)btn withrow:(int)row;//协议方法

@end

@interface DeiledRepairOrderTableViewCell : SQBaseTableViewCell
@property (nonatomic,strong) WaitToDealModel * model;
@property (nonatomic, assign) id<DeiledRepairOrderTableViewCellDelegate>delegate;//代理属性
@property (nonatomic, assign) int row;
@end



