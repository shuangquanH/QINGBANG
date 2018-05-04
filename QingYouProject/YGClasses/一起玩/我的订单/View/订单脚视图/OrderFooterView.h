//
//  OrderFooterView.h
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@class OrderFooterView;
@protocol OrderFooterViewDelegate <NSObject>

@optional
//付款
- (void)payOrderButtonClickedWithOrderFooterView:(OrderFooterView *)orderFooterView;

//取消订单
- (void)cancelOrderButtonClickedWithOrderFooterView:(OrderFooterView *)orderFooterView;

//取消活动
- (void)cancelActiveButtonClickedWithOrderFooterView:(OrderFooterView *)orderFooterView;

//删除订单
- (void)delOrderButtonClickedWithOrderFooterView:(OrderFooterView *)orderFooterView;

@end

@interface OrderFooterView : UIView

@property (nonatomic, strong) OrderModel * model;

@property (nonatomic, weak) id<OrderFooterViewDelegate>delegate;

@end
