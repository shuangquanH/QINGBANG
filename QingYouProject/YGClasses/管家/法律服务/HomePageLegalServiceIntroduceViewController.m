//
//  HomePageLegalServiceIntroduceViewController.m
//  QingYouProject
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "HomePageLegalServiceIntroduceViewController.h"
#import <WebKit/WebKit.h>
#define heraderHeight           (YGScreenWidth/2+40+5)
@interface HomePageLegalServiceIntroduceViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@end

@implementation HomePageLegalServiceIntroduceViewController
{
    WKWebView       *_webView;
    UIScrollView *_scrollView;
    UIView      *_baseView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)loadData
{
    [YGNetService YGPOST:@"LawServiceInfo" parameters:@{@"serviceID":self.serviceID}  showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        [_webView loadHTMLString:responseObject[@"serviceInfo"] baseURL:nil];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)configAttribute
{
    self.view.frame = self.controllerFrame;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _scrollView.height);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor =colorWithTable;
    
    //以下代码适配大小
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height) configuration:wkWebConfig];
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.alwaysBounceVertical = YES;
    //    _webView.scrollView.delegate = self;
    //    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.51.104:8080/msxs-api/api/static/get?id=1"]]];
    [_scrollView addSubview:_webView];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    [_webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    [_webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        float webViewHeight = [result doubleValue];
        //        CGRect frame =_webView.frame;
        //        frame.size.height =webViewHeight;
        //        _webView.frame = frame;
        _webView.scrollView.contentSize = CGSizeMake(YGScreenWidth, webViewHeight);
        _scrollView.contentSize = CGSizeMake(YGScreenWidth, webView.height+10);
        
    }];
    
}

//滚动是触发代理 页面顶部除segement保留 其他都折叠
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;//偏移的y值
    [self.netIntroduceViewControllerDelegate scrollViewDidScrollWithHeight:yOffset];
    
}
@end

