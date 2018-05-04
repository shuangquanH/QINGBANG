//
//  TransactionSuccessCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseViewCell.h"
@class AllOfficePurchaseModel;

@protocol TransactionSuccessCellDelegate <NSObject>//协议
- (void)transactionSuccessCellDeleteWithRow:(int)row;//协议方法
@end

@interface TransactionSuccessCell : LDBaseViewCell
/** AllOfficePurchaseModel  */
@property (nonatomic,strong) AllOfficePurchaseModel * model;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) id <TransactionSuccessCellDelegate>delegate;
@end
