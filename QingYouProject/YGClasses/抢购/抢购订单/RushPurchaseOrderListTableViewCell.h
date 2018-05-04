//
//  RushPurchaseOrderListTableViewCell.h
//  QingYouProject
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RushPurchaseOrderListModel.h"

@protocol RushPurchaseOrderListTableViewCellDelegate <NSObject>//协议
- (void)rushPurchaseOrderListTableViewCellReturnMoneyWithButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法
- (void)rushPurchaseOrderListTableViewCellReceiveGoodWithButton:(UIButton *)btn withRow:(NSInteger)row;//协议方法

@end

@interface RushPurchaseOrderListTableViewCell : UITableViewCell
- (void)setModelValeFalseWithType:(NSInteger )type;
@property (nonatomic, assign) id <RushPurchaseOrderListTableViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) RushPurchaseOrderListModel        *model;
@end
