//
//  OrderManagerController.h
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

typedef enum : NSUInteger {
    PAYMENTPENDINGORDER = 0,            //待付款订单
    PARTICIPATEINORDER = 1,             //待参与订单
    OVERORDER = 2,                      //已完成订单
    REFUNDSINGORDER = 3,                //退款订单(退款中)
    REFUNDSEDORDER = 4,                  //退款订单(退款成功)
    REFUNDSFAILUIREORDER = 5                  //退款订单(退款失败)

} OrderType;

@interface OrderManagerController : RootViewController

@property (nonatomic, assign) OrderType orderType;//进入控制器时显示的订单类型

@end
