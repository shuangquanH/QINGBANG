//
//  SQRequest.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/24.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQRequest.h"
#import "YGConnectionService.h"
#import "AFNetworking.h"

@implementation SQRequest

+ (void)setApiAddress:(NSString *)apiAddress {
    [YGSingleton sharedManager].apiAddress = apiAddress;
}


+ (void)post:(NSString  *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure {
    NSString    *apiAddress = (YGSingletonMarco.apiAddress)?YGSingletonMarco.apiAddress:KAPI_ADDRESS;
    NSString    *apiString = [NSString stringWithFormat:@"%@%@", apiAddress, api];
    NSMutableDictionary *muParam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    if ([YGSingleton sharedManager].user.userId) {
        [muParam setValue:[YGSingleton sharedManager].user.userId forKey:@"userId"];
    }
    if ([[YGSingleton sharedManager].user.isInGarden isEqualToString:@"yes"]) {
        [muParam setValue:@"1" forKey:@"isInner"];
    } else {
        [muParam setValue:@"0" forKey:@"isInner"];
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

+ (void)get:(NSString   *)api param:(NSDictionary   *)param success:(void(^)(id response))success failure:(void(^)(NSError *error))failure showLoadingView:(BOOL)show {
    
    if (show) {
        [[YGConnectionService sharedConnectionService] showLoadingViewWithSuperView:YGAppDelegate.window];
    }
    
    [[YGConnectionService sharedConnectionService].requestManager GET:api parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        if (show) {
            [[YGConnectionService sharedConnectionService] dissmissLoadingView];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        if (show) {
            [[YGConnectionService sharedConnectionService] dissmissLoadingView];
        }
        
    }];
}


+ (void)uploadImages:(NSArray *)images param:(NSDictionary *)param progress:(void(^)(float progress))progress success:(void(^)(id response))success failure:(void(^)(NSError *error))failure {
    if (!images.count) {
        if (failure) {
            failure([NSError errorWithDomain:@"上传图片为空" code:-1 userInfo:nil]);
        }
        return;
    }
    
    NSString *apiAddress = (YGSingletonMarco.apiAddress)?YGSingletonMarco.apiAddress:KAPI_ADDRESS;
    NSString *apiString = [NSString stringWithFormat:@"%@%@", apiAddress, KAPI_FILEUPLOAD];
    
    NSMutableArray      *urls = [NSMutableArray array];//请求成功的url数组
    NSMutableDictionary *taskDict = [NSMutableDictionary dictionary];//任务字典
    NSMutableDictionary *progressDict = [NSMutableDictionary dictionary];//上传进度地址
    __block NSError *uploadError = nil;//请求错误
    
    for (int i = 0; i < images.count; i++) {
        
        if (uploadError) {
            break;
        }
        
        UIImage *image = [images objectAtIndex:i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
        if (!imageData) {//创建图片数据失败，退出请求
            uploadError = [NSError errorWithDomain:@"创建图片数据错误" code:-1 userInfo:nil];
            //取消所有下载
            for (NSURLSessionDataTask *t in taskDict.allValues) {
                [t cancel];
            }
            [taskDict removeAllObjects];
            if (failure) {
                failure(uploadError);
            }
            break;
        }

        
        __block NSURLSessionDataTask *dataTask = [[YGConnectionService sharedConnectionService].requestManager POST:apiString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData
                                        name:@"file"
                                    fileName:@"file.jpeg"
                                    mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress && dataTask) {
                float percent = (float)uploadProgress.completedUnitCount / (float)uploadProgress.totalUnitCount;
                progressDict[@(dataTask.taskIdentifier)] = @(percent);
                float completePercent = 0;
                for (NSNumber *p in progressDict.allValues) {
                    completePercent += [p floatValue];
                }
                float currentProgress = completePercent / (float)images.count;
                NSLog(@"%@", progressDict);
                progress(currentProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [taskDict removeObjectForKey:@(task.taskIdentifier)];
            NSString *url = responseObject[@"data"][@"imgUrl"];
            [urls addObject:url];
            if (urls.count == images.count && success) {
                success(urls);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            uploadError = error;
            //取消所有上传
            for (NSURLSessionDataTask *t in taskDict.allValues) {
                if (t.taskIdentifier == task.taskIdentifier) continue;
                [t cancel];
            }
            [taskDict removeAllObjects];
            if (failure) {
                failure(uploadError);
            }
        }];
        [taskDict setObject:dataTask forKey:@(dataTask.taskIdentifier)];
    }
}


//    [[YGConnectionService sharedConnectionService].requestManager GET:apiString parameters:requestParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];



@end
