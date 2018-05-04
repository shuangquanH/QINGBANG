//
//  LDNetWorkTools.h
//  OC_Project2017
//
//  Created by LDSmallCat on 17/2/25.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, LDRequestType) {
    GET,
    POST,
};

@interface LDNetWorkTools : AFHTTPSessionManager

#pragma mark - 网络请求的全局访问点
+ (instancetype)sharedTools;

#pragma mark - get post普通网络工具类
- (void)ld_Request:(LDRequestType)method url:(NSString *)url params:(id)params callback:(void (^)(id result, NSError * error))callback;
#pragma mark - 启动网络监听（一般在程序启动的时候调用）
+ (void)startWorkReachability;


@end
