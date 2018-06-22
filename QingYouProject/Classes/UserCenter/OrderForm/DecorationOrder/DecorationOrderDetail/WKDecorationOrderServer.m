//
//  WKDecorationOrderServer.m
//  QingYouProject
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationOrderServer.h"
#import "WKDecorationOrderDetailModel.h"

@implementation WKDecorationOrderServer

+ (void)sendCancelOrderWithOrderNumber:(NSString *)orderNumber completed:(void (^)(BOOL, NSString *))completed {
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [SQRequest post:KAPI_CANCELORDER param:@{@"orderNum": orderNumber} success:^(id response) {
        [YGNetService dissmissLoadingView];
        if ([response[@"code"] longLongValue] == 0) {
            completed(YES, nil);
        }
        else {
            completed(NO, response[@"msg"]);
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        completed(NO, @"网络错误");
    }];
}

+ (void)sendDeleteOrderWithOrderNumber:(NSString *)orderNumber completed:(void (^)(BOOL, NSString *))completed {
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [SQRequest post:KAPI_DELETEORDER param:@{@"orderNum": orderNumber} success:^(id response) {
        [YGNetService dissmissLoadingView];
        if ([response[@"code"] longLongValue] == 0) {
            completed(YES, nil);
        }
        else {
            completed(NO, response[@"msg"]);
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        completed(NO, @"网络错误");
    }];
}

+ (void)sendPayWithParam:(NSDictionary *)param completed:(void (^)(id, NSString *))completed {
    [YGNetService showLoadingViewWithSuperView:YGAppDelegate.window];
    [SQRequest post:KAPI_PAY param:param success:^(id response) {
        [YGNetService dissmissLoadingView];
        if ([response[@"code"] longLongValue] == 0) {
            completed(response[@"data"], nil);
        }
        else {
            completed(nil, response[@"msg"]);
        }
    } failure:^(NSError *error) {
        [YGNetService dissmissLoadingView];
        completed(nil, @"网络错误");
    }];
}

+ (void)sendOrderDetailWithOrderNumber:(NSString *)orderNumber completed:(void (^)(WKDecorationOrderDetailModel *, NSString *))completed {
    [SQRequest post:KAPI_DECORATIONORDERDETAIL param:@{@"orderNum": orderNumber} success:^(id response) {
        if ([response[@"code"] longLongValue] == 0) {
            WKDecorationOrderDetailModel *order = [WKDecorationOrderDetailModel yy_modelWithJSON:response[@"data"]];
            completed(order, nil);
        } else {
            completed(nil, response[@"msg"]);
        }
    } failure:^(NSError *error) {
        completed(nil, @"网络错误");
    }];
}

@end
