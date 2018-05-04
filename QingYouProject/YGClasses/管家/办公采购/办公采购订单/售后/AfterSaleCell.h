//
//  AfterSaleCell.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDBaseViewCell.h"
@class AllOfficePurchaseModel;

@protocol AfterSaleCellDelegate <NSObject>//协议
- (void)afterSaleCellDelegateDeleteWithRow:(int)row;//协议方法
@end

@interface AfterSaleCell : LDBaseViewCell

/** AllOfficePurchaseModel  */
@property (nonatomic,strong) AllOfficePurchaseModel * model;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) id <AfterSaleCellDelegate>delegate;
- (void)reloadData;

@end
