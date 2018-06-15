//
//  SQRequest.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  网络请求工具类

#import <Foundation/Foundation.h>

#define KAPI_ADDRESS @"http://192.168.2.28:8081/mockjsdata/1/"

@interface SQRequest : NSObject

/** 普通网络请求  */
+ (void)post:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;


/** 带loading动画的网络请求  */
+ (void)post:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure showLoadingView:(BOOL)show;

/** 带自定义接口的loading动画的网络请求  */
+ (void)postCustomApi:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure showLoadingView:(BOOL)show;


@end
