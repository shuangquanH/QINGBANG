//
//  SQBaseWebViewController.m
//  SQAPPSTART
//
//  Created by apple on 2018/4/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SQBaseWebViewController.h"
#import "MBProgressHUD.h"

@implementation WeakScriptMessageDelegate
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end


@interface SQBaseWebViewController () <WKNavigationDelegate, WKScriptMessageHandler>

@end

@implementation SQBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:self.webUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}



#pragma delegates
//页面跳转时调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated){
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 页面加载完毕时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
}

//前端调用js方法的回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self htmlCallMethodName:message.name withBody:message.body];
}
- (void)htmlCallMethodName:(NSString    *)name withBody:(NSString   *)body {
    NSLog(@"前端调用了%@方法，参数为:%@，请重写该方法", name, body);
}
//原生调用js方法
- (void)ocCallJsWithMethodName:(NSString    *)method back:(void(^)(_Nullable id))block {
    [self.webView evaluateJavaScript:method completionHandler:^(id _Nullable responds, NSError * _Nullable error) {
        if (!error&&responds) {
            NSString    *respondStr = [NSString stringWithFormat:@"%@", responds];
            block(respondStr);
        }
    }];
}


#pragma setJSMethordArr
- (void)setJsMethodArr:(NSArray *)jsMethodArr {
    _jsMethodArr = jsMethodArr;
    for (NSString *method in self.jsMethodArr) {
        WeakScriptMessageDelegate *delegate = [[WeakScriptMessageDelegate alloc] initWithDelegate:self];
        [_webView.configuration.userContentController addScriptMessageHandler:delegate name:method];
    }
}

#pragma mark LazyLoad
- (WKWebView    *)webView {
    if (!_webView) {
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
        CGRect  frame = self.view.bounds;
        _webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

#pragma dealloc
- (void)dealloc {
    _webView.navigationDelegate = nil;
    [_webView.configuration.userContentController removeAllUserScripts];
}

@end
