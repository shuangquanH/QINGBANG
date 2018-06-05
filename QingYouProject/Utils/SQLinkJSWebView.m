//
//  SQBaseWebView.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/5.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQLinkJSWebView.h"
#import "SQBaseWebViewController.h"
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////



@implementation SQLinkJSWebView


- (instancetype)initWithFrame:(CGRect)frame
{
    //初始化一个WKWebViewConfiguration对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //允许视频播放
    config.allowsAirPlayForMediaPlayback = YES;
    // 允许在线播放
    config.allowsInlineMediaPlayback = YES;
    // 允许可以与网页交互，选择视图
    config.selectionGranularity = YES;
    //初始化偏好设置属性：preferences
    config.preferences = [[WKPreferences alloc] init];
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    self = [super initWithFrame:frame configuration:config];
    if (self) {
        
    }
    return self;
}


- (void)loadWebWithUrl:(NSString    *)url {
    NSURL *loadurl = [NSURL URLWithString:url];
    [self loadRequest:[NSURLRequest requestWithURL:loadurl]];
}

/** 调用js方法  */
- (void)ocCallJsWithMethodName:(NSString    *)method back:(void(^)(NSString*,_Nullable id))block {
    [self evaluateJavaScript:method completionHandler:^(id _Nullable responds, NSError * _Nullable error) {
        if (!error&&responds) {
            NSString    *respondStr = [NSString stringWithFormat:@"%@", responds];
            block(method, respondStr);
        }
    }];
}

/** html调用js方法  */
- (void)registJSFunctionWithName:(NSString  *)jsName back:(void(^)(NSString*,_Nullable id))block {
    WeakScriptMessageDelegate *delegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
    [self.configuration.userContentController addScriptMessageHandler:delegate name:jsName];
    self.webJSCallBack = block;
}

//前端调用js方法的回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    self.webJSCallBack(message.name, message.body);
}

- (void)dealloc {
    [self.configuration.userContentController removeAllUserScripts];
}

@end
