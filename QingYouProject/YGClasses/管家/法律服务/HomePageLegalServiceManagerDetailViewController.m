//
//  HomePageLegalServiceVIPDetailViewController.m
//  QingYouProject
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "HomePageLegalServiceManagerDetailViewController.h"
#import "NSString+LDAttributedString.h"//富文本属性
#import <WebKit/WebKit.h>
@interface HomePageLegalServiceManagerDetailViewController ()<SDCycleScrollViewDelegate>
/** 文字label  */
@property (nonatomic,strong) UILabel * bottomLabel;
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 轮播图  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) WKWebView * webView;

@end

@implementation HomePageLegalServiceManagerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络请求
    [self sendRequest];
    
    //设置导航栏
    self.naviTitle = @"法律服务服务介绍";
    
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
    
    [YGNetService YGPOST:@"LawIndexDetail" parameters:@{@"type":@"1"} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
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
        
        LDLog(@"%@",error);
    }];
}


#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //    [YGAppTool showToastWithText:[NSString stringWithFormat:@"点击了第%ld张图片",index]];
    
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

