//
//  ConnectionService.m
//  My-Test-AFNetworking
//
//  Created by 韩伟 on 15/5/21.
//  Copyright (c) 2015年 韩伟. All rights reserved.
//

#import "YGConnectionService.h"
#import "AESCrypt.h"
#import "RootViewController.h"
#import "YYCache.h"

//#define Debug_Server  @"http://thesiren.f3322.net:9999/"

//#define Debug_Server  @"http://192.168.51.101:8080/" //longge
//#define Debug_Server  @"http://192.168.51.103:8080/" //xiangzeyu
//#define Debug_Server  @"http://192.168.51.28:8088/" //zhaoyifeng
//#define Debug_Server  @"http://192.168.51.220:8080/" //李源
//#define Debug_Server  @"http://thesiren.f3322.net:10086/" //李源
#define Debug_Server  @"http://www.ahqyc.xyz/" //线上
//#define Debug_Server  @"http://192.168.51.100:8080/" //李洪宝
//#define Debug_Server  @"http://thesiren.f3322.net:11111/"




//#define REQUEST_HouserPayDetails                       @"HouserPayDetails"               //房租待支付账单详情


static YGConnectionService *sConnectionService;

@implementation YGConnectionService
{
    UIImageView *_loadImageBackView;
    UIImageView *_loadImageTopView;
//    UIVisualEffectView *_hudView;
    UIView *_coverView;
    BOOL _showAnimate;
    YYCache *_myCache;
    UIView      *_hudView;
    UIImageView *_loadImageView;

}
#pragma mark 单例模式获取 ConnectionService 对象

+ (instancetype)sharedConnectionService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {

        sConnectionService = [[self alloc] init];

    });
    sConnectionService.netWorkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];

    return sConnectionService;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 1.首先实例化一个请求管理器
        self.requestManager = [AFHTTPSessionManager manager];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];

        // 2.设置请求的数据格式.（不是可以改）
        // *AFHTTPRequestSerializer(二进制)
        // *AFJSONRequestSerializer(JSON)
        // *AFPropertyListRequestSerializer(Plist)
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        self.requestManager.securityPolicy = securityPolicy;

        // 3.设置响应的数据格式：默认是JSON.（不是可以改）
        // *AFHTTPResponseSerializer(二进制)
        // *AFJSONResponseSerializer(JSON)
        // *AFPropertyListResponseSerializer(Plist)
        // *AFXMLParserResponseSerializer(XML)
        // *AFImageResponseSerializer(Image)
        // *AFCompoundResponseSerializer(组合的)
        self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestManager.requestSerializer.timeoutInterval = 20;
        _myCache = [YYCache cacheWithName:@"YGCache"];
        //加类型
        NSMutableSet *tempSet = [[NSMutableSet alloc] initWithSet:self.requestManager.responseSerializer.acceptableContentTypes];
        [tempSet addObject:@"text/plain"];
        [tempSet addObject:@"text/html"];
        self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithSet:tempSet];

    }
    return self;
}

//// 显示加载视图
//- (void)showLoadingViewWithSuperView:(UIView *)superView
//{
////    if (_coverView)
////    {
////        [self dissmissLoadingView];
////    }
//    _coverView = [[UIView alloc] init];
//    _coverView.frame = CGRectMake(0, 0, superView.width, superView.height);
//    [superView addSubview:_coverView];
//
//    _hudView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//    _hudView.frame = CGRectMake(0, 0, 90, 90);
//    _hudView.center = CGPointMake(_coverView.width / 2, _coverView.height / 2 - 64);
//    _hudView.layer.cornerRadius = 10;
//    _hudView.clipsToBounds = YES;
//    [_coverView addSubview:_hudView];
//
//    _loadImageBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hb_loading_color"]];
//    [_loadImageBackView sizeToFit];
//    _loadImageBackView.center = CGPointMake(_hudView.width / 2, _hudView.height / 2);
//    [_hudView.contentView addSubview:_loadImageBackView];
//
//    _loadImageTopView = [[UIImageView alloc] initWithFrame:_loadImageBackView.frame];
//    _loadImageTopView.image = [UIImage imageNamed:@"hb_loading_line"];
//    //    _loadImageTopView.backgroundColor = colorWithBlack;
//    _loadImageTopView.contentMode = UIViewContentModeTop;
//    _loadImageTopView.clipsToBounds = YES;
//    [_hudView.contentView addSubview:_loadImageTopView];
//
//    _showAnimate = YES;
//    [self showLoadingAnimate];
//}
// 显示加载视图
-(void)showLoadingViewWithSuperView:(UIView *)superView
{
    [self dissmissLoadingView];
    
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, superView.width, superView.height)];
    [superView addSubview:_coverView];
    
    UIImage *image = [UIImage imageNamed:@"loading_animation_refresh_1"];
    _hudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, image.size.width+20, image.size.height+20)];
    _hudView.center = CGPointMake(_coverView.width/2, _coverView.height/2);
    _hudView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    _hudView.layer.cornerRadius = 10;
    [_coverView addSubview:_hudView];
    
    _loadImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loading_animation_refresh_1"]];
    [_loadImageView sizeToFit];
    _loadImageView.center = CGPointMake(_hudView.width/2, _hudView.height/2);
    [_hudView addSubview:_loadImageView];
    
    NSMutableArray *imgArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<=10; i++)
    {
        [imgArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_animation_refresh_%d",i]]];
    }
    _loadImageView.animationImages = imgArray;
    _loadImageView.animationRepeatCount = -1;
    _loadImageView.animationDuration = 1;
    [_loadImageView startAnimating];
}

- (void)showLoadingAnimate
{
    [UIView animateWithDuration:1 animations:^{
        
        _loadImageTopView.height = 0;
        
    }completion:^(BOOL finished) {
        _loadImageTopView.height = _loadImageBackView.height;
        if (_showAnimate)
        {
            [self showLoadingAnimate];
        }
    }];
}


- (void)cancelButtonClick
{
    [self.requestManager.operationQueue cancelAllOperations];
    [self dissmissLoadingView];
}

// 隐藏加载视图
- (void)dissmissLoadingView
{
  
    _showAnimate = NO;
    [self.requestManager.operationQueue cancelAllOperations];
    [_coverView removeFromSuperview];
}

- (id)loadCacheWithURLString:(NSString *)URLString parameter:(NSDictionary *)parameters
{
    NSString *jsonString = ((NSDictionary *) parameters).mj_JSONString;
    if (!jsonString)
    {
        jsonString = @"";
    }
    return [_myCache objectForKey:[URLString stringByAppendingString:jsonString]];
}

/**
 *  优格post封装方法(不用写state为error的toast，不用写failure的toast，不用写result为0的toast，回调的responseObject是接收到的responseObject[@"data"]，不用再取data，不用写结束刷新)
 */
- (void) YGPOST:(NSString *)URLString
     parameters:(id)parameters
showLoadingView:(BOOL)flag
     scrollView:(UIScrollView *)scrollView
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure
{
    if ([[parameters allKeys] containsObject:@"userId"] || [[parameters allKeys] containsObject:@"userID"] ||[[parameters allKeys] containsObject:@"userid"]) {
        if (YGSingletonMarco.user == nil || YGSingletonMarco.user.userId == nil) {
            [YGAppTool showToastWithText:@"您的登录已失效，重新登录吧"];
            return;
        }
    }

    if (_netWorkStatus == NotReachable)
    {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        [YGAppTool showToastWithText:@"当前暂无网络，请检查网络设置"];
        [self dissmissLoadingView];
        if (failure)
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"当前暂无网络，请检查网络设置"};
            NSError *error = [NSError errorWithDomain:@"" code:404 userInfo:userInfo];
            failure(error);
            [self printErrorLogWithURLString:URLString parameters:parameters reason:error.localizedDescription];
        }
        return;
    }
    if (flag)
    {
        [self showLoadingViewWithSuperView:YGAppDelegate.window];
    }
    //    NSString *requestKey;
    //    if (parameters == nil)
    //    {
    //        requestKey = nil;
    //    }
    //    else
    //    {
    //        requestKey = [NSData getEncryptValueWithDic:parameters];
    //    }
    [self.requestManager POST:[NSString stringWithFormat:@"%@app/%@", Debug_Server, URLString] parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress) {
} success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        if (flag) {
            [self dissmissLoadingView];
        }
        //如果失败就toast
        if ([responseObject[@"state"] isEqualToString:@"error"]) {
            [YGAppTool showToastWithText:responseObject[@"msg"]];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: responseObject[@"msg"]};
            NSError *error = [NSError errorWithDomain:@"" code:99999 userInfo:userInfo];
            if (failure) {
                failure(error);
            }
            return;
        }

        //如果responseObject[@"data"]下含有result键
        if ([[responseObject[@"data"] allKeys] containsObject:@"result"]) {
          
            //如果result是0就toast并return
            if ([responseObject[@"data"][@"result"] isEqualToString:@"0"]) {
                [YGAppTool showToastWithText:responseObject[@"msg"]];
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: responseObject[@"msg"]};
                NSError *error = [NSError errorWithDomain:@"" code:9999 userInfo:userInfo];
                if (failure) {
                    failure(error);
                }
                return;
            }
        }


        //写缓存，先判断有没有total键
        if ([[parameters allKeys] containsObject:@"total"]) {
            if ([parameters[@"total"] intValue] == 0) {
                NSString *jsonString = ((NSDictionary *) parameters).mj_JSONString;
                if (!jsonString) {
                    jsonString = @"";
                }
                [_myCache setObject:responseObject[@"data"] forKey:[URLString stringByAppendingString:jsonString]];
            }
        } else {
            NSString *jsonString = ((NSDictionary *) parameters).mj_JSONString;
            if (!jsonString) {
                jsonString = @"";
            }
            [_myCache setObject:responseObject[@"data"] forKey:[URLString stringByAppendingString:jsonString]];
        }

        //成功block
        if (success) {
            success(responseObject[@"data"]);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        if (flag)
        {
            [self dissmissLoadingView];
        }
        [YGAppTool showToastWithText:@"服务器开小差了哦"];
        //失败block
        if (failure) {
            failure(error);
        }
        [self printErrorLogWithURLString:URLString parameters:parameters reason:error.localizedDescription];
    }];
}

/**
 *  带图片优格post封装方法(不用写state为error的toast，不用写failure的toast，不用写result为0的toast，回调的responseObject是接收到的responseObject[@"data"]，不用再取data，不用写结束刷新)
 */
- (void)YGPOST:(NSString *)URLString
               parameters:(id)parameters
          showLoadingView:(BOOL)flag
               scrollView:(UIScrollView *)scrollView
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    if (_netWorkStatus == NotReachable) {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        [YGAppTool showToastWithText:@"当前暂无网络，请检查网络设置"];
        [self dissmissLoadingView];
        if (failure) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"当前暂无网络，请检查网络设置"};
            NSError *error = [NSError errorWithDomain:@"" code:404 userInfo:userInfo];
            failure(error);
            [self printErrorLogWithURLString:URLString parameters:parameters reason:error.localizedDescription];
        }
        return;
    }
    if (flag) {
        [self showLoadingViewWithSuperView:YGAppDelegate.window];
    }

    [self.requestManager POST:[NSString stringWithFormat:@"%@app/%@", Debug_Server, URLString] parameters:parameters constructingBodyWithBlock:^(id <AFMultipartFormData> _Nonnull formData) {
        block(formData);
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        if (flag) {
            [self dissmissLoadingView];
        }
        //如果失败就toast
        if ([responseObject[@"state"] isEqualToString:@"error"]) {
            [YGAppTool showToastWithText:responseObject[@"msg"]];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: responseObject[@"msg"]};
            NSError *error = [NSError errorWithDomain:@"" code:99999 userInfo:userInfo];
            if (failure) {
                failure(error);
            }
            return;
        }

        //如果responseObject[@"data"]下含有result键
        if ([[responseObject[@"data"] allKeys] containsObject:@"result"]) {
            //如果result是0就toast并return
            if ([responseObject[@"data"][@"result"] isEqualToString:@"0"]) {
                [YGAppTool showToastWithText:responseObject[@"msg"]];
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: responseObject[@"msg"]};
                NSError *error = [NSError errorWithDomain:@"" code:9999 userInfo:userInfo];
                if (failure) {
                    failure(error);
                }
                return;
            }
        }


        //成功block
        if (success) {
            success(responseObject[@"data"]);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {

        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        if (flag) {
            [self dissmissLoadingView];
        }
        [YGAppTool showToastWithText:@"服务器开小差了哦"];
        //失败block
        if (failure) {
            failure(error);
        }
        [self printErrorLogWithURLString:URLString parameters:parameters reason:error.localizedDescription];
    }];

}

- (void)printErrorLogWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters reason:(NSString *)reason
{
    NSLog(@"*******************\nrequest failure!\npost url:%@\npost parameter:%@\nerror reason:%@\n*******************\n", [NSString stringWithFormat:@"%@/app/%@", Debug_Server, URLString], parameters.mj_JSONString, reason);
}


@end
