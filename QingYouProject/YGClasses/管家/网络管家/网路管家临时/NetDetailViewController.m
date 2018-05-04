//
//  NetDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "NetDetailViewController.h"
#import "YGSegmentView.h"
#import "LDApplyVC.h"//立即申请

//#define heraderHeight           (YGScreenWidth+110)

#import "NetIntroduceViewController.h"
#import "ServiceEvaluationViewController.h"
#import "TradeRecordViewController.h"

@interface NetDetailViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,YGSegmentViewDelegate,netIntroduceViewControllerDelegate,ServiceEvaluationViewControllerDelegate,TradeRecordViewControllerDelegate>
{
    NSMutableArray * _controllersArray;//Controller数组
    YGSegmentView * _segmentView;//选择器
    UIScrollView * _scrollView;
    NetIntroduceViewController * _netIntroduceViewController;
    ServiceEvaluationViewController * _serviceEvaluationViewController;
    TradeRecordViewController * _tradeRecordViewController;
    
    UIView          *_fadeNavibar; //假navi
    CGFloat                     _alpha;
    UIStatusBarStyle            _statusbarStayle;
    UIButton                    *_shareButton; //右边的按钮
    UIButton                    *_favoriteButton; //左边的返回
    UIButton                    *_backButton; //左边的返回
    UILabel      *_naviTitleLabel;
    NSMutableDictionary * _serviceDetail;
    NSString *_isCollect;
    NSString *_url;
    CGFloat _heraderHeight;
    UIView *_navLineView;
}

@end

@implementation NetDetailViewController
{
    SDCycleScrollView *_adScrollview; //广告轮播
    UIView          *_baseView;
    UILabel *_titleLabel;
    UILabel *_newPriceLabel;
    UILabel  *_oldPriceLabel;
    UIView *_seperateView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configAttribute];
 
    
    [self configUI];
    [self loadDataFromServer];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    [self setStatusBarStyle:_statusbarStayle];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setStatusBarStyle:UIStatusBarStyleDefault];

}

#pragma mark ---- 重写导航条
- (void)configAttribute
{
    self.fd_prefersNavigationBarHidden = YES;
    _statusbarStayle = UIStatusBarStyleLightContent ;

}
#pragma mark - 网络请求
- (void)loadDataFromServer
{
    [YGNetService YGPOST:@"NetService" parameters:@{@"serviceID":self.serviceID,@"userID":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        _url = responseObject[@"url"];
         _serviceDetail =  responseObject[@"serviceDetail"];
        _adScrollview.imageURLStringsGroup = _serviceDetail[@"serviceImg"];
        _titleLabel.text = [NSString stringWithFormat:@"%@-%@",_serviceDetail[@"serviceName"],_serviceDetail[@"serviceIntroduction"]];
        
        CGFloat titleLabelH = [UILabel calculateWidthWithString:_titleLabel.text textFont:[UIFont systemFontOfSize:18] numerOfLines:0].height;
        _titleLabel.frame = CGRectMake(15, _adScrollview.height ,YGScreenWidth-30,  titleLabelH + (55 -18));

        _seperateView.frame = CGRectMake(0, _titleLabel.y+_titleLabel.height, YGScreenWidth, 10);
//        _baseView.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenWidth + _titleLabel.height + 55 );
        _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _heraderHeight + _titleLabel.height - 55 );

        _segmentView.frame = CGRectMake(30, _baseView.height-45, YGScreenWidth-60, 45);
        _scrollView.frame = CGRectMake(0, _baseView.height, YGScreenWidth, YGScreenHeight  - 45-YGBottomMargin - _segmentView.height-YGStatusBarHeight-YGNaviBarHeight);
        
        
        _isCollect =_serviceDetail[@"isCollect"];
        [self reloadDataWithisCollect:_isCollect];
        
        if (![self.pageType isEqualToString:@"IntegrationIndustryCommerceController"])
        {
            _naviTitleLabel.text = [NSString stringWithFormat:@"%@-%@",_serviceDetail[@"serviceName"],_serviceDetail[@"serviceIntroduction"]];
            [_naviTitleLabel sizeToFit];
            CGFloat w = _naviTitleLabel.width;
            if(w > YGScreenWidth - 160)
                w = YGScreenWidth - 160;
            _naviTitleLabel.frame = CGRectMake((YGScreenWidth - w)/2, 0, w, 20);
            [_fadeNavibar addSubview:_naviTitleLabel];
            _naviTitleLabel.centery = _backButton.centery;
        }
        
    } failure:nil];
}

#pragma mark ---- 配置UI
-(void)configUI
{
    
    
    /********************** 头视图两个按钮 *****************/
    _heraderHeight = YGScreenWidth+110;

    CGFloat  scrollviewH = YGScreenWidth;
    if(iphone5 )
    {
        _heraderHeight =  (YGScreenWidth * 3/4+110);
        scrollviewH = YGScreenWidth *3/4;
    }
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, _heraderHeight)];
    _baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_baseView];
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth, scrollviewH) delegate:self placeholderImage:YGDefaultImgSquare];
    _adScrollview.contentMode = UIViewContentModeScaleAspectFill;
    _adScrollview.clipsToBounds = YES;
    _adScrollview.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
    [_baseView addSubview:_adScrollview];
    
    if(iphone5)
    {
        _adScrollview.placeholderImage = YGDefaultImgFour_Three;
    }

    //热门推荐label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.text = @"";
    _titleLabel.numberOfLines = 0;
    _titleLabel.frame = CGRectMake(15, _adScrollview.height ,YGScreenWidth-30, 55);
    [_baseView addSubview:_titleLabel];
    
    /********************** 分割线 ********************/
    
    _seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.y+_titleLabel.height, YGScreenWidth, 10)];
    _seperateView.backgroundColor = colorWithTable;
    [_baseView addSubview:_seperateView];

    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"服务介绍",@"服务评价",@"交易记录"]];

    /********************** 选择器 ********************/
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(30, _baseView.height-45, YGScreenWidth-60, 45) titlesArray:_controllersArray lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    _segmentView.lineColor = colorWithMainColor;
    [_baseView addSubview:_segmentView];

    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _baseView.height, YGScreenWidth, YGScreenHeight  - 45-YGBottomMargin - _segmentView.height-YGStatusBarHeight-YGNaviBarHeight)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * _controllersArray.count, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    if (@available(iOS 11.0, *)) {
        _scrollView. contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //默认第0页
    [self segmentButtonClickWithIndex:0];
//
    /****************************** 按钮 **************************/
    for (int i = 0; i<2; i++)
    {
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2*i,YGScreenHeight-45-YGBottomMargin,YGScreenWidth/2,45+YGBottomMargin)];
//        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        coverButton.tag = 1000+i;
        [coverButton addTarget:self action:@selector(contanctWithCustomerServiceOrOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [self.view addSubview:coverButton];
        
        if (i == 0)
        {
            coverButton.backgroundColor = colorWithYGWhite;
            [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            [coverButton setTitle:@"联系客服" forState:UIControlStateNormal];
            [coverButton setImage:[UIImage imageNamed:@"service_black"] forState:UIControlStateNormal];
            [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            
        }else
        {
            coverButton.backgroundColor = colorWithMainColor;
            [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
            [coverButton setTitle:@"立即申请" forState:UIControlStateNormal];
        }
    }
    
    UILabel * line  = [[UILabel alloc]initWithFrame:CGRectMake(0,YGScreenHeight-45-YGBottomMargin,YGScreenWidth/2,1)];
    line.backgroundColor = colorWithLine;
    [self.view addSubview:line];

    
    //假navi导航
    _fadeNavibar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGNaviBarHeight+YGStatusBarHeight)];
    _fadeNavibar.backgroundColor = [colorWithYGWhite colorWithAlphaComponent:0.0];
    [self.view addSubview:_fadeNavibar];
    
    _navLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _fadeNavibar.height-1, YGScreenWidth, 1)];
    _navLineView.backgroundColor = [colorWithLine colorWithAlphaComponent:0.7];
    [_fadeNavibar addSubview:_navLineView];
    _navLineView.hidden = YES;

    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(10,YGStatusBarHeight,40,40)];
    _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fadeNavibar addSubview:_backButton];
    [_backButton setImage:[[UIImage imageNamed:@"back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

    
    _naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 150, 20)];
    _naviTitleLabel.textColor = colorWithBlack;
    _naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    if ([self.pageType isEqualToString:@"IntegrationIndustryCommerceController"])
    {
        _naviTitleLabel.text = @"小规模纳税人" ;
        [_naviTitleLabel sizeToFit];
        _naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-_naviTitleLabel.width/2, 0, _naviTitleLabel.width, 20);
        [_fadeNavibar addSubview:_naviTitleLabel];
        _naviTitleLabel.centery = _backButton.centery;

    }
    _naviTitleLabel.centery = _backButton.centery;
    _naviTitleLabel.hidden = YES;


    _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-50,YGStatusBarHeight,40,40)];
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fadeNavibar addSubview:_shareButton];
    
    [_shareButton setImage:[[UIImage imageNamed:@"share_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    _favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(_shareButton.x-45,_shareButton.y,40,40)];
    _favoriteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_favoriteButton addTarget:self action:@selector(favoriteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_fadeNavibar addSubview:_favoriteButton];
    [_favoriteButton setImage:[[UIImage imageNamed:@"collect_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

}

-(void)reloadDataWithisCollect:(NSString *)isCollect
{
    if(_naviTitleLabel.hidden)
    {
        if([isCollect isEqualToString:@"1"])
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        else
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    else
    {
        if([isCollect isEqualToString:@"1"])
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_green_finish"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        else
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }

}
#pragma mark ---- 改变当前Controller
-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [self loadControllerWithIndex:buttonIndex];
    
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _scrollView.contentOffset.y);
    }];
}

#pragma mark ---- 滑动切换Controller
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / YGScreenWidth;
    [self loadControllerWithIndex:index];
    [_segmentView selectButtonWithIndex:index];
}

#pragma mark ---- 加载Controller
-(void)loadControllerWithIndex:(int)index
{
    if (index == 0)
    {
        if (_netIntroduceViewController == nil) {
            _netIntroduceViewController = [[NetIntroduceViewController alloc]init];
            _netIntroduceViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            _netIntroduceViewController.netIntroduceViewControllerDelegate = self;
            _netIntroduceViewController.serviceID = self.serviceID;
            [self addChildViewController:_netIntroduceViewController];
            [_scrollView addSubview:_netIntroduceViewController.view];
        }
    }
    else if (index == 1)
    {
        if (_serviceEvaluationViewController == nil) {
            _serviceEvaluationViewController = [[ServiceEvaluationViewController alloc]init];
            _serviceEvaluationViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            _serviceEvaluationViewController.superVCType = @"netManager";
            _serviceEvaluationViewController.serviceID = self.serviceID;
            _serviceEvaluationViewController.serviceEvaluationViewControllerDelegate = self;
            [self addChildViewController:_serviceEvaluationViewController];
            [_scrollView addSubview:_serviceEvaluationViewController.view];
        }
        
    }else
    {
        if (_tradeRecordViewController == nil) {
            _tradeRecordViewController = [[TradeRecordViewController alloc]init];
            _tradeRecordViewController.controllerFrame = CGRectMake(YGScreenWidth * index,1, _scrollView.width, _scrollView.height);
            _tradeRecordViewController.superVCType = @"netManager";
            _tradeRecordViewController.serviceID = self.serviceID;
            _tradeRecordViewController.tradeRecordViewControllerDelegate = self;
            [self addChildViewController:_tradeRecordViewController];
            [_scrollView addSubview:_tradeRecordViewController.view];
        }
        
    }
}

#pragma mark ---- DiscoverySubViewController上拉滑动更新位置代理
- (void)scrollViewDidScrollWithHeight:(CGFloat)offset {
    
    CGFloat offsetY = offset;
    //控制导航渐变
    if (offsetY<0) {
        CGFloat alpha = 0;
        [_backButton setImage:[[UIImage imageNamed:@"back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_shareButton setImage:[[UIImage imageNamed:@"share_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        if([_isCollect isEqualToString:@"1"])
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        else
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

        _alpha = alpha;
        _naviTitleLabel.hidden = YES;
        _navLineView.hidden = YES;
        [self setStatusBarStyle:UIStatusBarStyleLightContent];
        _statusbarStayle = UIStatusBarStyleLightContent;
        
        
    }else if (offsetY>0 && offsetY<= 45)
    {
        CGFloat alpha = 1;
        [_backButton setImage:[[UIImage imageNamed:@"back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_shareButton setImage:[[UIImage imageNamed:@"share_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        if([_isCollect isEqualToString:@"1"])
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_green_finish"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        else
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        
        _alpha = alpha;
        _naviTitleLabel.hidden = NO;
        _navLineView.hidden = NO;
        [self setStatusBarStyle:UIStatusBarStyleDefault];
        _statusbarStayle = UIStatusBarStyleDefault;

    }
    else if (offsetY>=45)
    {
        CGFloat alpha = 1;
        [_backButton setImage:[[UIImage imageNamed:@"back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_shareButton setImage:[[UIImage imageNamed:@"share_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        if([_isCollect isEqualToString:@"1"])
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_green_finish"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        else
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        _alpha = alpha;
        _naviTitleLabel.hidden = NO;
        _navLineView.hidden = NO;

       
            [self setStatusBarStyle:UIStatusBarStyleDefault];
            _statusbarStayle = UIStatusBarStyleDefault;
        
    }
    
    _fadeNavibar.backgroundColor  = [colorWithYGWhite colorWithAlphaComponent:_alpha];
    
    //segment
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGFloat height = _baseView.height;//偏移量
        if (offset > 0)//向下拉是负值，向上是正
        {
            _baseView.y = - height + _segmentView.height+YGStatusBarHeight+YGNaviBarHeight;
        }
        else if(offset < 0)
        {
            _baseView.y = 0;
            
        }
        _scrollView.y = CGRectGetMaxY(_baseView.frame);
        
    } completion:nil];
    
}

#pragma mark ---- 按钮点击

- (void)contanctWithCustomerServiceOrOrderAction:(UIButton *)btn
{
    if (btn.tag == 1000)
    {//联系客服
        [self contactWithCustomerServerWithType:ContactServerNetManager button:btn];
    }else{//立即申请
        
        LDApplyVC * applyVC = [[LDApplyVC alloc] init];
        applyVC.serviceDetail = _serviceDetail;
        applyVC.serviceID = self.serviceID;
        [self.navigationController pushViewController:applyVC animated:YES];
        
    }
}
//分享按钮
- (void)shareButtonAction:(UIButton *)btn
{
    NSString * imagUrl =@"";
    if([_serviceDetail[@"serviceImg"] count])
    {
        imagUrl = _serviceDetail[@"serviceImg"][0];
    }
    [YGAppTool shareWithShareUrl:_url shareTitle:_titleLabel.text shareDetail:@"" shareImageUrl:imagUrl shareController:self];

}
//收藏
- (void)favoriteButtonAction:(UIButton *)btn
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"userID"] = YGSingletonMarco.user.userId;
    dict[@"serviceID"] = self.serviceID;
    
    [YGNetService YGPOST:@"NetServiceCollect" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        if([_isCollect isEqualToString:@"0"])
        {
            _isCollect =@"1";
            [self reloadDataWithisCollect:@"1"];
            [YGAppTool showToastWithText:@"收藏成功"];
        }
        else
        {
            _isCollect =@"0";
            [self reloadDataWithisCollect:@"0"];
            [YGAppTool showToastWithText:@"取消收藏"];
        }
        
    } failure:^(NSError *error) {
        [YGAppTool showToastWithText:@"操作失败"];
    }];
}
- (void)backButtonAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
