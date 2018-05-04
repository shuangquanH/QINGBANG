//
//  PlayTogetherAgreementController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherAgreementController.h"

#import <WebKit/WebKit.h>

@interface PlayTogetherAgreementController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)WKWebViewConfiguration *wkWebConfig;

@end

@implementation PlayTogetherAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"服务协议";
    
    [self loadData];
    
}

-(void)loadData
{
    [YGNetService YGPOST:@"AllianceActivityAgreement" parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *htmlString = [responseObject valueForKey:@"agreement"];
        
        //以下代码适配大小
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        self.wkWebConfig = [[WKWebViewConfiguration alloc] init];
        self.wkWebConfig.userContentController = wkUController;
        
        
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight) configuration:self.wkWebConfig];
        
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.alwaysBounceVertical = YES;
        [self.view addSubview:_webView];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        [_webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        
        [_webView loadHTMLString: [NSString stringWithFormat:
                                   @"<html> \n"
                                   "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">\n"
                                   "<style type=\"text/css\"> \n"
                                   "max-width:100%%"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>",htmlString
                                   ] baseURL:nil];
        
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
