//
//  ConnectionService.h
//  My-Test-AFNetworking
//
//  Created by 韩伟 on 15/5/21.
//  Copyright (c) 2015年 韩伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Reachability.h"

@class RootViewController;

@interface YGConnectionService : NSObject

@property (nonatomic, assign) NetworkStatus netWorkStatus;
@property (nonatomic, strong) AFHTTPSessionManager *requestManager;

+ (instancetype)sharedConnectionService;

/**
 展示loadingview

 @param superView 要添加到的view，为window则会遮挡用户操作
 */
- (void)showLoadingViewWithSuperView:(UIView *)superView;

/**
 移除loadingview
 */
- (void)dissmissLoadingView;

/**
 根据参数和url加载上一次的缓存（列表类必须加载缓存，防止刚进来或者无网络一片空白）

 @param URLString 缓存的url，跟请求的相同
 @param parameters 缓存的参数，跟请求的相同
 @return 返回id类型的缓存（大多是NSDictionary）
 */
- (id)loadCacheWithURLString:(NSString *)URLString parameter:(NSDictionary *)parameters;

/**
 网络请求方法，自带网络判断，缓存处理（自带报错的toast，不用写）

 @param URLString 请求的url（不用写前缀）
 @param parameters 请求的参数
 @param flag 是否需要展示loadingview
 @param scrollView 如果是带刷新加载（total,count）的请求，传入tableview或collectionview之后不用写结束刷新
 @param success 成功block（注：根据后台的response格式，返回的responseObject直接取到了responseObject[@"data"]）
 @param failure 失败block（注：如果服务器返回的state为error和无网络也走此block，也就是说失败block包含了所有未正确返回数据的情况）
 */
- (void) YGPOST:(NSString *)URLString
     parameters:(id)parameters
showLoadingView:(BOOL)flag
     scrollView:(UIScrollView *)scrollView
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure;

/**
 网络请求方法（表单提交），自带网络判断（自带报错的toast，不用写）
 
 @param URLString 请求的url（不用写前缀）
 @param parameters 请求的参数
 @param flag 是否需要展示loadingview
 @param scrollView 如果是带刷新加载（total,count）的请求，传入tableview或collectionview之后不用写结束刷新
 @param block 提交表单block
 @param success 成功block（注：根据后台的response格式，返回的responseObject直接取到了responseObject[@"data"]）
 @param failure 失败block（注：如果服务器返回的state为error和无网络也走此block，也就是说失败block包含了所有未正确返回数据的情况）
 */
- (void)           YGPOST:(NSString *)URLString
               parameters:(id)parameters
          showLoadingView:(BOOL)flag
               scrollView:(UIScrollView *)scrollView
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

@end
