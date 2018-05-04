//
//  ShipAndSuccessViewController.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface ShipAndSuccessViewController : RootViewController

/** 订单状态: 已发货 : 2 ? 交易成功 : 3*/
@property (nonatomic,assign) NSInteger status;
@property (nonatomic, strong) NSString *OrderID;
@property (nonatomic,assign) int row;

@end
