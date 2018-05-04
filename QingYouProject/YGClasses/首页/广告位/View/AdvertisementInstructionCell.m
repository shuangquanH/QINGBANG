//
//  AdvertisementInstructionCell.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AdvertisementInstructionCell.h"

@interface AdvertisementInstructionCell ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation AdvertisementInstructionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 30, 55)];
//    self.webView.navigationDelegate = self;
//    [self.contentView addSubview:self.webView];
    
    //以下代码适配大小
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight) configuration:wkWebConfig];
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.alwaysBounceVertical = YES;
    [self.contentView addSubview:_webView];
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
                               "</html>",self.htmlString
                               ] baseURL:nil];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel).offset(15 + self.titleLabel.height);
        make.bottom.mas_equalTo(self.contentView).offset(-15);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    [self.webView loadHTMLString:self.htmlString baseURL:nil];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
//// 页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//    CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
//    self.height = fittingSize.height;
//    self.webView.frame = CGRectMake(0, 0, fittingSize.width, fittingSize.height);
//}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
    self.height = fittingSize.height;
    self.webView.frame = CGRectMake(0, 0, fittingSize.width, fittingSize.height);
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
