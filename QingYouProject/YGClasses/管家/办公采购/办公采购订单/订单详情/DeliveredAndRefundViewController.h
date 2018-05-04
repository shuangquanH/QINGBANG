//
//  DeliveredAndRefundViewController.h
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@protocol DeliveredAndRefundViewControllerDelegate <NSObject>//协议
- (void)deliveredAndRefundViewControllerDeleteWithRow:(int)row;//协议方法
@end

@interface DeliveredAndRefundViewController : RootViewController
/** 订单状态: 退款 : 4,5,6 ? 待发货 : 1*/
@property (nonatomic,assign) NSInteger status;
@property (nonatomic, strong) NSString *OrderID;
@property (nonatomic, assign) id <DeliveredAndRefundViewControllerDelegate>delegate;
@property (nonatomic, assign) int row;
@end
