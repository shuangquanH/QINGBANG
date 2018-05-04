//
//  OrderDetailCell.h
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderDetailCell : UITableViewCell
@property (nonatomic, strong) UIImageView * orderGoodsImageView;
@property (nonatomic, strong) UILabel * orderGoodsNameLabel;
@property (nonatomic, strong) UILabel * orderGoodsDatelabel;
@property (nonatomic, strong) UILabel * orderGoodsAddressLabel;
@property (nonatomic, strong) UILabel * orderGoodsTypeLabel;
@property (nonatomic, strong) UILabel * orderGoodsNumLabel;
@property (nonatomic, strong) UILabel * orderGoodsPriceLabel;
@property (nonatomic, strong) UILabel * orderAllNumLabel;
@property (nonatomic, strong) UILabel * orderAllPriceLAbel;

@property (nonatomic, strong) OrderModel * model;
@end
