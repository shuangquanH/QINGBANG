//
//  OrderDetailToolBarView.h
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderManagerController.h"

@class OrderDetailToolBarView;
@protocol OrderDetailToolBarViewDelegate <NSObject>

@optional
//付款
- (void)payOrderButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView;

//取消订单
- (void)cancelOrderButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView;

//联系主办方
- (void)callSponsorButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView;

//取消活动
- (void)cancelActiveButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView;

//删除订单
- (void)delOrderButtonClickedWithOrderDetailToolBarView:(OrderDetailToolBarView *)toolBarView;

@end

@interface OrderDetailToolBarView : UIView

@property (nonatomic, assign) OrderType  orderType;

- (instancetype)initWithOrderType:(OrderType)orderType;


@property (nonatomic, weak) id<OrderDetailToolBarViewDelegate>delegate;

@end
