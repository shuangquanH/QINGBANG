//
//  FundSupportProjectAchieveViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RoadShowHallProjectAchieveViewController.h"
#import <WebKit/WebKit.h>
#define heraderHeight           (YGScreenWidth/2+40+5)

@interface RoadShowHallProjectAchieveViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@end

@implementation RoadShowHallProjectAchieveViewController
{
    WKWebView       *_webView;
    UIScrollView *_scrollView;
    UIView      *_baseView;
}

- (void)setContent:(NSString *)content
{
    [_webView loadHTMLString:content baseURL:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = self.controllerFrame;
    
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
    //    _webView.scrollView.bounces = NO;
    _webView.scrollView.alwaysBounceVertical = YES;
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    [_webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
}
- (void)configAttribute
{
    
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
    }];
    
}

//滚动是触发代理 页面顶部除segement保留 其他都折叠
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;//偏移的y值
    [self.roadShowHallProjectAchieveViewControllerDelegate scrollViewDidScrollWithHeight:yOffset];
    
}
- (void)dealloc
{
    _webView.scrollView.delegate = nil;
}
@end
