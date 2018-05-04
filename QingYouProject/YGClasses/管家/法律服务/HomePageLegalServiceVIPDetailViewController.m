//
//  HomePageLegalServiceVIPDetailViewController.m
//  QingYouProject
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "HomePageLegalServiceVIPDetailViewController.h"
#import "NSString+LDAttributedString.h"//富文本属性
#import <WebKit/WebKit.h>
#import "HomePageLegalServiceManagerApplyViewController.h"

@interface HomePageLegalServiceVIPDetailViewController ()<SDCycleScrollViewDelegate>
/** 顶部文字label  */
@property (nonatomic,strong) UILabel * topLabel;
/** 底部文字label  */
@property (nonatomic,strong) UILabel * bottomLabel;
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 轮播图  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) WKWebView *webView;


@end

@implementation HomePageLegalServiceVIPDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络请求
    [self sendRequest];
    
    //设置导航栏
    self.naviTitle = @"VIP卡介绍";
    
    //设置UI视图
    [self setupUI];
    
    
}
#pragma mark - 设置UI视图
- (void)setupUI{
    
    CGFloat Y = kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - YGBottomMargin;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, Y)];
    [self.view addSubview:self.webView];
    
    //悬浮视图
    UIButton * bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(0, Y, kScreenW, YGNaviBarHeight + YGBottomMargin);
    [bottomButton setTitle:@"立即下单" forState:UIControlStateNormal];
    [self.view addSubview:bottomButton];
    [bottomButton addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.backgroundColor = colorWithMainColor;
    [self.view addSubview:bottomButton];
    [bottomButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
}
-(void)bottomButtonClick:(UIButton *)btn{
    HomePageLegalServiceManagerApplyViewController * vc = [[HomePageLegalServiceManagerApplyViewController alloc] init];
    vc.isVIP =self.isVIP;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 网络请求

- (void)sendRequest{
    
    [YGNetService YGPOST:@"LawIndexDetail" parameters:@{@"type":@"2"} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
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


@end

