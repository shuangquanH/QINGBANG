//
//  IntegrationIndustryWebViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "IntegrationIndustryWebViewController.h"
#import <WebKit/WebKit.h>

@interface IntegrationIndustryWebViewController ()
@property (nonatomic, strong) WKWebView * webView;

@end

@implementation IntegrationIndustryWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络请求
    [self sendRequest];
    
    if([self.isPush isEqualToString:@"Integration"])
       self.naviTitle = @"工商一体化";
    else
        self.naviTitle = @"财务代记账";

    //设置UI视图
    [self setupUI];
    
    
}
#pragma mark - 设置UI视图
- (void)setupUI{
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight)];
    [self.view addSubview:self.webView];
    
}
#pragma mark - 网络请求数据
- (void)sendRequest{
    NSString * url =@"FinanceIndexDetail";
    if([_isPush isEqualToString:@"Integration"])
       url =@"CommerceIndexDetail";
    
    [YGNetService YGPOST:url parameters:@{@"type":self.type} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        [self.webView loadHTMLString: [NSString stringWithFormat:
                                       @"<html> \n"
                                       "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">\n"
                                       "<style type=\"text/css\"> \n"
                                       "max-width:100%%"
                                       "</style> \n"
                                       "</head> \n"
                                       "<body>%@</body> \n"
                                       "</html>",responseObject[@"detail"]
                                       ] baseURL:nil];
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

