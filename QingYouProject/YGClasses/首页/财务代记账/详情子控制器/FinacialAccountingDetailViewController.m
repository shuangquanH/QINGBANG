//
//  FinacialAccountingDetailViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "FinacialAccountingDetailViewController.h"
#import "YGSegmentView.h"
#define heraderHeight           (YGScreenWidth/2+115)

#import "ServiceIntroduceViewController.h"
#import "ServiceEvaluationViewController.h"
#import "TradeRecordViewController.h"
//#import "NetIntroduceViewController.h"
#import "FinacialAccountPopView.h"

#import "BuyOrderViewController.h"
#import "ShopItemModel.h"
//#import "NetManagerVC.h"

@interface FinacialAccountingDetailViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,YGSegmentViewDelegate,ServiceIntroduceViewControllerDelegate,ServiceEvaluationViewControllerDelegate,TradeRecordViewControllerDelegate,FinacialAccountPopViewDelegate>
{
    NSMutableArray * _controllersArray;//Controller数组
    YGSegmentView * _segmentView;//选择器
    UIScrollView * _scrollView;
    ServiceIntroduceViewController * _serviceIntroduceViewController;
    ServiceEvaluationViewController * _serviceEvaluationViewController;
    TradeRecordViewController * _tradeRecordViewController;
    
    FinacialAccountPopView *_inputInfoView;
    FinacialAccountPopView *_chooseTypeView;
    UIButton *_favoriteButton;
    NSString *_isCollect;
    NSArray * _imgList;
}

@end

@implementation FinacialAccountingDetailViewController
{
    SDCycleScrollView *_adScrollview; //广告轮播
    UIView          *_baseView;
    UILabel *_titleLabel;
    UILabel *_newPriceLabel;
    UILabel  *_oldPriceLabel;
    NSDictionary * _commerceDetailDict;
    NSArray *_labelList;
    
    NSDictionary * _categoryDict;

    NSString * _url;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configAttribute];
//    [self configUI];
    [self sendRequest];
}

#pragma mark ---- 重写导航条
- (void)configAttribute
{
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
//    shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setImage:[UIImage imageNamed:@"share_black"] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];

     _favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
//    _favoriteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [_favoriteButton addTarget:self action:@selector(favoriteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _favoriteButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    UIBarButtonItem *favoriteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_favoriteButton];
    [_favoriteButton setImage:[UIImage imageNamed:@"collect_icon_black"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems =@[shareButtonItem,favoriteButtonItem];
}

#pragma mark ---- 配置UI
-(void)configUI
{
    /********************** 头视图两个按钮 *****************/
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    _baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_baseView];
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth-0, YGScreenWidth/2) delegate:self placeholderImage:YGDefaultImgTwo_One];
    _adScrollview.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
    [_baseView addSubview:_adScrollview];
    if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
        _adScrollview.imageURLStringsGroup =_commerceDetailDict[@"financeImg"];
    else
        _adScrollview.imageURLStringsGroup =_commerceDetailDict[@"commerceImg"];
    
    //热门推荐label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _titleLabel.text = _commerceDetailDict[@"commerceIntroduction"];
    if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
        _titleLabel.text = _commerceDetailDict[@"financeIntroduction"];

    _titleLabel.frame = CGRectMake(15, _adScrollview.height,YGScreenWidth-30, 35);
    [_baseView addSubview:_titleLabel];
    
    //时间label
    _newPriceLabel = [[UILabel alloc]init];
    _newPriceLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height , 100, 20);
    _newPriceLabel.textColor = colorWithOrangeColor;
    _newPriceLabel.text = [NSString stringWithFormat:@"¥%@",_commerceDetailDict[@"ourPrice"]];

    _newPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeBigThree];
    _newPriceLabel.numberOfLines = 0;
    [_newPriceLabel sizeToFit];
    _newPriceLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height , _newPriceLabel.width, 20);
    [_baseView addSubview:_newPriceLabel];
    
    //热门推荐label
    _oldPriceLabel = [[UILabel alloc]init];
    _oldPriceLabel.frame = CGRectMake(_newPriceLabel.x+_newPriceLabel.width+10,_newPriceLabel.y+3, 100, 15);
    _oldPriceLabel.textColor = colorWithPlaceholder;
    _oldPriceLabel.text =_commerceDetailDict[@"otherPrice"];
    _oldPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    [_oldPriceLabel sizeToFit];
    _oldPriceLabel.frame = CGRectMake(_newPriceLabel.x+_newPriceLabel.width+10,_newPriceLabel.y+4, _oldPriceLabel.width, 15);
    [_baseView addSubview:_oldPriceLabel];
    
    UIView *oldLineView = [[UIView alloc] initWithFrame:CGRectMake(_newPriceLabel.x+_newPriceLabel.width+5,_newPriceLabel.y+4, _oldPriceLabel.width+10, 1)];
    oldLineView.backgroundColor = colorWithPlaceholder;
    oldLineView.centery = _oldPriceLabel.centery;
    [_baseView addSubview:oldLineView];
    
    /********************** 分割线 ********************/
    
    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, _newPriceLabel.y+_newPriceLabel.height+5, YGScreenWidth, 10)];
    seperateView.backgroundColor = colorWithTable;
    [_baseView addSubview:seperateView];

    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"服务介绍",@"服务评价",@"交易记录"]];
    
    /********************** 选择器 ********************/
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(30, _baseView.height-40, YGScreenWidth-60, 40) titlesArray:_controllersArray lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:_segmentView];
    
    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _baseView.height, YGScreenWidth, YGScreenHeight - 64 - 45-YGBottomMargin - _segmentView.height)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * _controllersArray.count, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //默认第0页
    [self segmentButtonClickWithIndex:0];
    
    /****************************** 按钮 **************************/
    for (int i = 0; i<2; i++)
    {
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2*i,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth/2,45+YGBottomMargin)];
        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
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
            [coverButton setImage:[UIImage imageNamed:@"decorate_nav_icon"] forState:UIControlStateNormal];
            [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 5, 0, 0)];
            [coverButton setImageEdgeInsets:UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0)];
        }else
        {
            coverButton.backgroundColor = colorWithMainColor;
            [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
            [coverButton setTitle:@"立即下单" forState:UIControlStateNormal];
        }
    }
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,1)];
    line.backgroundColor = colorWithLine;
    [self.view addSubview:line];
    
   
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
        if (_serviceIntroduceViewController == nil) {
            _serviceIntroduceViewController = [[ServiceIntroduceViewController alloc]init];  
            _serviceIntroduceViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            _serviceIntroduceViewController.commerceID = self.cellWithID; _serviceIntroduceViewController.serviceIntroduceViewControllerDelegate = self;
            _serviceIntroduceViewController.superVCType = self.pageType;
            _serviceIntroduceViewController.serviceArray =_imgList;
            [self addChildViewController:_serviceIntroduceViewController];
            [_scrollView addSubview:_serviceIntroduceViewController.view];

        }
    }
    else if (index == 1)
    {
        if (_serviceEvaluationViewController == nil) {
            _serviceEvaluationViewController = [[ServiceEvaluationViewController alloc]init];
            _serviceEvaluationViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
           _serviceEvaluationViewController.serviceID = self.cellWithID;
            _serviceEvaluationViewController.serviceEvaluationViewControllerDelegate = self;
            _serviceEvaluationViewController.superVCType = self.pageType;

            [self addChildViewController:_serviceEvaluationViewController];
            [_scrollView addSubview:_serviceEvaluationViewController.view];

        }

    }else
    {
        if (_tradeRecordViewController == nil) {
            _tradeRecordViewController = [[TradeRecordViewController alloc]init];
            _tradeRecordViewController.controllerFrame = CGRectMake(YGScreenWidth * index,1, _scrollView.width, _scrollView.height);
            _tradeRecordViewController.superVCType = self.pageType;
            _tradeRecordViewController.serviceID = self.cellWithID;

            _tradeRecordViewController.tradeRecordViewControllerDelegate = self;
            [self addChildViewController:_tradeRecordViewController];
            [_scrollView addSubview:_tradeRecordViewController.view];

        }

    }
}
-(void)serviceIntroduceViewControllerSelectBtnClick:(UIButton *)btn
{
    NSInteger tag = btn.tag -100;
    switch (tag) {
        case 0:
        {
            FinacialAccountingDetailViewController *vc = [[FinacialAccountingDetailViewController alloc]init];
            vc.pageType = @"IntegrationIndustryCommerceController";
            vc.hidesBottomBarWhenPushed = YES;
            vc.cellWithID = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            FinacialAccountingDetailViewController *vc = [[FinacialAccountingDetailViewController alloc]init];
            vc.pageType = @"IntegrationIndustryCommerceController";
            vc.hidesBottomBarWhenPushed = YES;
            vc.cellWithID = @"2";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//        case 2:
//        {
//            NetManagerVC * netVC = [[NetManagerVC alloc] init];
//            [self.navigationController pushViewController:netVC animated:YES];
//        }
//            break;
            
        default:
            break;
    }
}
#pragma mark ---- DiscoverySubViewController上拉滑动更新位置代理
- (void)scrollViewDidScrollWithHeight:(CGFloat)offset {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGFloat height = _baseView.height;//偏移量
        if (offset > 0)//向下拉是负值，向上是正
        {
            _baseView.y = - height + _segmentView.height;
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
    {
        if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
             [self contactWithCustomerServerWithType:ContactServerFinacialAccount button:btn];
        else
             [self contactWithCustomerServerWithType:ContactServerIntegrationIndustry button:btn];
    }else
    {
        if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
        {
            NSArray * financeImg =  _commerceDetailDict[@"financeImg"];
            NSMutableDictionary * dict  = [[NSMutableDictionary alloc]init];
            [dict setValue: _commerceDetailDict[@"financeName"] forKey:@"detail"];
            NSString * imageUrl =@"";
            if([financeImg count])
                imageUrl = [NSString stringWithFormat:@"%@",financeImg[0]];
            [dict setValue:imageUrl  forKey:@"imageUrl"];
            [dict setValue: _commerceDetailDict[@"ourPrice"] forKey:@"price"];
            
            _chooseTypeView = [[FinacialAccountPopView alloc]init];
            _chooseTypeView.finacialAccountPopViewDelegate = self;
            _chooseTypeView.selectYearDict = dict;
            [_chooseTypeView createFrame:CGRectMake(0, YGScreenHeight-(190+YGBottomMargin+20+40), YGScreenWidth, 190+YGBottomMargin+20+40) withInfoNSArry:_labelList
                             andPageType:self.pageType];
            [self.navigationController.view addSubview:_chooseTypeView];
        }
        else
        {
            if(_labelList.count)
            {
                _chooseTypeView = [[FinacialAccountPopView alloc]init];
                _chooseTypeView.finacialAccountPopViewDelegate = self;
                [_chooseTypeView createFrame:CGRectMake(0, YGScreenHeight-(190+YGBottomMargin+20+40), YGScreenWidth, 190+YGBottomMargin+20+40) withInfoNSArry:_labelList
                                 andPageType:self.pageType];
                [self.navigationController.view addSubview:_chooseTypeView];
            }
            else
            {
                //判断是哪个类型 需要弹出框还是不需要，需要什么类型信息的弹出框
                _chooseTypeView = [[FinacialAccountPopView alloc]init];
                _chooseTypeView.finacialAccountPopViewDelegate = self;
                [_chooseTypeView createFrame:CGRectMake(0, YGScreenHeight-(300+YGBottomMargin+20+40), YGScreenWidth, 300+YGBottomMargin+20+40) withInfoArray:@[@"联系人",@"手机",@"企业/个人名称",@"地址"] andPageType:@""];
                [self.navigationController.view addSubview:_chooseTypeView];
            }
        }
        
   }
}
//分享按钮
- (void)shareButtonAction:(UIButton *)btn
{
    NSString * imageStr = @"";
    if([_commerceDetailDict count])
    {
        if([_commerceDetailDict[@"commerceImg"] count])
          imageStr = _commerceDetailDict[@"commerceImg"][0];
        
        if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
        {
            if([_commerceDetailDict[@"financeImg"] count])
                imageStr =_commerceDetailDict[@"financeImg"][0];
        }
    }


    [YGAppTool shareWithShareUrl:_url shareTitle:_titleLabel.text shareDetail:@"" shareImageUrl:imageStr shareController:self];
}
-(void)reloadDataWithisCollect:(NSString *)isCollect
{
    if([isCollect isEqualToString:@"1"])
        [_favoriteButton setImage:[UIImage imageNamed:@"collect_icon_green_finish"] forState:UIControlStateNormal];
    else
        [_favoriteButton setImage:[UIImage imageNamed:@"collect_icon_black"] forState:UIControlStateNormal];
}
//收藏
- (void)favoriteButtonAction:(UIButton *)btn
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"userID"] = YGSingletonMarco.user.userId;
    
    NSString * url = @"CommerceCollect";
    if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
    {
        url = @"FinanceCollect";
        dict[@"financeID"] = self.cellWithID;
    }
    else
        dict[@"commerceID"] = self.cellWithID;


    [YGNetService YGPOST:url parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
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

//选择类型弹框的下一页按钮触发事件
- (void)nextStepWithInfoDict:(NSDictionary *)dict
{
//     if(_labelList.count)
    _categoryDict =dict;
    _inputInfoView = [[FinacialAccountPopView alloc]init];
    _inputInfoView.finacialAccountPopViewDelegate = self;
    [_inputInfoView createFrame:CGRectMake(0, YGScreenHeight-(300+YGBottomMargin+20+40), YGScreenWidth, 300+YGBottomMargin+20+40) withInfoArray:@[@"联系人",@"手机",@"企业/个人名称",@"地址"] andPageType:@"1"];
    [self.navigationController.view addSubview:_inputInfoView];
}

//填写信息弹框确认支付按钮触发事件
- (void)confirmPayWithInfoDict:(NSDictionary *)dict
{
    NSMutableDictionary * finacialDict = [[NSMutableDictionary alloc]init];
    [finacialDict setObject:dict[@"contract"] forKey:@"name"];
    [finacialDict setObject:dict[@"phone"] forKey:@"phone"];
    [finacialDict setObject:dict[@"name"] forKey:@"companyName"];
    [finacialDict setObject:dict[@"address"] forKey:@"companyAddress"];

    NSString * year = @"";
    NSString * kind = @"";
    NSString * price = @"";
    
    NSString * pageType = @"";
    
    if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
    {
        pageType =@"2";
        year = [NSString stringWithFormat:@"半年x%@", _categoryDict[@"count"]];
        kind = _commerceDetailDict[@"financeName"];
        price =  _commerceDetailDict[@"ourPrice"];
        
        [finacialDict setObject:_categoryDict[@"count"] forKey:@"count"];

        NSString * count = _categoryDict[@"count"];
        price = [NSString stringWithFormat:@"%.2f",[price floatValue] * [count integerValue]];
    }
    else
    {
        NSString * labelID = @"";
        if(_categoryDict.count)
        {
            labelID =_categoryDict[@"id"] ;
            pageType =@"3";
        }else
            pageType =@"1";
        [finacialDict setObject:labelID forKey:@"labelID"];
    }
    
    [_inputInfoView selfDisappear];
    [_chooseTypeView selfDisappear];
    //工商注册 地址咨询  财务代记账
    NSDictionary *dictModel = @{
                           @"ID":@"",
                           @"price":price,
                           @"type":pageType,
                           @"kind":kind,
                           @"year":year
                           };
    ShopItemModel *model = [[ShopItemModel alloc] init];
    [model setValuesForKeysWithDictionary:dictModel];
    BuyOrderViewController *buyOrderViewController = [[BuyOrderViewController alloc] init];
    buyOrderViewController.model = model;
    buyOrderViewController.commerceID = self.cellWithID;
    buyOrderViewController.dict = finacialDict;
    buyOrderViewController.titleLabelStr = _commerceDetailDict[@"financeName"];
    buyOrderViewController.pageType = self.pageType;
       
    [self.navigationController pushViewController:buyOrderViewController animated:YES];
    
}
//填写信息弹框取消按钮移除所有弹框
- (void)cancleAllPopViews
{
    [_inputInfoView selfDisappear];
    [_chooseTypeView selfDisappear];
}
#pragma mark - 网络请求数据
- (void)sendRequest{
    if([self.pageType isEqualToString:@"FinancialAccountingViewController"])
    {
        NSDictionary * parameters  =@{
                                      @"financeID":self.cellWithID,
                                      @"userID":YGSingletonMarco.user.userId
                                      };
        [YGNetService YGPOST:@"FinanceService" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
            _commerceDetailDict = [[NSDictionary alloc]init];
            _commerceDetailDict = responseObject[@"financeDetail"];
            _url = responseObject[@"url"];

            UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 100, 20)];
                naviTitleLabel.textColor = KCOLOR_WHITE;
                naviTitleLabel.textAlignment = NSTextAlignmentCenter;
                naviTitleLabel.text = responseObject[@"financeDetail"][@"financeName"];
                [naviTitleLabel sizeToFit];
                naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
                self.navigationItem.titleView = naviTitleLabel;
        
            _isCollect = responseObject[@"financeDetail"][@"isCollect"];
            _imgList = responseObject[@"imgList"];
            [self reloadDataWithisCollect:_isCollect];
            [self configUI];
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        NSDictionary * parameters  =@{
                                      @"commerceID":self.cellWithID,
                                      @"userID":YGSingletonMarco.user.userId
                                      };
        [YGNetService YGPOST:@"CommerceService" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
            _commerceDetailDict = [[NSDictionary alloc]init];
            _commerceDetailDict = responseObject[@"commerceDetail"];
            _labelList = [NSArray array];
            _labelList = responseObject[@"labelList"];
            _url = responseObject[@"url"];
            UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 100, 20)];
            naviTitleLabel.textColor = colorWithBlack;
            naviTitleLabel.textAlignment = NSTextAlignmentCenter;
            naviTitleLabel.text =  responseObject[@"commerceDetail"][@"commerceName"];
            [naviTitleLabel sizeToFit];
            naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
            self.navigationItem.titleView = naviTitleLabel;
            
            _isCollect = responseObject[@"commerceDetail"][@"isCollect"];
            [self reloadDataWithisCollect:_isCollect];
            [self configUI];
            
        } failure:^(NSError *error) {
            
        }];
    }

}


@end
