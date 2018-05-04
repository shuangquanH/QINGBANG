//
//  NetManagerDetailVC.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "NetManagerDetailVC.h"
#import "NSString+LDAttributedString.h"//富文本属性
#import <WebKit/WebKit.h>

@interface NetManagerDetailVC ()<SDCycleScrollViewDelegate>
/** 文字label  */
@property (nonatomic,strong) UILabel * bottomLabel;
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 轮播图  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) WKWebView * webView;

@end

@implementation NetManagerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络请求
    [self sendRequest];
    
    //设置导航栏
    self.naviTitle = @"网络管理服务介绍";
    
    //设置UI视图
    [self setupUI];
  
    
}
#pragma mark - 设置UI视图
- (void)setupUI{
    
//    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
//    [self.view addSubview:self.webView];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight)];
    [self.view addSubview:self.webView];

    
//    //背景scrollowView
//    UIScrollView * backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight)];
//    backScrollowView.backgroundColor = kWhiteColor;
//    [self.view addSubview:backScrollowView];
//    self.backScrollowView = backScrollowView;
//
//    UIView * container = [[UIView alloc] init];
//    container.backgroundColor = kWhiteColor;
//    [self.backScrollowView addSubview:container];
//
//    [container mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.bottom.left.right.offset(0);
//        make.width.equalTo(backScrollowView);
//
//    }];
//
//
//    //顶部试图
//    UIView * headerView = [UIView new];
//    headerView.backgroundColor = LDRandomColor;
//    [container addSubview:headerView];
//    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(LDVPadding);
//        make.right.offset(-LDHPadding);
//        make.left.offset(LDHPadding);
//        make.height.offset((LDVPadding, kScreenW - 2 * LDHPadding) / (35 / 17));
//    }];
//
//    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW - 2 * LDHPadding, (LDVPadding, kScreenW - 2 * LDHPadding) / (35 / 17)) delegate:self placeholderImage:LDImage(LDManagerBannerImage)];
//    _cycleScrollView.autoScrollTimeInterval = 3;
//    _cycleScrollView.backgroundColor = kClearColor;
//    [headerView addSubview:self.cycleScrollView];
//
//    //底部试图
//    UILabel * bottomLabel = [UILabel new];
//    bottomLabel.numberOfLines = 0;
//    self.bottomLabel = bottomLabel;
//    self.bottomLabel.textColor = LD9ATextColor;
//    [container addSubview:self.bottomLabel];
//    bottomLabel.textColor = colorWithLightGray;
//    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(LDHPadding);
//        make.right.offset(-LDHPadding);
//        make.top.equalTo(headerView.mas_bottom).offset(2 * LDVPadding);
//        make.bottom.equalTo(container.mas_bottom).offset(-20);
//
//    }];
//
//    //假数据
//    NSString * textStr = @"轻轻的我走了,正如我轻轻的来,我轻轻的招手,作别西天的云彩,那河畔的金柳, 是夕阳中的新娘,波光里的艳影,在我的心头荡漾,软泥上的青荇,油油的在水底招摇,在康河的柔波里,我甘心做一条水草,那榆荫下的一潭,不是清泉袁是天上虹,揉碎在浮藻间,沉淀着彩虹似的梦,寻梦撑一支长篙,向青草更青处漫溯,满载一船星辉,在星辉斑斓里放歌,但我不能放歌,悄悄是别离的笙箫,夏虫也为我沉默,沉默是今晚的康桥!悄悄的我走了,正如我悄悄的来,我挥一挥衣袖,不带走一片云彩.";
//
//    self.bottomLabel.attributedText = [textStr ld_getAttributedStringWithString:textStr lineSpace:LDVPadding];
}
#pragma mark - 网络请求数据
- (void)sendRequest{
    
    [YGNetService YGPOST:@"NetIndexDetail" parameters:@{@"type":@"1"} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
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
