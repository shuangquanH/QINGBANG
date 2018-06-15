//
//  ShippedCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseViewCell.h"
@class AllOfficePurchaseModel;

@protocol ShippedCellDelegate <NSObject>//协议
- (void)shippedCellReturnWithRow:(int)row;//协议方法
- (void)shippedCellSureWithRow:(int)row;//协议方法

@end
@interface ShippedCell : LDBaseViewCell
/** AllOfficePurchaseModel  */
@property (nonatomic,strong) AllOfficePurchaseModel * model;
@property (nonatomic, assign) id <ShippedCellDelegate>delegate;
@property (nonatomic, assign) int row;
@end
