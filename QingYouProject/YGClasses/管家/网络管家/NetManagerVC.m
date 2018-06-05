//
//  NetManagerVC.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "NetManagerVC.h"
#import "NetManagerCell.h"//推荐cell
#import "NetManagerDetailVC.h"//网络管理服务介绍
#import "NetVIPDetailVC.h"//VIP卡介绍
#import "LDNetManagerApplyVC.h"//VIP网络管理服务,立即申请页面
#import "NetDetailViewController.h"//商品详情
#import "NetVIPmodel.h"
#import "NetManagerWithVIPServiceViewController.h"


#import "HomePageLegalServiceViewController.h"

@interface NetManagerVC ()<UITableViewDelegate,SDCycleScrollViewDelegate,UITableViewDataSource>
/** 轮播图  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/** tableview  */
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * serviceIDArray;

/** footerView  */
@property (nonatomic,strong) UIView * footerView;
/** titleButton数据源  */
@property (nonatomic,strong) NSArray * titleArray;
/** VIPButton  */
@property (nonatomic,strong) UIButton * vipButton;
@property (nonatomic,strong) NSString * isVIP;

@end

@implementation NetManagerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    //添加tableView
    [self.view addSubview:self.tableView];
    //设置导航栏
    self.naviTitle = @"网络管家";
    [self setupNav];
    //网络请求
    [self sendRequest];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupNav{
        
        // 右边按钮
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"decorate_nav_icon"] highImage:[UIImage imageNamed:@"service_green"] target:self action:@selector(rightBarButtonClick:)];
    
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
        
    [self contactWithCustomerServerWithType:ContactServerNetManager button:rightBarButton];
    
}


#pragma mark - 网络请求数据
- (void)sendRequest{
   
    [YGNetService YGPOST:@"NetIndex" parameters:@{@"userID":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSArray * imgBanner = [responseObject valueForKey:@"imgBanner"];
        self.serviceIDArray = [[NSMutableArray alloc]init];
        NSMutableArray * imgArray = [[NSMutableArray alloc]init];

        for (int i =0 ; i<imgBanner.count; i++) {
             NSDictionary * dict = imgBanner[i];
            [imgArray addObject:dict[@"img"]];
            [self.serviceIDArray addObject:dict[@"serviceID"]];
        }
        self.cycleScrollView.imageURLStringsGroup = imgArray;
        self.dataArray = [NSMutableArray array];
        [self.dataArray addObjectsFromArray:[NetVIPmodel mj_objectArrayWithKeyValuesArray:responseObject[@"service"]]];
        self.isVIP  = [NSString stringWithFormat:@"%@",responseObject[@"isVIP"]];
        
        [self.vipButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"imgVIPApply"]]] forState:UIControlStateNormal placeholderImage:YGDefaultImgHorizontal];

        for (UIButton * subView in self.footerView.subviews)
        {
            switch (subView.tag) {
                case 100:
                    [subView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"imgNetTransaction"]]] forState:UIControlStateNormal placeholderImage:YGDefaultImgTwo_One];
                    break;
                case 101:
                    [subView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"imgVIPIntroduce"]]] forState:UIControlStateNormal placeholderImage:YGDefaultImgTwo_One];
                    break;
                default:
                    break;
            }
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
        LDLog(@"%@",error);
    }];
}


#pragma mark - tableViewDelegate And DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NetManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:NetManagerCellId];
    cell.model = self.dataArray[indexPath.row];
    cell.isVIP = self.isVIP;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
#pragma mark - cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.isVIP isEqualToString:@"1"])
    {
        [YGNetService YGPOST:@"IndoorCall" parameters:@{@"rank":@"15"} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            [YGAlertView showAlertWithTitle:@"您已经是VIP用户\n可以直接联系客服或拨打服务人员电话直接办理业务" buttonTitlesArray:@[@"联系客服"] buttonColorsArray:@[colorWithBlack] handler:^(NSInteger buttonIndex) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",responseObject[@"callNum"]]];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }];
            
        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"电话号码获取失败"];
        }];
        
        return;
    }

    NetDetailViewController * VC = [[NetDetailViewController alloc] init];
    VC.serviceID = ((NetVIPmodel *)self.dataArray[indexPath.row]).serviceID;
    [self.navigationController pushViewController:VC animated:YES];
}

static NSString * const NetManagerCellId = @"NetManagerCellId";
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 ) style:UITableViewStylePlain];
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NetManagerCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NetManagerCellId];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //tableHeaderView
        CGFloat headerH = kScreenW / Banner_W_H_Scale + 87 + 45;
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,headerH)];
        
        //tableHeaderView 添加 轮播图
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.ld_width, floorf(kScreenW / Banner_W_H_Scale)) delegate:self placeholderImage:YGDefaultImgTwo_One];
        [headerView addSubview:self.cycleScrollView];
        
        //         [SDCycleScrollView cycleScrollViewWithFrame: imageNamesGroup:@[@"5", @"6", @"8"]];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 3;
        //        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        //        _cycleScrollView.pageDotImage = [UIImage ld_imageWithColor:kBlueColor];
        //        _cycleScrollView.currentPageDotImage = [UIImage ld_imageWithColor:kRedColor];
        //        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        //        _cycleScrollView.clipsToBounds = YES;
        _cycleScrollView.backgroundColor = kClearColor;
        _tableView.tableHeaderView = headerView;
        //VIP button
        UIButton * vipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.vipButton = vipButton;
        vipButton.frame = CGRectMake(LDHPadding, kScreenW / Banner_W_H_Scale + LDVPadding, kScreenW - 2 * LDHPadding, 57);
        [vipButton addTarget:self action:@selector(vipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        vipButton.layer.cornerRadius = 5;
        [headerView addSubview:vipButton];
        
        //头部分割线
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, headerH - LDVPadding - 45, kScreenW, LDVPadding)];
        bottomLine.backgroundColor = colorWithLine;
        [headerView addSubview:bottomLine];
        //为您推荐
        UIView  *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, headerH - 45, kScreenW, 45)];
        bottomView.backgroundColor = kWhiteColor;
        [headerView addSubview:bottomView];
        UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(LDHPadding, 0, kScreenW - 2 * LDHPadding, 45)];
        titleLable.text = @"为您推荐";
        [bottomView addSubview:titleLable];

        //tableFooterView
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 300)];
        self.footerView.backgroundColor = kWhiteColor;
        _tableView.tableFooterView = self.footerView;
        //分割线
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, LDVPadding)];
        [self.footerView addSubview:topLine];
        topLine.backgroundColor = LDRGBColor(236, 236, 245);
        
        CGFloat W = kScreenW - 2 * LDHPadding;
        CGFloat scal_W_H = 3.49;
        CGFloat H = W / scal_W_H;
        
        for (int i = 0; i < 2; i ++) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(LDHPadding,2 * LDVPadding + (LDVPadding + H) * i, W, H);
            button.layer.cornerRadius = 5;
            [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
            [self.footerView addSubview:button];
      
        }

    }
    return _tableView;
}
#pragma mark - bottomButtonClick点击事件
- (void)bottomButtonClick:(UIButton *)bottomButton{
    NSInteger tag = bottomButton.tag;
    
    //tag值做区分跳转
    switch (tag) {
        case 100:
            {
            //网络管理服务介绍
                NetManagerDetailVC * vc = [[NetManagerDetailVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 101:
        {
            //VIP介绍
            NetVIPDetailVC * vc = [[NetVIPDetailVC alloc] init];
            vc.isVIP =self.isVIP;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }

}
#pragma mark - VIP网络管理服务
- (void)vipButtonClick:(UIButton *)vipButton{
    
    LDNetManagerApplyVC * vc = [[LDNetManagerApplyVC alloc] init];
    vc.isVIP =self.isVIP;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if([self.isVIP isEqualToString:@"1"])
    {
        [YGNetService YGPOST:@"IndoorCall" parameters:@{@"rank":@"15"} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            
            [YGAlertView showAlertWithTitle:@"您已经是VIP用户\n可以直接联系客服或拨打服务人员电话直接办理业务" buttonTitlesArray:@[@"联系客服"] buttonColorsArray:@[colorWithBlack] handler:^(NSInteger buttonIndex) {
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[NSString stringWithFormat:@"%@",responseObject[@"callNum"]]];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }];
            
        } failure:^(NSError *error) {
            [YGAppTool showToastWithText:@"电话号码获取失败"];
        }];
        
        return;
    }
    
    NetDetailViewController * VC = [[NetDetailViewController alloc] init];
    VC.serviceID = self.serviceIDArray[index];
    [self.navigationController pushViewController:VC animated:YES];
  
}


@end
