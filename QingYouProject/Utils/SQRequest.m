//
//  SQRequest.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQRequest.h"
#import "YGConnectionService.h"

@implementation SQRequest

+ (void)post:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure {
    
    NSString    *apiString = [NSString stringWithFormat:@"%@%@", KAPI_ADDRESS, api];
    NSMutableDictionary *muParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    if ([YGSingleton sharedManager].user.userId) {
        [muParam setValue:[YGSingleton sharedManager].user.userId forKey:@"userid"];
    }
    
    [[YGConnectionService sharedConnectionService].requestManager POST:apiString
                                                            parameters:muParam
                                                              progress:nil
                                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        success(responseObject);
    }
                                                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (failure) {
            failure(error);
        }
    }];
}



//    [[YGConnectionService sharedConnectionService].requestManager GET:apiString parameters:requestParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];



@end
