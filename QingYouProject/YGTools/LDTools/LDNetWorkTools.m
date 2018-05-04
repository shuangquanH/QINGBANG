//
//  LDNetWorkTools.m
//  OC_Project2017
//
//  Created by LDSmallCat on 17/2/25.
//  Copyright © 2017年 曹来东. All rights reserved.
//
static AFNetworkReachabilityStatus  networkReachabilityStatus;

#import "LDNetWorkTools.h"
//网络请求超时时间
#define NetworkTimeoutInterval  10.0

#define ErrorCode_emptyUrl      1000    //请求地址为空
#define ErrorCode_netError      1001    //网络请求错误

@protocol LDRequestProtocol <NSObject>

@optional

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
@interface LDNetWorkTools ()<LDRequestProtocol>

@end

@implementation LDNetWorkTools

+ (instancetype)sharedTools{
    
    static LDNetWorkTools *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [LDNetWorkTools manager];
        //请求参数序列话
        instance.requestSerializer = [AFJSONRequestSerializer serializer];
       
        //设置请求的数据格式=HTTPS请求设置
        //AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //整数权限.允许过期整数
        //securityPolicy.allowInvalidCertificates = YES;
        //instance.securityPolicy = securityPolicy;
        
        //设置解析类型
        instance.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
    });
    
    [instance.requestSerializer setValue:@"false"forHTTPHeaderField:@"humpJsonStyle"];
    
    
    return instance;
}
#pragma mark - get post普通网络工具类
- (void)ld_Request:(LDRequestType)method url:(NSString *)url params:(id)params callback:(void (^)(id result, NSError * error))callback{
    
    NSMutableDictionary *parametersDic =  [NSMutableDictionary dictionaryWithDictionary:params];
    NSString * token = LDReadForLocation(LDUserToken);
    if ( [token length]!= 0)
    {
        [parametersDic setObject:token forKey:@"token"];
    }
    NSString * userID = LDReadForLocation(LDUserId);

    if ([userID length] != 0)
    {
        [parametersDic setObject:userID forKey:@"userId"];
    }
    //根据传入的请求类型,计算出请求方式的字符串
    NSString * mtd = (method == GET) ? @"GET":@"POST";
    LDLog(@"parametersDic = %@",parametersDic);
    [[self dataTaskWithHTTPMethod:mtd URLString:url parameters:parametersDic uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *dataTask, id response) {
        
        
        callback(response,nil);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
        callback(nil, error);
        
    }] resume];
}
#pragma mark - < 判断网络状态 >
- (void)judgeNetStatus{

    switch (networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            LDLog(@"网络状态 : 未知")
            break;
        case AFNetworkReachabilityStatusNotReachable:
        {
            LDLog(@"网络状态 : 无网络")
            return;
            
        }
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            LDLog(@"网络状态 : 3/4G")
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            LDLog(@"网络状态 : WiFi")
            
            break;
        default:
            break;
    }

}
#pragma mark - 耦合视图请求
- (void)ld_couplingRequest:(LDRequestType)method url:(NSString *)url params:(id)params callback:(void (^)(id result, NSError * error))callback sendView:(UIView *)sendView animSuperView:(UIView *)animSuperView animated:(BOOL)animated{
    
    NSMutableDictionary *parametersDic =  [NSMutableDictionary dictionaryWithDictionary:params];
    NSString * token = LDReadForLocation(LDUserToken);
    if ( [token length]!= 0)
    {
        [parametersDic setObject:token forKey:@"token"];
    }
    NSString * userID = LDReadForLocation(LDUserId);
    
    if ([userID length] != 0)
    {
        [parametersDic setObject:userID forKey:@"userId"];
    }
    //根据传入的请求类型,计算出请求方式的字符串
    NSString * mtd = (method == GET) ? @"GET":@"POST";
    LDLog(@"parametersDic = %@",parametersDic);
    [[self dataTaskWithHTTPMethod:mtd URLString:url parameters:parametersDic uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *dataTask, id response) {
        
        
        callback(response,nil);
        
    } failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
        
        callback(nil, error);
        
    }] resume];
}
#pragma mark - < 启动网络监听 >
+ (void)startWorkReachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    networkReachabilityStatus = AFNetworkReachabilityStatusUnknown;
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        networkReachabilityStatus = status;
    }];
    // 3.开始监控
    [mgr startMonitoring];
}

@end
