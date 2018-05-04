//
//  CooperateThingViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CooperateThingViewController.h"
#import <WebKit/WebKit.h>

@interface CooperateThingViewController ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation CooperateThingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"合作案例";
    
    
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight)];
    self.webView.navigationDelegate = self;
    //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
//    [self.webView loadHTMLString:@"" baseURL:nil];
    [self loadData];
    
    [self.view addSubview:self.webView];
}
-(void)loadData
{
    [YGNetService YGPOST:REQUEST_AdsCooperationDetail parameters:@{@"cooperationID":self.cooperationIdString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [self.webView loadHTMLString:[responseObject valueForKey:@"cooperationDetail"] baseURL:nil];
        
    } failure:^(NSError *error) {
        
    }];
}


// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    [self loadData];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
