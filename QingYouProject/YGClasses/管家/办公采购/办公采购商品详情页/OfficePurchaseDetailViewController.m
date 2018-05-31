//
//  OfficePurchaseDetailViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OfficePurchaseDetailViewController.h"//办公室采购详情页
#import "OfficePurchaseHeaderView.h"//headerView
#import "OfficePurchaseTableViewCell.h"//评论Cell
#import "OfficePurchaseDetailModel.h"//模型
#import "ChooseGoodsFatherView.h"//选择商品规格视图
#import "CustomerCommentViewController.h"//用户评价
#import <WebKit/WebKit.h>
#import "ConfirmOrderOfficePurchase.h"//确认订单

#import "OfficePurchaseDetailShowModel.h"
#import "OfficePurchSureOrderModel.h"
#import "ChooseGoodsWithCategoriesView.h"


#define imageCount 13 //控制评论cell最多有几张图片
#define commentCellCount 3 //该页面展示几条评论cell

@interface OfficePurchaseDetailViewController ()<UITableViewDelegate,UITableViewDataSource,OfficePurchaseHeaderViewDelegate,WKNavigationDelegate,ChooseGoodsWithCategoriesViewDelegate,UIScrollViewDelegate>
{
    UIView          *_fadeNavibar; //假navi
    CGFloat                     _alpha;
    UIStatusBarStyle            _statusbarStayle;
    UIButton                    *_shareButton; //右边的按钮
    UIButton                    *_favoriteButton; //左边的返回
    UIButton                    *_backButton; //左边的返回
    UILabel      *_naviTitleLabel;
    UIView *_navLineView;
}
/** scetionHeader  */
@property (nonatomic,strong) UIView * sectionHeaderView;


/** 用户评价Label  */
@property (nonatomic,strong) UILabel * commentLabel;
/** 查看更多Button  */
@property (nonatomic,strong) LDExchangeButton * moreButton;
/** tableView  */
@property (nonatomic,strong) UITableView * tableView;
/** headerView  */
@property (nonatomic,strong) OfficePurchaseHeaderView * headerView;
/**  footerView */
@property (nonatomic,strong) UIView * footerView;
/**  footerWebView */
@property (nonatomic,strong) WKWebView * footerWebView;
/** 真实数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
/** 当前控制器需要的数据源  */
@property (nonatomic,strong) NSMutableArray * realDataArray;
/** 底部悬浮视图  */
@property (nonatomic,strong) UIView * bottomView;
/** <#name#>  */
@property (nonatomic,strong) NSArray * titleArray;
/** <#name#>  */
@property (nonatomic,strong) NSArray * tagArray;

@property (nonatomic,strong) OfficePurchaseDetailShowModel * model;
@property (nonatomic,strong) OfficePurchaseDetailCommodityModel *  CommodityModel;

@property (nonatomic,strong) NSString *  value1;
@property (nonatomic,strong) NSString *  value2;

@property (nonatomic,strong) ChooseGoodsFatherView * goodsView;

@property (nonatomic,strong) NSString *  url;
@property (nonatomic, strong)  NSArray * iamgeArry;

@end

@implementation OfficePurchaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //隐藏导航栏
    self.fd_prefersNavigationBarHidden = YES;
    
    //添加tableView
    [self.view addSubview:self.tableView];

    [self creatNav];
    
    [self.view addSubview:self.bottomView];
    
    [self loadDataFromServer];
}



- (void)loadDataFromServer
{
    NSString * userId = YGSingletonMarco.user.userId;
    if(!userId.length)
        userId =@"";
    NSDictionary *parameters = @{
                                 @"userID":userId,
                                 @"commodityID":self.commodityID,
                                 };
    NSString *url = @"ProcurementCommodityDetail";
    
    [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        self.model= [[OfficePurchaseDetailShowModel alloc]init];
        self.model.commentCount =  responseObject[@"commentCount"];
        self.model.isCollect =  responseObject[@"isCollect"];
        self.model.labelList =  responseObject[@"labelList"];

        self.model.isCollect = responseObject[@"isCollect"];
        [self reloadDataWithisCollect:self.model.isCollect];
        
        self.url = responseObject[@"url"];
         self.CommodityModel = [OfficePurchaseDetailCommodityModel mj_objectWithKeyValues:responseObject[@"commodity"]];
        
        NSString * commodityImgs = [NSString stringWithFormat:@"%@",self.CommodityModel.commodityImgs];
        
         self.iamgeArry = [NSArray array];
         self.iamgeArry = [commodityImgs componentsSeparatedByString:@","];
            
        [self.headerView reloadDataWith:self.iamgeArry goodsName:self.CommodityModel.commodityName goodsPrice:[NSString stringWithFormat:@"¥%@",self.CommodityModel.commodityPrice] deliveryPrice:self.CommodityModel.commodityFreight withisCollect:self.model.isCollect];
        
        self.tableView.tableHeaderView = self.headerView;
        
        _naviTitleLabel.text = self.CommodityModel.commodityName;
        [_naviTitleLabel sizeToFit];
        CGFloat w = _naviTitleLabel.width;
        if(w > YGScreenWidth - 160)
            w = YGScreenWidth - 160;
        _naviTitleLabel.frame = CGRectMake((YGScreenWidth - w)/2, 0, w, 20);
        [_fadeNavibar addSubview:_naviTitleLabel];
        _naviTitleLabel.centery = _backButton.centery;
        
        [self.dataArray addObjectsFromArray:[OfficePurchaseDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"commentList"]]];

        //本页最多只取三条数据,
        NSInteger count = (self.dataArray.count > commentCellCount) ? commentCellCount : self.dataArray.count;
        
        for (int i = 0; i < count; i++) {
            
            OfficePurchaseDetailModel * model = self.dataArray[i];
            model.countOfArr = 0;
            [self.realDataArray addObject:model];
        }
        
        //footer
        
        [self.footerWebView loadHTMLString: [NSString stringWithFormat:
                                             @"<html> \n"
                                             "<head> <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\">\n"
                                             "<style type=\"text/css\"> \n"
                                             "max-width:100%%"
                                             "</style> \n"
                                             "</head> \n"
                                             "<body>%@</body> \n"
                                             "</html>",
                                             self.CommodityModel.commodityDetail] baseURL:nil];
        
        [self.tableView reloadData];
        
    } failure:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.realDataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self moreButtonClick:self.moreButton];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * header = self.sectionHeaderView;
    
    self.commentLabel.text =[NSString stringWithFormat:@"用户评价(%@)",self.model.commentCount];

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.realDataArray.count == 0) {
        
        return 0 * LDVPadding;

    }else{
        
        return 4 * LDVPadding;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OfficePurchaseDetailModel * model = self.realDataArray[indexPath.row];
    
    
    NSString * reuseIdentifier = [NSString stringWithFormat:@"%ld",model.countOfArr];
    
    OfficePurchaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OfficePurchaseDetailModel * model = self.realDataArray[indexPath.row];
    
    NSString * reuseIdentifier = [NSString stringWithFormat:@"%ld",model.countOfArr];
    
    return  [tableView fd_heightForCellWithIdentifier:reuseIdentifier cacheByIndexPath:indexPath configuration:^(OfficePurchaseTableViewCell* cell) {
        
        cell.model = self.realDataArray[indexPath.row];
        
    }];
    
}
static NSString * const  OfficePurchaseTableViewCellId = @"OfficePurchaseTableViewCellId";
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 150;

        [_tableView setSeparatorColor:colorWithLine];
        
        //header
        OfficePurchaseHeaderView * header = [[OfficePurchaseHeaderView alloc] init];
        self.headerView = header;
        self.headerView.delegate = self;
        header.frame = CGRectMake(0, 0, kScreenW, kScreenW);
        self.tableView.tableHeaderView = header;
        
        
        _tableView.estimatedRowHeight =0 ;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        
        //footer
        self.tableView.tableFooterView = self.footerView;
        
        //注册cell
        for (NSInteger i = 0; i < imageCount; i++) {
            NSString * reuseIdentifier = [NSString stringWithFormat:@"%ld",i];

            [self.tableView registerClass:[OfficePurchaseTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        }
        
        if (@available(iOS 11.0, *)) {
            
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
           
        } else {
            
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.backgroundColor = kWhiteColor;

    }
    return _tableView;
}


#pragma mark - 联系客服
- (void)contactButtonClick:(UIButton *)contactButton{

    [self contactWithCustomerServerWithType:ContactServerOfficePurchase button:contactButton];
}
#pragma mark - 立刻购买
- (void)buyButtonClick:(UIButton *)buyButton{
    if(![self loginOrNot])
        return;
    
    NSMutableArray * array =[[NSMutableArray alloc]init];
    
    for(int i=0;i<self.model.labelList.count;i++)
    {
        NSDictionary * dict =self.model.labelList[i];
        [array addObject:dict[@"name"]];
    }
    ChooseGoodsWithCategoriesView  * chooseview = [[ChooseGoodsWithCategoriesView alloc]init];
    chooseview.labelList = self.model.labelList;
    chooseview.delegate =self;
    chooseview.dataSource = array;
    chooseview.detailStr = self.CommodityModel.commodityName;
    [chooseview createFrame:CGRectMake(0, YGScreenHeight-(190+YGBottomMargin+100), YGScreenWidth, 190+YGBottomMargin+100) withInfoNSArry:array];
    [self.navigationController.view addSubview:chooseview];
}
- (void)chooseGoodsWithCategoriesViewSurePaywitDict:(NSDictionary *)dict
{
    if(![self loginOrNot])
        return;
    
    NSDictionary *parameters = @{
                                 @"userID":YGSingletonMarco.user.userId,
                                 @"commodityID":self.commodityID,
                                 @"count":dict[@"count"],
                                 @"labelID":dict[@"labelID"]
                                 };
    NSString *url = @"ProcurementConfirmOrder";

    
    [YGNetService YGPOST:url parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        OfficePurchSureOrderModel * Ordermodel =[[OfficePurchSureOrderModel alloc]init];
        Ordermodel.point = responseObject[@"point"];
        Ordermodel.commodity = responseObject[@"commodity"];
        Ordermodel.address = responseObject[@"address"];
        Ordermodel.pointPrice = responseObject[@"pointPrice"];
        
        ConfirmOrderOfficePurchase * vc = [[ConfirmOrderOfficePurchase alloc] init];
        vc.model = Ordermodel;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:nil];
}
#pragma mark - 返回按钮点击
- (void)OfficePurchaseHeaderViewBackButtonClick:(UIButton *)backButton{

    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - 收藏按钮点击
- (void)OfficePurchaseHeaderViewCollectButtonClick:(UIButton *)collectButton{
    
    if(![self loginOrNot])
        return;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"userID"] = YGSingletonMarco.user.userId;
    dict[@"commodityID"] = self.commodityID;
    
    [YGNetService YGPOST:@"ProcurementCommodityCollect" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        if([self.model.isCollect isEqualToString:@"0"])
        {
             self.model.isCollect =@"1";
            
            [self reloadDataWithisCollect:@"1"];
            [YGAppTool showToastWithText:@"收藏成功"];
        }
        else
        {
            self.model.isCollect =@"0";
            [self reloadDataWithisCollect:@"0"];
            [YGAppTool showToastWithText:@"取消收藏"];
        }
    } failure:^(NSError *error) {
        [YGAppTool showToastWithText:@"操作失败"];
    }];
    
}
//-(void)reloadDataWithisCollect:(NSString *)isCollect
#pragma mark - 分享按钮点击
- (void)OfficePurchaseHeaderViewShareButtonClick:(UIButton *)shareButton{
    
    if(self.iamgeArry.count)
    {
        [YGAppTool shareWithShareUrl:self.url shareTitle:self.CommodityModel.commodityName shareDetail:@"" shareImageUrl:self.iamgeArry[0] shareController:self];
    }
    else
        [YGAppTool shareWithShareUrl:self.url shareTitle:self.CommodityModel.commodityName shareDetail:@"" shareImageUrl:@"" shareController:self];

}
#pragma mark - 轮播器代理事件
- (void)OfficePurchaseHeaderViewcycleScrollViewDidSelectItemAtIndex:(NSInteger)index{
    
//    [YGAppTool showToastWithText:[NSString stringWithFormat:@"点击了第%ld张图片",index]];

}
#pragma mark - 评论查看更多
- (void)moreButtonClick:(UIButton*)moreButton{
    CustomerCommentViewController * vc = [[CustomerCommentViewController alloc] init];
    vc.commentCount = self.model.commentCount;
    vc.commodityID  = self.commodityID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.footerWebView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        float webViewHeight = [result doubleValue];
//        CGRect frame = webView.frame;
//        frame.size.height = webViewHeight;
//        webView.frame = frame;

        self.footerView.frame = CGRectMake(0, 0, YGScreenWidth, webViewHeight + 6 * LDVPadding + YGBottomMargin + LDVPadding + 5*LDVPadding);

        self.tableView.tableFooterView = self.footerView;
        [self.tableView reloadData];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)realDataArray{
    if (!_realDataArray) {
        _realDataArray = [NSMutableArray array];
    }
    return _realDataArray;
}
#pragma mark - sectionHeaderView
- (UIView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        
        _sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 5 * LDVPadding)];
        
        self.commentLabel = [UILabel ld_labelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:LDFont(15) numberOfLines:1];
        self.commentLabel.font = LDBoldFont(15);
        [_sectionHeaderView addSubview:self.commentLabel];
        
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(LDHPadding);
            make.top.bottom.offset(0);
        }];
        
        self.moreButton = [LDExchangeButton buttonWithType:UIButtonTypeCustom];
        [_sectionHeaderView addSubview:self.moreButton];
        [self.moreButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        [self.moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [self.moreButton setImage:LDImage(@"steward_more_green") forState:UIControlStateNormal];
        [self.moreButton.titleLabel setFont:LDFont(14)];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(- LDHPadding);
            make.bottom.top.offset(0);
        }];
        [self.moreButton sizeToFit];
        [self.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sectionHeaderView;
}
#pragma mark - footerView
- (UIView *)footerView{
    if (!_footerView) {
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
        
//        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, LDHPadding)];
//        line.backgroundColor = colorWithLine;
//        [_footerView addSubview:line];
        
        UILabel * goodsDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, kScreenW - 2 * LDHPadding, 4 * LDVPadding)];
        [_footerView addSubview:goodsDetailLabel];
        goodsDetailLabel.font = LDBoldFont(15);
        goodsDetailLabel.text = @"商品详情";
        
//        _footerView.backgroundColor = kWhiteColor;
        self.footerWebView = [[WKWebView alloc] init];
        self.footerWebView.scrollView.scrollEnabled = NO;
        [_footerView addSubview:self.footerWebView];
        self.footerWebView.navigationDelegate = self;
        [self.footerWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.top.offset(5 * LDVPadding);
        }];
    }
    return _footerView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        //悬浮视图
        CGFloat H = YGNaviBarHeight + YGBottomMargin -1;
        CGFloat Y = kScreenH - H;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Y, kScreenW, H)];
        [self.view addSubview:_bottomView];
//        _bottomView.backgroundColor = kBlueColor;
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
        line.backgroundColor = colorWithLine;
        [_bottomView addSubview:line];
        
        UIButton * contactButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"联系客服" selectedTitle:@"联系客服" normalTitleColor:LD16TextColor selectedTitleColor:LD16TextColor backGroundColor:kWhiteColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:14];
        [contactButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
//        [coverButton setTitle:@"联系客服" forState:UIControlStateNormal];
        [contactButton setImage:[UIImage imageNamed:@"service_black"] forState:UIControlStateNormal];
        [contactButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        
        [contactButton addTarget:self action:@selector(contactButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        contactButton.frame = CGRectMake(0, 1, kScreenW / 2, H );
        [_bottomView addSubview:contactButton];
        
        UIButton * buyButton = [UIButton buttonWithType:UIButtonTypeCustom normalImage:nil selectedImage:nil normalTitle:@"立即购买" selectedTitle:@"立即购买" normalTitleColor:kWhiteColor selectedTitleColor:kWhiteColor backGroundColor:LDMainColor normalBackGroundImageStr:nil selectedBackGroundImageStr:nil titleFont:14];
        [buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        buyButton.frame = CGRectMake(kScreenW / 2, 1, kScreenW / 2, H);
        [_bottomView addSubview:buyButton];
        
    }
    return _bottomView;
}

#pragma mark ---- DiscoverySubViewController上拉滑动更新位置代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = scrollView.contentOffset;

    CGFloat offsetY = translation.y;
    //控制导航渐变
    if (offsetY<0) {
        CGFloat alpha = 0;
        [_backButton setImage:[[UIImage imageNamed:@"back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_shareButton setImage:[[UIImage imageNamed:@"share_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        if([self.model.isCollect isEqualToString:@"1"])
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_green"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        else
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        _alpha = alpha;
        _naviTitleLabel.hidden = YES;
        _navLineView.hidden = YES;
        
    } else if (offsetY>0 && offsetY<= 45) {
        CGFloat alpha = 1;
        [_backButton setImage:[[UIImage imageNamed:@"back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_shareButton setImage:[[UIImage imageNamed:@"share_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        //        [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        if([self.model.isCollect isEqualToString:@"1"])
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_green_finish"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        else
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        
        _alpha = alpha;
        _naviTitleLabel.hidden = NO;
        _navLineView.hidden = NO;
    } else if (offsetY>=45) {
        CGFloat alpha = 1;
        [_backButton setImage:[[UIImage imageNamed:@"back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_shareButton setImage:[[UIImage imageNamed:@"share_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        //        [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        if([self.model.isCollect isEqualToString:@"1"])
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_green_finish"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        else
            [_favoriteButton setImage:[[UIImage imageNamed:@"collect_icon_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        _alpha = alpha;
        _naviTitleLabel.hidden = NO;
        _navLineView.hidden = NO;
    }
    _fadeNavibar.backgroundColor  = [colorWithYGWhite colorWithAlphaComponent:_alpha];
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

-(void)creatNav
{
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

    _naviTitleLabel.hidden = YES;
    _naviTitleLabel.centery = _backButton.centery;

    
    _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-50,YGStatusBarHeight,40,40)];
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_shareButton addTarget:self action:@selector(OfficePurchaseHeaderViewShareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_fadeNavibar addSubview:_shareButton];
    
    [_shareButton setImage:[[UIImage imageNamed:@"share_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    
    _favoriteButton = [[UIButton alloc]initWithFrame:CGRectMake(_shareButton.x-45,_shareButton.y,40,40)];
    _favoriteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_favoriteButton addTarget:self action:@selector(OfficePurchaseHeaderViewCollectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_fadeNavibar addSubview:_favoriteButton];
    [_favoriteButton setImage:[[UIImage imageNamed:@"collect_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

}
- (void)backButtonAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
