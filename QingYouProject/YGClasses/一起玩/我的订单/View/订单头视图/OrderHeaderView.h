//
//  OrderHeaderView.h
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderHeaderView : UIView

@property (nonatomic, strong)OrderModel * model;
@property (nonatomic, copy)NSString *detailType;

@end
