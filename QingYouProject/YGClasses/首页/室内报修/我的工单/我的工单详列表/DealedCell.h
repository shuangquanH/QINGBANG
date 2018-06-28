//
//  DealedCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"
@class WaitToDealModel;
@protocol DealedCellDelegate <NSObject>//协议
- (void)DealedCellDelegateDeleteBtnClick:(UIButton *)btn withrow:(int)row;//协议方法
@end

@interface DealedCell : SQBaseTableViewCell
@property (nonatomic,strong) WaitToDealModel * model;
@property (nonatomic, assign) id<DealedCellDelegate>delegate;//代理属性
@property (nonatomic, assign) int row;
@property (nonatomic, strong) NSString * tagStr;

@end
