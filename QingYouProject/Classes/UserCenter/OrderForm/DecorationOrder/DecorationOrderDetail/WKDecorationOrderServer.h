//
//  WKDecorationOrderServer.h
//  QingYouProject
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKDecorationOrderDetailModel;

@interface WKDecorationOrderServer : NSObject
//删除订单
+ (void)sendDeleteOrderWithOrderNumber:(NSString *)orderNumber completed:(void(^)(BOOL success, NSString *errMsg))completed;
//取消订单
+ (void)sendCancelOrderWithOrderNumber:(NSString *)orderNumber completed:(void(^)(BOOL success, NSString *errMsg))completed;
//支付
+ (void)sendPayWithParam:(NSDictionary *)param completed:(void(^)(id response, NSString *errMsg))completed;
//订单详情
+ (void)sendOrderDetailWithOrderNumber:(NSString *)orderNumber completed:(void(^)(WKDecorationOrderDetailModel *detailInfo, NSString *errMsg))completed;
//申请退款
+ (void)sendRefundWithOrderNumber:(NSString *)orderNumber
                        paymentId:(NSString *)paymentId
                           amount:(NSString *)amount
                          comment:(NSString *)comment
                        completed:(void(^)(BOOL success, NSString *errMsg))completed;

@end
