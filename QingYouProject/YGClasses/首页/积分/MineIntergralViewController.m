//
//  MineIntergralViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralViewController.h"
#import "MineIntergralRecordOrderViewController.h"
#import "MineIntergralRecordConvertViewController.h"
#import "MineIntergralRecordViewController.h"
#import <WebKit/WebKit.h>

@interface MineIntergralViewController () <WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIView *getIntergralTipView;//下面的view


@end

@implementation MineIntergralViewController
{
    UIImageView *_coverImageView;
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_signLabel;
    UIView *headerView;
    UIScrollView *_mainScrollView;
    UIView *_titleBaseView;
    NSDictionary *_dataDic;
    NSString *_pointString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pointString = @"";
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _dataDic = [[NSDictionary alloc]init];
    if (!_pointString.length) {
        [self loadData];
    }else
    {
        [self loadInteralData];
    }
    
}

- (void)configAttribute
{
//    self.naviTitle = @"我的青币";
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 120, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"我的青币";
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    
    UIBarButtonItem *buttonItem =[self createBarbuttonWithNormalTitleString:@"青币记录" selectedTitleString:@"青币记录" selector:@selector(intergralRecored)];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
}

//只加载青币
-(void)loadInteralData
{
    [YGNetService YGPOST:@"IntegralHome" parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_mainScrollView success:^(id responseObject) {
        
        _dataDic = responseObject;
        
        YGSingletonMarco.user.point = [NSString stringWithFormat:@"%@",responseObject[@"point"]] ;

        _pointString = [NSString stringWithFormat:@"%@",_dataDic[@"point"]];
        
        _signLabel.text = _pointString;
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)loadData
{
    [YGNetService YGPOST:@"IntegralHome" parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_mainScrollView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        _dataDic = responseObject;
        
        _pointString = [NSString stringWithFormat:@"%@",_dataDic[@"point"]];
        
        [self configUI];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ---- 配置UI
-(void)configUI
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)];
    _mainScrollView.backgroundColor = colorWithTable;
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, YGScreenHeight);
    [self.view addSubview:_mainScrollView];
    
    /********************** 头视图两个按钮 *****************/
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.45)];
    headerView.backgroundColor = colorWithMainColor;
    [_mainScrollView addSubview:headerView];
    //水滴
    _coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,YGScreenWidth, YGScreenWidth*0.45)];
    _coverImageView.backgroundColor = colorWithMainColor;
//    _coverImageView.image = [UIImage imageNamed:@"mine_integral_bg"];
//    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
//    _coverImageView.clipsToBounds = YES;
    _coverImageView.userInteractionEnabled = YES;
//    [_coverImageView sizeToFit];
    [headerView addSubview:_coverImageView];
    
    //头像
    _headerImageView = [[UIImageView alloc]init];
    _headerImageView.frame = CGRectMake(10,15,30, 30);
    _headerImageView.layer.cornerRadius = 15;
    _headerImageView.layer.borderColor = colorWithTable.CGColor;
    _headerImageView.layer.borderWidth = 1;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.backgroundColor = colorWithMainColor;
    [_coverImageView addSubview:_headerImageView];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"img"]] placeholderImage:YGDefaultImgAvatar];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headerImageView.x+_headerImageView.width+10, _headerImageView.y+10, YGScreenWidth-20, 20)];
    _nameLabel.textColor = colorWithYGWhite;
//    _nameLabel.text = @"jdsadsa";
    _nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    [_coverImageView addSubview:_nameLabel];
    _nameLabel.centery = _headerImageView.centery;
    _nameLabel.text = _dataDic[@"name"];
    
    


    //热门推荐label
    _signLabel = [[UILabel alloc]init];
    _signLabel.textColor = colorWithYGWhite;
    _signLabel.font = [UIFont systemFontOfSize:22.0];
//    _signLabel.text = @"1520";
    _signLabel.textAlignment = NSTextAlignmentCenter;
    _signLabel.frame = CGRectMake(15, headerView.height/2-25,YGScreenWidth-30, 50);
    [_coverImageView addSubview:_signLabel];
    _signLabel.text = _pointString;
    
    
    UIButton *intergralNowButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2-35, _signLabel.y+_signLabel.height, 70, 25)];
//    [focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    intergralNowButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [intergralNowButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [intergralNowButton setTitle:@"当前青币" forState:UIControlStateNormal];
    intergralNowButton.layer.borderColor = colorWithYGWhite.CGColor;
    intergralNowButton.layer.borderWidth = 1;
    intergralNowButton.layer.cornerRadius = 12;
    intergralNowButton.clipsToBounds = YES;
    [_coverImageView addSubview:intergralNowButton];
    
    /********************** 选择器 ********************/
    
    _titleBaseView  = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height+10, YGScreenWidth,75)];
    _titleBaseView.backgroundColor = colorWithYGWhite;
    [_mainScrollView addSubview:_titleBaseView];
    
    NSArray *titleArr = @[
                          @{@"title":@"青币兑换",@"content":@"多种好礼换不停",@"img":@"mine_integral_exchange"},
                          @{@"title":@"我的订单",@"content":@"一键查询订单状态",@"img":@"mine_integral_order"}
                          ];

    for (int i = 0; i<titleArr.count; i++)
    {
        NSDictionary *dict = titleArr[i];
        UIView *contentBaseView  = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/2*i, 15, YGScreenWidth/2,45)];
        [_titleBaseView addSubview:contentBaseView];
        
        //水滴
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dict[@"img"]]];
        imageView.frame = CGRectMake(contentBaseView.width-55,0,45, 45);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [contentBaseView addSubview:imageView];

        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, YGScreenWidth/2-imageView.width-30, 25)];
        titleLabel.textColor = colorWithBlack;
        titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        titleLabel.text = dict[@"title"];
        [contentBaseView addSubview:titleLabel];
        
        //热门推荐label
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, YGScreenWidth/2-imageView.width-30, 20)];
        contentLabel.textColor = colorWithDeepGray;
        contentLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        contentLabel.text = dict[@"content"];
//        contentLabel.textAlignment = NSTextAlignmentCenter;
        [contentBaseView addSubview:contentLabel];
  
        UIButton *intergralFunctionButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,contentBaseView.width,contentBaseView.height)];
            [intergralFunctionButton addTarget:self action:@selector(intergralFunctionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        intergralFunctionButton.tag = 10000+i;
        [contentBaseView addSubview:intergralFunctionButton];
    }
    
    UIView *lineView  = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/2, 0, 1,_titleBaseView.height)];
    lineView.backgroundColor = colorWithLine;
    [_titleBaseView addSubview:lineView];
    
    
    self.getIntergralTipView = [[UIView alloc] initWithFrame:CGRectMake(10, _titleBaseView.y+_titleBaseView.height+10, YGScreenWidth-20,100)];
    self.getIntergralTipView .backgroundColor = colorWithYGWhite;
    [_mainScrollView addSubview:self.getIntergralTipView ];
    
    UIView *baseLineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 35, YGScreenWidth*0.55,1)];
    baseLineView.backgroundColor = colorWithPlaceholder;
    [self.getIntergralTipView  addSubview:baseLineView];
    baseLineView.centerx = self.view.centerx;
    
    UILabel *getIntergralTipTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(YGScreenWidth/2-60, 25, 120, 20)];
    getIntergralTipTitleLabel.textColor = colorWithBlack;
    getIntergralTipTitleLabel.backgroundColor = colorWithYGWhite;
    getIntergralTipTitleLabel.font = [UIFont boldSystemFontOfSize:YGFontSizeBigTwo];
    getIntergralTipTitleLabel.text = @"获取青币攻略";
    getIntergralTipTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.getIntergralTipView  addSubview:getIntergralTipTitleLabel];
    getIntergralTipTitleLabel.centery = baseLineView.centery;
    
    //以下代码适配大小
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, _titleBaseView.y+_titleBaseView.height+70, YGScreenWidth, 100) configuration:wkWebConfig];
    [_mainScrollView addSubview:self.webView];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.alwaysBounceVertical = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.webView loadHTMLString: [NSString stringWithFormat:
                                   @"<html> \n"
                                   "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">\n"
                                   "<style type=\"text/css\"> \n"
                                   "max-width:100%%"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>",_dataDic[@"text"]
                                   ] baseURL:nil];
    
    
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
// 页面加载完成之后调用 此方法会调用多次
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    __block CGFloat webViewHeight;
    
    //document.body.scrollHeight
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以(@"document.getElementById(\"content\").offsetHeight;")，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        webViewHeight = [result doubleValue];
        webView.height = webViewHeight;
        self.webView.frame = CGRectMake(10, _titleBaseView.y+_titleBaseView.height+70, YGScreenWidth - 20, webView.height);
        _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, _titleBaseView.y+_titleBaseView.height + 70 + webView.height);
        NSLog(@"%f",webViewHeight);
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

- (void)intergralRecored
{
    MineIntergralRecordViewController *vc = [[MineIntergralRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)intergralFunctionButtonAction:(UIButton *)button
{
    if (button.tag-10000 == 0) {
        MineIntergralRecordConvertViewController *vc = [[MineIntergralRecordConvertViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag-10000 == 1) {
        MineIntergralRecordOrderViewController *vc = [[MineIntergralRecordOrderViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
