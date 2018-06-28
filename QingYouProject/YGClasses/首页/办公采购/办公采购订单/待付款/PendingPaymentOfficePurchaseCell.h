//
//  PendingPaymentOfficePurchaseCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SQBaseTableViewCell.h"

@protocol PendingPaymentOfficePurchaseCellDelegate <NSObject>//协议
- (void)pendingPaymentOfficePurchaseCellCancelBtnClick:(UIButton *)btn WithRow:(int)row;//协议方法

@end

@class AllOfficePurchaseModel;
@interface PendingPaymentOfficePurchaseCell : SQBaseTableViewCell
- (void)reloadData;
/** AllOfficePurchaseModel  */
@property (nonatomic,strong) AllOfficePurchaseModel * model;
@property (nonatomic, assign) id <PendingPaymentOfficePurchaseCellDelegate>delegate;
@property (nonatomic, assign) int row;
@end
