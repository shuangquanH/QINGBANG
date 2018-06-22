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

+ (void)setApiAddress:(NSString *)apiAddress {
    [YGSingleton sharedManager].apiAddress = apiAddress;
}


+ (void)post:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure {
    NSString    *apiAddress = (YGSingletonMarco.apiAddress)?YGSingletonMarco.apiAddress:KAPI_ADDRESS;
    NSString    *apiString = [NSString stringWithFormat:@"%@%@", apiAddress, api];
    NSMutableDictionary *muParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    if ([YGSingleton sharedManager].user.userId) {
        [muParam setValue:[YGSingleton sharedManager].user.userId forKey:@"userid"];
        
        //调试用户Id
        [muParam setValue:@"0c2715a0701c41b2a38469f055d748bd" forKey:@"userId"];
    }
    if ([[YGSingleton sharedManager].user.isInGarden isEqualToString:@"yes"]) {
        [muParam setValue:@"yes" forKey:@"isInner"];
    } else {
        [muParam setValue:@"no" forKey:@"isInner"];
    }
    
    [[YGConnectionService sharedConnectionService].requestManager POST:apiString
                                                            parameters:muParam
                                                              progress:nil
                                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        if (success) {
            success(responseObject);
        }
    }
                                                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)post:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure showLoadingView:(BOOL)show {
    if (show) {
        [[YGConnectionService sharedConnectionService] showLoadingViewWithSuperView:YGAppDelegate.window];
    }
    [self post:api param:param success:^(id response) {
        if (success) {
            success(response);
        }
        if (show) {
            [[YGConnectionService sharedConnectionService] dissmissLoadingView];
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        if (show) {
            [[YGConnectionService sharedConnectionService] dissmissLoadingView];
        }
    }];
}












+ (void)postCustomApi:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure showLoadingView:(BOOL)show {
    if (show) {
        [[YGConnectionService sharedConnectionService] showLoadingViewWithSuperView:YGAppDelegate.window];
    }
    NSMutableDictionary *muParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    if ([YGSingleton sharedManager].user.userId) {
        [muParam setValue:[YGSingleton sharedManager].user.userId forKey:@"userid"];
    }
    if ([[YGSingleton sharedManager].user.isInGarden isEqualToString:@"yes"]) {
        [muParam setValue:@"yes" forKey:@"isInner"];
    } else {
        [muParam setValue:@"no" forKey:@"isInner"];
    }
    
    [[YGConnectionService sharedConnectionService].requestManager POST:api
                                                            parameters:muParam
                                                              progress:nil
                                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success) {
             success(responseObject);
         }
         if (show) {
             [[YGConnectionService sharedConnectionService] dissmissLoadingView];
         }
     }
                                                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (failure) {
             failure(error);
         }
         if (show) {
             [[YGConnectionService sharedConnectionService] dissmissLoadingView];
         }
     }];
    
    
}


//    [[YGConnectionService sharedConnectionService].requestManager GET:apiString parameters:requestParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];



@end
