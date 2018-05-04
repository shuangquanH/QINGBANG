//
//  ServiceIntroduceViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ServiceIntroduceViewController.h"
#import <WebKit/WebKit.h>
#define heraderHeight           (YGScreenWidth/2+40+5)

@interface ServiceIntroduceViewController ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@end

@implementation ServiceIntroduceViewController
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
    if([self.superVCType isEqualToString:@"IntegrationIndustryCommerceController"])
    {
        [YGNetService YGPOST:@"CommerceInfo" parameters:@{@"commerceID":self.commerceID}  showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            [_webView loadHTMLString:responseObject[@"commerceInfo"] baseURL:nil];
            
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        [YGNetService YGPOST:@"FinanceInfo" parameters:@{@"financeID":self.commerceID}  showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            [_webView loadHTMLString:responseObject[@"financeInfo"] baseURL:nil];
            
        } failure:^(NSError *error) {
            
        }];
    }
  
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
    

    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-60-49) configuration:wkWebConfig];
    
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.alwaysBounceVertical = YES;
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.51.104:8080/msxs-api/api/static/get?id=1"]]];
    [_scrollView addSubview:_webView];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    [_webView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"webbg.png"]]];
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.frame = CGRectMake(0, 0, YGScreenWidth, 10);

    _webView.backgroundColor =[UIColor whiteColor];

    if(![self.superVCType isEqualToString:@"IntegrationIndustryCommerceController"])
    {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, _webView.height+10, YGScreenWidth, YGScreenWidth*0.43)];
        _baseView.backgroundColor = colorWithYGWhite;
        [_scrollView addSubview:_baseView];
        
        [self createRecommendServiceViews];
    }

}

- (void)createRecommendServiceViews
{
    UILabel *recommendTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, YGScreenWidth-20, 25)];
    recommendTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    recommendTitleLabel.textColor = colorWithBlack;
    recommendTitleLabel.text = @"为您推荐以下服务";
    [_baseView addSubview:recommendTitleLabel];
    
    UIScrollView *littleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, recommendTitleLabel.height+10, YGScreenWidth-15, YGScreenWidth*0.33)];
    littleScrollView.contentSize = CGSizeMake((YGScreenWidth*0.28+10)*4, YGScreenWidth*0.33);
    [_baseView addSubview:littleScrollView];
    
//    width = 0.28   h =0.58
    NSArray * titleArray = @[@"工商注册",@"地址咨询",@"网络管家"];
    for (int i = 0; i<self.serviceArray.count; i++) {
        //背景
        UIImageView * baseImg = [[UIImageView alloc]initWithFrame:CGRectMake((YGScreenWidth*0.28+10)*i, 10, YGScreenWidth*0.28, YGScreenWidth*0.28*0.58)];
        [baseImg sd_setImageWithURL:[NSURL URLWithString:self.serviceArray[i]] placeholderImage:YGDefaultImgFour_Three];
        baseImg.contentMode = UIViewContentModeScaleAspectFill;
        baseImg.layer.cornerRadius = 5;
        baseImg.clipsToBounds = YES;
        [littleScrollView addSubview:baseImg];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(baseImg.x, baseImg.y+baseImg.height+5,YGScreenWidth*0.28,25)];
        titleLabel.text = titleArray[i];
        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        titleLabel.textColor = colorWithBlack;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [littleScrollView addSubview:titleLabel];
        
        UIButton * selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(baseImg.x, 10, YGScreenWidth*0.28, YGScreenWidth*0.28*0.58 + 30)];
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = 100+i;
        [littleScrollView addSubview:selectBtn];
    }
}
-(void)selectBtnClick:(UIButton *)btn
{
    [self.serviceIntroduceViewControllerDelegate serviceIntroduceViewControllerSelectBtnClick:btn];
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
        _webView.height = webViewHeight +10;
        
        if(![self.superVCType isEqualToString:@"IntegrationIndustryCommerceController"])
          _baseView.frame =CGRectMake(0, webViewHeight+20, YGScreenWidth, YGScreenWidth*0.43);
        _scrollView.contentSize = CGSizeMake(YGScreenWidth, webView.height+_baseView.height+10);
        
        
//        CGRect frame =webView.frame;
//        frame.size.height =webViewHeight;
//        webView.frame = frame;
//        _baseView.frame =CGRectMake(0, webView.height+10, YGScreenWidth, YGScreenWidth*0.43);
//        _scrollView.contentSize = CGSizeMake(YGScreenWidth, webView.height+_baseView.height+10);
        
//        _webView.scrollView.contentSize = CGSizeMake(YGScreenWidth, webViewHeight);

    }];
 
}

//滚动是触发代理 页面顶部除segement保留 其他都折叠
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
        CGFloat yOffset = scrollView.contentOffset.y;//偏移的y值
        [self.serviceIntroduceViewControllerDelegate scrollViewDidScrollWithHeight:yOffset];
    
}

@end
