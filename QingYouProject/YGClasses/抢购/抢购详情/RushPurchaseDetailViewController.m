//
//  RushPurchaseDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/6.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseDetailViewController.h"
#import "RushPurchaseDetailPopView.h"
#import "RushPurchaseSureOrderDetailViewController.h"
#import "RushPurchaseProductModel.h"
#import "RushPurchaseCommodityModel.h"
#import <WebKit/WebKit.h>
#import "RushPurchaseOrderListModel.h"

@interface RushPurchaseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,RushPurchaseDetailPopViewDelegate,WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)WKWebView *webView;

@end

@implementation RushPurchaseDetailViewController
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    UIView *_baseView;
    UILabel *_titleLabel;
    SDCycleScrollView *_adScrollview; //广告轮播
    UILabel *_newPriceLabel;
    UILabel  *_oldPriceLabel;
    RushPurchaseProductModel *_model;
    NSMutableArray *_labelList;
    UIScrollView *_scrollView;
    UILabel *_selectedLabel;
    NSString *_commoditySizeId;
    NSString *_commoditySizeSum;
    UIButton *_favoriteButton;
    
    
    NSInteger secondsCountDown;
    NSTimer *_countDownTimer;
    UILabel *_timeLabel;
    CGFloat   _timeWidth;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //当前视图控制器在栈中，故为push操作
        NSLog(@"push");
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        //当前视图控制器不在栈中，故为pop操作
        NSLog(@"pop");
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];

    }
}


- (void)configAttribute
{
//    self.naviTitle = @"商品详情";

    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 120, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"商品详情" ;
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    
    
    _listArray = [[NSMutableArray alloc] init];
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-55,20,40,40)];
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateSelected];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    
    _favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,20,40,40)];
    [_favoriteButton setImage:[UIImage imageNamed:@"collect_icon_black"] forState:UIControlStateNormal];
    [_favoriteButton setImage:[UIImage imageNamed:@"collect_icon_green_finish"] forState:UIControlStateSelected];
    _favoriteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [_favoriteButton addTarget:self action:@selector(favoriteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favoriteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_favoriteButton];
    
    self.navigationItem.rightBarButtonItems =@[shareButtonItem,favoriteButtonItem];
    _model = [[RushPurchaseProductModel alloc] init];
    _labelList = [[NSMutableArray alloc] init];
}
- (void)configUI
{
    _commoditySizeId = _model.falshSaleSizeId;
    _commoditySizeSum = @"1";
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)];
    _scrollView.backgroundColor = colorWithTable;
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, YGScreenHeight);
    [self.view addSubview:_scrollView];
    
    //********************** 头视图两个按钮 *****************
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2)];
    _baseView.backgroundColor = colorWithYGWhite;
    [_scrollView addSubview:_baseView];
    
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2) delegate:self placeholderImage:YGDefaultImgTwo_One];
    _adScrollview.imageURLStringsGroup = _model.img;
    _adScrollview.contentMode = UIViewContentModeScaleAspectFill;
    _adScrollview.clipsToBounds = YES;
    _adScrollview.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
    _adScrollview.delegate = self;
    [_baseView addSubview:_adScrollview];
    
    UIView  *pricebaseView = [[UIView alloc] initWithFrame:CGRectMake(0, _adScrollview.height, YGScreenWidth*0.40, 50)];
    pricebaseView.backgroundColor = colorWithMainColor;
    [_baseView addSubview:pricebaseView];
    
    //时间label
    _newPriceLabel = [[UILabel alloc]init];
    _newPriceLabel.frame = CGRectMake(15,5 , 100, 20);
    _newPriceLabel.textColor = colorWithYGWhite;
    _newPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeBigThree];
    _newPriceLabel.text = [NSString stringWithFormat:@"¥%@",_model.newprice];
    [pricebaseView addSubview:_newPriceLabel];
    
    //热门推荐label
    _oldPriceLabel = [[UILabel alloc]init];
    _oldPriceLabel.frame = CGRectMake(_newPriceLabel.x,_newPriceLabel.height +_newPriceLabel.y, 100, 20);
    _oldPriceLabel.textColor = colorWithYGWhite;
    _oldPriceLabel.text =[NSString stringWithFormat:@"¥%@",_model.oldPrice];
    _oldPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_oldPriceLabel sizeToFit];
    _oldPriceLabel.frame = CGRectMake(_oldPriceLabel.x,_oldPriceLabel.y , _oldPriceLabel.width, 20);
    [pricebaseView addSubview:_oldPriceLabel];
    
    UIView *oldLineView = [[UIView alloc] initWithFrame:CGRectMake(_oldPriceLabel.x,_oldPriceLabel.y, _oldPriceLabel.width+5, 1)];
    oldLineView.backgroundColor = colorWithYGWhite;
    oldLineView.centery = _oldPriceLabel.centery;
    [pricebaseView addSubview:oldLineView];
    

    UIView  *timebaseView = [[UIView alloc] initWithFrame:CGRectMake(pricebaseView.width, _adScrollview.height, YGScreenWidth-pricebaseView.width, 50)];
    timebaseView.backgroundColor = colorWithTable;
    timebaseView.tag = 100000;
    [_baseView addSubview:timebaseView];
    
    
    //热门推荐label
    UILabel *stateLabel = [[UILabel alloc]init];
    stateLabel.frame = CGRectMake(timebaseView.width-100, 5,100, 25);
    stateLabel.textColor = colorWithYGWhite;
    stateLabel.backgroundColor = colorWithMainColor;
    stateLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    stateLabel.text = _model.prompting;
    [stateLabel sizeToFit];
    stateLabel.layer.cornerRadius = 5;
    stateLabel.clipsToBounds = YES;
    stateLabel.frame = CGRectMake(timebaseView.width-stateLabel.width-20, 5,stateLabel.width+10, stateLabel.height+5);
    stateLabel.textAlignment = NSTextAlignmentCenter;
    [timebaseView addSubview:stateLabel];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    unsigned int unitFlags = NSCalendarUnitDay;
//    unsigned int unitFlagHH = NSCalendarUnitHour;
//    unsigned int unitFlagmm = NSCalendarUnitMinute;
//    unsigned int unitFlagss = NSCalendarUnitSecond;
//
//    NSDate *start = [dateFormatter dateFromString:_model.startDate];
//    NSDate *end = [dateFormatter dateFromString:_model.endDate];
//
//    NSDateComponents *comps = [gregorian components:unitFlags fromDate:end  toDate:start options:0];
//    NSDateComponents *compHH = [gregorian components:unitFlagHH fromDate:end  toDate:start options:0];
//    NSDateComponents *compmm = [gregorian components:unitFlagmm fromDate:end  toDate:start options:0];
//    NSDateComponents *compss = [gregorian components:unitFlagss fromDate:end  toDate:start options:0];
//
//    NSString *time = [NSString stringWithFormat:@"%ld %ld:%ld:%ld",[comps day] ,[compHH hour],[compmm minute],[compss second]];
        NSString *time = [YGAppTool dateTimeDifferenceWithStartTime:_model.startDate endTime:_model.endDate];
//    NSString *time = [YGAppTool dateTimeDifferenceWithStartTime:_model.endDate endTime:_model.startDate];

    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];

    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:_model.startDate];
    NSDate *endD = [date dateFromString:_model.endDate];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    secondsCountDown = round(value);
    
    [_countDownTimer setFireDate:[NSDate distantPast]];
    
    
    //热门推荐label
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.frame = CGRectMake(15, timebaseView.height-22,YGScreenWidth/2, 22);
    _timeLabel.textColor = colorWithMainColor;
    _timeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    if ([_model.type isEqualToString:@"0"]) {
        _timeLabel.text = [NSString stringWithFormat:@"距离开抢：%@",time];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"距离结束：%@",time];
    }
    [_timeLabel sizeToFit];
    _timeWidth = _timeLabel.width+2;
    _timeLabel.frame = CGRectMake(timebaseView.width-_timeLabel.width-12, timebaseView.height-_timeLabel.height-6,_timeLabel.width+2, _timeLabel.height+7);
    [timebaseView addSubview:_timeLabel];
    if([_model.reminding isEqualToString:@"2"]) //已抢光
    {
        _timeLabel.textColor = colorWithDeepGray;
        
    }
    
    
    //热门推荐label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.frame = CGRectMake(15, pricebaseView.height+pricebaseView.y+5,YGScreenWidth-30, 35);
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    _titleLabel.text = _model.name;
    _titleLabel.numberOfLines = 0;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(_titleLabel.x, _titleLabel.y,YGScreenWidth-30,_titleLabel.height+15);
    [_baseView addSubview:_titleLabel];
    
    UIView  *ensurebaseView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.y+_titleLabel.height, YGScreenWidth, 40)];
    [_baseView addSubview:ensurebaseView];
    
    UIView *ensureLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0,YGScreenWidth-10, 1)];
    ensureLineView.backgroundColor = colorWithLine;
    [ensurebaseView addSubview:ensureLineView];
    
    int k = 0;
    CGFloat widthCount = 0.0f;
    int j = 0;
    for (int i = 0;i<_model.lable.count;i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_model.lable[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        [button.titleLabel sizeToFit];
        [button setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 100+i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        label.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        label.text = _model.lable[i];
        [label sizeToFit];
        
        CGFloat labeWidth = label.width+10;
        button.frame = CGRectMake(10+widthCount+k*10, 10+30*j, labeWidth, 30) ;
        
        widthCount = widthCount +labeWidth;
        
        if (widthCount>(YGScreenWidth-20-k*10)) {
            j=j+1;
            k=0;
            widthCount = 0.0f;
            button.frame = CGRectMake(10+widthCount+k*10, 10+30*j, labeWidth, 30);
            widthCount = widthCount +labeWidth;
        }
        
        if (i != _model.lable.count-1) {
            UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(button.x+button.width+5, 5, 3, 3)];
            circleView.layer.cornerRadius= 2.5;
            circleView.clipsToBounds = YES;
            circleView.backgroundColor = colorWithMainColor;
            [ensurebaseView addSubview:circleView];
            circleView.centery = button.centery;
        }
        
        k++;
        
        [ensurebaseView addSubview:button];
        
    }
    ensurebaseView.frame = CGRectMake(0, ensurebaseView.y, ensurebaseView.width, 15+(j+1)*30);
    
    
    
    UIView  *limitbaseView = [[UIView alloc] initWithFrame:CGRectMake(0, ensurebaseView.y+ensurebaseView.height, YGScreenWidth, 45)];
    [_baseView addSubview:limitbaseView];
    
    UIView *limitLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0,YGScreenWidth-10, 1)];
    limitLineView.backgroundColor = colorWithLine;
    [limitbaseView addSubview:limitLineView];
    
    //热门推荐label
    UILabel *limitLabel = [[UILabel alloc]init];
    limitLabel.frame = CGRectMake(10, limitbaseView.height-35,YGScreenWidth/2, limitbaseView.height);
    limitLabel.textColor = colorWithBlack;
    limitLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    limitLabel.text = [NSString stringWithFormat:@"*限量%@件",_model.falshSaleSizesSum] ;
    [limitLabel sizeToFit];
    limitLabel.frame = CGRectMake(10, 0,limitLabel.width, limitbaseView.height);
    [limitbaseView addSubview:limitLabel];
    
    
    UIView  *selectedbaseView = [[UIView alloc] initWithFrame:CGRectMake(0, limitbaseView.y+limitbaseView.height, YGScreenWidth, 45)];
    [_baseView addSubview:selectedbaseView];
    
    UIView *selectedLineView = [[UIView alloc] initWithFrame:CGRectMake(10, 0,YGScreenWidth-10, 1)];
    selectedLineView.backgroundColor = colorWithLine;
    [selectedbaseView addSubview:selectedLineView];
    
    
    //热门推荐label
    UILabel *selectedTitleLabel = [[UILabel alloc]init];
    selectedTitleLabel.frame = CGRectMake(10, 0,60, selectedbaseView.height);
    selectedTitleLabel.textColor = colorWithDeepGray;
    selectedTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    selectedTitleLabel.text = @"已选";
    [selectedbaseView addSubview:selectedTitleLabel];
    
    //热门推荐label
    _selectedLabel = [[UILabel alloc]init];
    _selectedLabel.frame = CGRectMake(selectedTitleLabel.x+selectedTitleLabel.width,0 ,YGScreenWidth-(selectedTitleLabel.x+selectedTitleLabel.width)-10, selectedbaseView.height);
    _selectedLabel.textColor = colorWithBlack;
    _selectedLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _selectedLabel.text = _model.falshSaleSizeName;
    [_selectedLabel sizeToFit];
    _selectedLabel.frame = CGRectMake(_selectedLabel.x, 0,selectedbaseView.width, selectedbaseView.height);
    [selectedbaseView addSubview:_selectedLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.frame = CGRectMake(YGScreenWidth-27, 0, 17, 17);
    arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
    [arrowImageView sizeToFit];
    [selectedbaseView addSubview:arrowImageView];
    arrowImageView.centery = selectedTitleLabel.centery;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(selectCommodity) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, YGScreenWidth, selectedbaseView.height);
    [selectedbaseView addSubview:button];
    
    
    UIView *inviteBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, selectedbaseView.y+selectedbaseView.height, YGScreenWidth, 60)];
    inviteBaseView.backgroundColor = colorWithTable;
    [_baseView addSubview:inviteBaseView];
    
    UIView *inviteView = [[UIView alloc] initWithFrame:CGRectMake(0, 7,YGScreenWidth, 45)];
    inviteView.backgroundColor = colorWithYGWhite;
    [inviteBaseView addSubview:inviteView];
    
    //热门推荐label
    UILabel *inviteTitleLabel = [[UILabel alloc]init];
    inviteTitleLabel.frame = CGRectMake(10, 0,70, 45);
    inviteTitleLabel.textColor = colorWithBlack;
    inviteTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    inviteTitleLabel.text = @"邀请码";
    [inviteView addSubview:inviteTitleLabel];
    
    //热门推荐label
    UILabel *inviteContentLabel = [[UILabel alloc]init];
    inviteContentLabel.frame = CGRectMake(YGScreenWidth-120, 0,110, 45);
    inviteContentLabel.textColor = colorWithBlack;
    inviteContentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    inviteContentLabel.text = YGSingletonMarco.user.code;
    inviteContentLabel.textAlignment = NSTextAlignmentRight;
    [inviteView addSubview:inviteContentLabel];
    
    
    
    UIView *progressBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, inviteBaseView.y+inviteBaseView.height, YGScreenWidth, 45)];
    progressBaseView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:progressBaseView];

    
    //热门推荐label
    UILabel *contenttionLabel = [[UILabel alloc]init];
    contenttionLabel.frame = CGRectMake(10,0, YGScreenWidth-20, 45);
    contenttionLabel.textColor = colorWithBlack;
    contenttionLabel.text = @"商品详情";
    contenttionLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [progressBaseView addSubview:contenttionLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44,YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [progressBaseView addSubview:lineView];

    _baseView.frame = CGRectMake(0,0, YGScreenWidth, progressBaseView.y+progressBaseView.height+10);
    
    
    /****************************** 按钮 **************************/
    UIView *bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin, YGScreenWidth, 45+YGBottomMargin)];
    bottomView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:bottomView];
    
    for (int i = 0; i<2; i++)
    {
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2*i,0,YGScreenWidth/2,45+YGBottomMargin)];
        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
        coverButton.tag = 1000+i;
        [coverButton addTarget:self action:@selector(contanctWithCustomerServiceOrOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [bottomView addSubview:coverButton];
        
        if (i == 0)
        {
            coverButton.backgroundColor = colorWithYGWhite;
            [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
            [coverButton setTitle:@"联系客服" forState:UIControlStateNormal];
            [coverButton setImage:[UIImage imageNamed:@"service_black"] forState:UIControlStateNormal];
            [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 5, 0, 0)];
            [coverButton setImageEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0)];
        }else
        {
            coverButton.backgroundColor = colorWithMainColor;
            [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
            if ([_model.type isEqualToString:@"0"]) {
                if ([_model.reminding isEqualToString:@"0"]) {
                    [coverButton setTitle:@"提醒我" forState:UIControlStateNormal];
                    coverButton.selected = NO;
                }else
                {
                    [coverButton setTitle:@"提前3分钟提醒" forState:UIControlStateNormal];
                    coverButton.selected = YES;
                }
            }else if([_model.type isEqualToString:@"2"]) //已抢光
            {
                [coverButton setTitle:@"立即抢购" forState:UIControlStateNormal];
                coverButton.backgroundColor = colorWithLightGray;
                coverButton.userInteractionEnabled = NO;
            }else //一开始抢购
            {
                [coverButton setTitle:@"立即抢购" forState:UIControlStateNormal];
            }
        }
    }
    UIView *bottomLineView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth,0.7)];
    bottomLineView.backgroundColor = colorWithLine;
    [bottomView addSubview:bottomLineView];
    
    
    //以下代码适配大小
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, _baseView.height, YGScreenWidth, 100) configuration:wkWebConfig];
    [_scrollView addSubview:self.webView];
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
                                   "</html>",_model.description
                                   ] baseURL:nil];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth, _baseView.y+_baseView.height +_webView.height);
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    
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
//    // 禁止放大缩小
//    NSString *injectionJSString = @"var script = document.createElement('meta');"
//    "script.name = 'viewport';"
//    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
//
//    __block CGFloat webViewHeight;
//
//    //document.body.scrollHeight
//    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
//    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
//        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以(@"document.getElementById(\"content\").offsetHeight;")，但如果是和我一样直接加载原站内容使用前者更合适
//        //获取页面高度，并重置webview的frame
//        webViewHeight = [result doubleValue];
//        webView.height = webViewHeight;
//        self.webView.frame = CGRectMake(10, _baseView.y+_baseView.height, YGScreenWidth - 20, webView.height);
//        _scrollView.contentSize = CGSizeMake(YGScreenWidth, _baseView.y+_baseView.height +webView.height+20);
//        NSLog(@"%f",webViewHeight);
//    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
//        dispatch_async(dispatch_get_global_queue(0,0), ^{
            //document.documentElement.scrollHeight
            // 禁止放大缩小
//            NSString *injectionJSString = @"var script = document.createElement('meta');"
//            "script.name = 'viewport';"
//            "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
//            "document.getElementsByTagName('head')[0].appendChild(script);";
//            [self.webView evaluateJavaScript:injectionJSString completionHandler:nil];
//
            __block CGFloat webViewHeight;
            
            //document.body.scrollHeight
            //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
            [self.webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
                // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以(@"document.getElementById(\"content\").offsetHeight;")，但如果是和我一样直接加载原站内容使用前者更合适
                //获取页面高度，并重置webview的frame
                webViewHeight = [result doubleValue];
                self.webView.height = webViewHeight;
                self.webView.frame = CGRectMake(10, _baseView.y+_baseView.height, YGScreenWidth - 20, self.webView.height);
                _scrollView.contentSize = CGSizeMake(YGScreenWidth, _baseView.y+_baseView.height +self.webView.height+20);
                NSLog(@"%f",webViewHeight);
            }];
//        });
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}


- (void)loadData
{
    [YGNetService YGPOST:REQUEST_getFalshsaleCommodity parameters:@{@"usmUserId":YGSingletonMarco.user.userId,@"commodityId":self.itemId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        [_model setValuesForKeysWithDictionary:responseObject];
        _favoriteButton.selected = [_model.collection boolValue];
        [YGNetService YGPOST:REQUEST_falshsaleCommoditySize parameters:@{@"commodityId":self.itemId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
          _labelList =   [RushPurchaseCommodityModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            _commoditySizeId = _model.falshSaleSizeId;
            [self configUI];
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        [self back];
    }];
   
}

#pragma mark ====下单练习
- (void)contanctWithCustomerServiceOrOrderAction:(UIButton *)btn
{
    btn.userInteractionEnabled = NO;
    if(btn.tag ==1000)
    {
        btn.userInteractionEnabled = YES;
        [self contactWithCustomerServerWithType:ContactServerRushPurchase button:btn];
    }
    else
    {
        
        if(![self loginOrNot])
            return;
        if ([_model.type isEqualToString:@"0"])
        {
            
            // 收藏与取消收藏
            [YGNetService YGPOST:REQUEST_falshsaleReminding parameters:@{@"commodityId":_itemId,@"usmUserId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                btn.userInteractionEnabled = YES;
                btn.selected = !btn.selected;
                [btn setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
                btn.backgroundColor = colorWithMainColor;
                if (btn.selected == YES) {
                    [YGAppTool showToastWithText:@"系统会提前3分钟提醒您哦~"];
                    [btn setTitle:@"提前3分钟提醒" forState:UIControlStateNormal];
                }else
                {
                    [YGAppTool showToastWithText:@"系统将不会提醒您了哦~"];
                    [btn setTitle:@"提醒我" forState:UIControlStateNormal];

                }
                
            } failure:^(NSError *error) {
                btn.userInteractionEnabled = YES;

            }];
            
        }
        if ([_model.type isEqualToString:@"1"])
        {
            [YGNetService YGPOST:REQUEST_createFalshsaleOrder parameters:@{@"commoditySizeId":_commoditySizeId,@"usmUserId":YGSingletonMarco.user.userId,@"commoditySizeSum":_commoditySizeSum} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                RushPurchaseOrderListModel *model = [[RushPurchaseOrderListModel alloc] init];
                [model setValuesForKeysWithDictionary:responseObject];
                RushPurchaseSureOrderDetailViewController * sureOrderView = [[RushPurchaseSureOrderDetailViewController alloc]init];
                sureOrderView.model = model;
                [self.navigationController pushViewController:sureOrderView animated:YES];
                btn.userInteractionEnabled = YES;

            } failure:^(NSError *error) {
                btn.userInteractionEnabled = YES;
            }];
        }
    }
}

- (void)chooseGoodsWithCategoriesViewSurePaywithCommoditySizeId:(NSString *)commoditySizeId andCommoditySizeSum:(NSString *)commoditySizeSum andRushPurchaseCommodityModel:(RushPurchaseCommodityModel *)commodityModel
{
    _commoditySizeId = commoditySizeId;
    _commoditySizeSum = commoditySizeSum;
    for (int  i = 0; i<_labelList.count; i++) {
        RushPurchaseCommodityModel *model = _labelList[i];
        model.number = @"1";
        if ([model.id isEqualToString:commoditySizeId]) {
            _selectedLabel.text = model.name;
            model.number = commodityModel.number;
            break;
        }
    }
}

- (void)selectCommodity
{
    NSMutableArray * array =[[NSMutableArray alloc]init];
    
    for(int i=0;i<_labelList.count;i++)
    {
        RushPurchaseCommodityModel * model =_labelList[i];
        [array addObject:model.name];
        model.select = NO;
        if ([model.id isEqualToString:_commoditySizeId]) {
            model.select = YES;
        }else
        {
            model.number = @"1";
        }

    }
    RushPurchaseDetailPopView  * chooseview = [[RushPurchaseDetailPopView alloc]init];
    chooseview.labelList = _labelList;
    chooseview.delegate =self;
    chooseview.dataSource = array;
    [chooseview createFrame:CGRectMake(0, YGScreenHeight-(190+YGBottomMargin+100), YGScreenWidth, 190+YGBottomMargin+100) withInfoNSArry:array];
    [self.navigationController.view addSubview:chooseview];

}
//分享按钮
- (void)shareButtonAction:(UIButton *)btn
{
    [YGAppTool shareWithShareUrl:_model.share shareTitle:_model.name shareDetail:@"" shareImageUrl:_model.coverUrl shareController:self];
}
//收藏
- (void)favoriteButtonAction:(UIButton *)btn
{
    // 收藏与取消收藏
    [YGNetService YGPOST:REQUEST_falshsaleCollect parameters:@{@"commodityId":_itemId,@"usmUserId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        btn.selected = !btn.isSelected;
        
    } failure:^(NSError *error) {
        
    }];
}


-(void) countDownAction{
    //倒计时-1
    secondsCountDown--;
    
    int seconds = (int)secondsCountDown % 60;
    int minutes = (int)(secondsCountDown / 60) % 60;
    int hours = (int)secondsCountDown / 3600;
    //    int d = (int)value/1000/60/60/24;
    int d = hours/24;
    
    hours = hours-24*d;
    if (d == 0) {
        if ([_model.type isEqualToString:@"0"]) {
            _timeLabel.text = [NSString stringWithFormat:@"距离开抢：%@",[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds]];
        }else{
            _timeLabel.text = [NSString stringWithFormat:@"距离结束：%@",[NSString stringWithFormat:@"%02d天  %02d:%02d:%02d",d,hours, minutes, seconds]];
        }
        
    }else
    {
        if ([_model.type isEqualToString:@"0"]) {
            _timeLabel.text = [NSString stringWithFormat:@"距离开抢：%@",[NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds]];
        }else{
            _timeLabel.text = [NSString stringWithFormat:@"距离结束：%@",[NSString stringWithFormat:@"%02d天  %02d:%02d:%02d",d,hours, minutes, seconds]];
        }
    }
    
    UIView *timebaseView = [_baseView viewWithTag:100000];
    
    [_timeLabel sizeToFit];
    _timeLabel.frame = CGRectMake(timebaseView.width-_timeLabel.width-10, timebaseView.height-_timeLabel.height-5,_timeLabel.width, _timeLabel.height+7);
    
    
    //    NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];
    //    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
    //    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    //    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    NSLog(@"%ld",secondsCountDown);
    //修改倒计时标签现实内容
    //    [_timeLabel addAttributedWithString:[NSString stringWithFormat:@"剩余支付时间 %@",format_time] range:NSMakeRange(6, format_time.length) color:[UIColor redColor]];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [_countDownTimer invalidate];
    }
    
    
    


}

@end
