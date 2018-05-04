//
//  MyOrderCheckHouseTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCheckHouseModel.h"

@protocol MyOrderCheckHouseTableViewCellDelegate <NSObject>

- (void)cancleBackOutBtnWithModel:(OrderCheckHouseModel *)model;

@end
@interface MyOrderCheckHouseTableViewCell : UITableViewCell
@property (nonatomic, assign) id<MyOrderCheckHouseTableViewCellDelegate>delegate;

@property (nonatomic, strong) OrderCheckHouseModel        *model;
- (void)setModel:(OrderCheckHouseModel *)model withHiddenCancleButton:(BOOL)cancle;
@end
