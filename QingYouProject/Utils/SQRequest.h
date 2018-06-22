//
//  SQRequest.h
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//  网络请求工具类

#import <Foundation/Foundation.h>

#define KAPI_ADDRESS @"http://192.168.2.28:8081/mockjsdata/1/"
#define KAPI_ADDRESS_TEST_MH @"http://192.168.2.27:8089/"//马昊本地
#define KAPI_ADDRESS_TEST_HJK @"http://192.168.2.32:8081/"//皇建坤本地

@interface SQRequest : NSObject

+ (void)setApiAddress:(NSString *)apiAddress;

/** 普通网络请求  */
+ (void)post:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;


/** 带loading动画的网络请求  */
+ (void)post:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure showLoadingView:(BOOL)show;


+ (void)postCustomApi:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure showLoadingView:(BOOL)show;

@end
