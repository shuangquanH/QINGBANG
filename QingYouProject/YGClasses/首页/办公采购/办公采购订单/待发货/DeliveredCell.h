//
//  DeliveredCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseViewCell.h"
@class AllOfficePurchaseModel;

@protocol DeliveredCellDelegate <NSObject>//协议
- (void)deliveredCellReturnWithRow:(int)row;//协议方法
@end

@interface DeliveredCell : LDBaseViewCell
- (void)reloadData;
/** AllOfficePurchaseModel  */
@property (nonatomic,strong) AllOfficePurchaseModel * model;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) id <DeliveredCellDelegate>delegate;
@end
