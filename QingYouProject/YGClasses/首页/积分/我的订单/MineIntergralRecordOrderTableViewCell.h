//
//  MineIntergralRecordOrderTableViewCell.h
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineIntergralRecordOrderModel.h"

@interface MineIntergralRecordOrderTableViewCell : UITableViewCell
@property (nonatomic, strong) MineIntergralRecordOrderModel            *model;
/** 商品图片  */
@property (nonatomic,strong) UIImageView * goodsImageView;
/** 商品名  */
@property (nonatomic,strong) UILabel * goodsNamelabel;
/** 商品单价  */
@property (nonatomic,strong) UILabel * goodsPrice;
@end
