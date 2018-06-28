//
//  ServiceIntroductionViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ServiceIntroductionViewController.h"
#import "ServiceIntroduceModel.h"//Model
#import <WebKit/WebKit.h>


@interface ServiceIntroductionViewController ()<SDCycleScrollViewDelegate,WKNavigationDelegate>
/** 文字label  */
@property (nonatomic,strong) UILabel * bottomLabel;
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 轮播图  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/** ServiceIntroduceModel  */
@property (nonatomic,strong) ServiceIntroduceModel * model;
@property (nonatomic,strong) WKWebView * footerWebView;

@end

@implementation ServiceIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    self.naviTitle = @"服务介绍";
    
    //设置UI视图
    [self setupUI];
    
    //设置导航栏
    [self setupNav];
    //网络请求
    [self sendRequest];
}

#pragma mark - 网络
- (void)sendRequest{
    
    
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    dict[@"userId"] = LDReadForLocation(LDUserId);
//    dict[@"total"] = self.totalString;
//    dict[@"count"] = self.countString;
   
    
    
    [YGNetService YGPOST:@"ServiceIntroduction" parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        //字典转模型
        self.model = [ServiceIntroduceModel mj_objectWithKeyValues:responseObject[@"serviceIntroduction"]];
        
        //轮播图
        NSString * picURl = self.model.servicePicture;
        
        NSArray * dataArray = @[picURl];
        
        self.cycleScrollView.imageURLStringsGroup = dataArray;
        
//        self.bottomLabel.attributedText = [textStr ld_getAttributedStringWithString:textStr lineSpace:LDVPadding];
        [self.footerWebView loadHTMLString: [NSString stringWithFormat:
                                             @"<html> \n"
                                             "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">\n"
                                             "<style type=\"text/css\"> \n"
                                             "max-width:100%%"
                                             "</style> \n"
                                             "</head> \n"
                                             "<body>%@</body> \n"
                                             "</html>",
                                             self.model.serviceIntroduce] baseURL:nil];
        
        
    } failure:^(NSError *error) {
       
    }];
}

#pragma mark - 设置导航栏
- (void)setupNav{
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalImageName:@"decorate_nav_icon" selectedImageName:@"service_black" selector:@selector(rightBarButtonClick:)];
    
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    
    [self contactWithCustomerServerWithType:ContactServerPropertyRepair button:rightBarButton];
}
#pragma mark - 设置UI视图
- (void)setupUI{
    
    //背景scrollowView
    UIScrollView * backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT - YGNaviBarHeight - YGStatusBarHeight)];
    backScrollowView.backgroundColor = KCOLOR_WHITE;
    [self.view addSubview:backScrollowView];
    self.backScrollowView = backScrollowView;
    
    UIView * container = [[UIView alloc] init];
    container.backgroundColor = KCOLOR_WHITE;
    [self.backScrollowView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.left.right.offset(0);
        make.width.equalTo(backScrollowView);
        
    }];
    
    //顶部试图
    UIView * headerView = [UIView new];
    [container addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.left.offset(0);
        make.height.offset(KAPP_WIDTH / (35 / 17));
    }];
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT / (35 / 17)) delegate:self placeholderImage:YGDefaultImgTwo_One];
    _cycleScrollView.autoScrollTimeInterval = 3;
    [headerView addSubview:self.cycleScrollView];
    
    //底部试图
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
    
    self.footerWebView = [[WKWebView alloc] init];
    self.footerWebView.scrollView.scrollEnabled = NO;
    [container addSubview:self.footerWebView];
    self.footerWebView.navigationDelegate = self;
    [self.footerWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);

        make.top.equalTo(headerView.mas_bottom).offset(2 * 10);
        make.bottom.equalTo(container.mas_bottom).offset(-20);

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

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.footerWebView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        float webViewHeight = [result doubleValue];
        CGRect frame = webView.frame;
        frame.size.height = webViewHeight + 3* 10;
        webView.frame = frame;
        
        self.backScrollowView.contentSize = CGSizeMake(0, webViewHeight + 4* 10 + KAPP_WIDTH / (35 / 17));
    }];
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
