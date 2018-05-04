//
//  MyCollectionViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyColectionCell.h"
#import "MyCollectionTextCell.h"
#import "MyCollectionModel.h"
#import "FinacialAccountingDetailViewController.h"
#import "OfficePurchaseDetailViewController.h"
#import "AdvertisementDetailController.h"
#import "NetDetailViewController.h"
#import "NewThingsDetailController.h"
#import "RoadShowHallCrowdFundingViewController.h"
#import "RushPurchaseDetailViewController.h"
#import "HomePageLegalServiceNetDetailViewController.h"


@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@property(nonatomic,strong)NSMutableArray *interfaceArray;//收藏列表接口名
@property(nonatomic,strong)NSDictionary *paraDic;//收藏列表参数
@property(nonatomic,strong)NSMutableArray *cancelInterfaceArray;//取消收藏接口名
@property(nonatomic,strong)NSDictionary *cancelParaDic;//取消收藏参数

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = self.titleString;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _dataArray = [NSMutableArray array];
    _interfaceArray = [NSMutableArray arrayWithObjects:@"myProCollect",@"getCollection",@"getFinanceCollect",@"getCommerceCollect",@"getAdsCollect",@"getProcurementCollect",@"getNetCollect",@"MyFreshNewsCollect", nil];
    _cancelInterfaceArray = [NSMutableArray arrayWithObjects:@"proCollect",@"falshsaleCollect",@"FinanceCollect",@"CommerceCollect",@"AdsCollect",@"ProcurementCommodityCollect",@"NetServiceCollect",@"FreshNewsCollect", nil];
//    _interfaceArray = [NSMutableArray arrayWithObjects:@"myProCollect",@"getCollection",@"getFinanceCollect",@"getCommerceCollect",@"getAdsCollect",@"getProcurementCollect",@"getNetCollect",@"MyFreshNewsCollect",@"getLawCollect", nil];
//    _cancelInterfaceArray = [NSMutableArray arrayWithObjects:@"proCollect",@"falshsaleCollect",@"FinanceCollect",@"CommerceCollect",@"AdsCollect",@"ProcurementCommodityCollect",@"NetServiceCollect",@"FreshNewsCollect",@"LawServiceCollect", nil];
    
    [self configUI];
}


-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    NSString *interface;
    switch (_type) {
        case 0:
            //资金扶持
            self.paraDic = @{@"uId":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString};
            interface = _interfaceArray[_type];
            break;
        case 1:
            //抢购
            self.paraDic = @{@"usmUserId":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString};
            interface = _interfaceArray[_type];
            break;
        case 7:
            //新鲜事
            self.paraDic = @{@"userid":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString};
            interface = _interfaceArray[_type];
            break;
        case 9:
            //新鲜事
            self.paraDic = @{@"userID":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString};
            interface = _interfaceArray[_type - 1];
            break;
            
        default:
            self.paraDic = @{@"userID":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString};
            interface = _interfaceArray[_type];
            break;
    }
    [YGNetService YGPOST:interface parameters:self.paraDic showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"list"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[MyCollectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *nameString;
    NSString *imageString;
    switch (_type) {
        case 0:
            //资金扶持
            //[_dataArray[indexPath.row] valueForKey:@"ID"]
            nameString = [_dataArray[indexPath.row] valueForKey:@"projectName"];
            imageString = [_dataArray[indexPath.row] valueForKey:@"picture"];
            break;
        case 1:
            //抢购
            //[_dataArray[indexPath.row] valueForKey:@"commodityId"]
            nameString = [_dataArray[indexPath.row] valueForKey:@"commodityName"];
            imageString = [_dataArray[indexPath.row] valueForKey:@"commodityImg"];
            break;
        case 7:
            //新鲜事
            nameString = [_dataArray[indexPath.row] valueForKey:@"name"];
            imageString = [_dataArray[indexPath.row] valueForKey:@"img"];
            break;
        case 9:
            //新鲜事
            nameString = [_dataArray[indexPath.row] valueForKey:@"name"];
            imageString = [_dataArray[indexPath.row] valueForKey:@"img"];
            break;
            
        default:
            nameString = [_dataArray[indexPath.row] valueForKey:@"name"];
            imageString = [_dataArray[indexPath.row] valueForKey:@"img"];
            break;
    }
    if (imageString.length) {
        MyColectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyColectionCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyColectionCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.nameLabel.text = nameString;
        [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:YGDefaultImgFour_Three];
        cell.cancelButton.tag = indexPath.row;
        [cell.cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        MyCollectionTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollectionTextCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCollectionTextCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.nameLabel.text = nameString;
        cell.cancelButton.tag = indexPath.row;
        [cell.cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.28;
}

//进入详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type == 0) {
        //资金扶持
        RoadShowHallCrowdFundingViewController *roadShowHallCrowdFundingViewController = [[RoadShowHallCrowdFundingViewController alloc] init];
        roadShowHallCrowdFundingViewController.projectID = [_dataArray[indexPath.row] valueForKey:@"ID"];
//        roadShowHallCrowdFundingViewController.pageType = [_dataArray[indexPath.row] valueForKey:@"projectState"];
        [self.navigationController pushViewController:roadShowHallCrowdFundingViewController animated:YES];
    }
    if(_type == 1) {
        //抢购
        RushPurchaseDetailViewController *vc = [[RushPurchaseDetailViewController alloc] init];
        vc.itemId = [_dataArray[indexPath.row] valueForKey:@"commodityId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(_type == 2) {
        //财务代记账
        FinacialAccountingDetailViewController *vc = [[FinacialAccountingDetailViewController alloc]init];
        vc.pageType = @"FinancialAccountingViewController";
        vc.cellWithID = [_dataArray[indexPath.row] valueForKey:@"ID"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(_type == 3) {
        //工商一体化
        FinacialAccountingDetailViewController *vc = [[FinacialAccountingDetailViewController alloc]init];
        vc.pageType = @"IntegrationIndustryCommerceController";
        vc.hidesBottomBarWhenPushed = YES;
        vc.cellWithID = [_dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(_type == 4) {
        //广告位置
        AdvertisementDetailController *controller = [[AdvertisementDetailController alloc]init];
        controller.adsIDString = [_dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    if(_type == 5) {
        //办公采购
        OfficePurchaseDetailViewController * detailVC = [[OfficePurchaseDetailViewController alloc] init];
        detailVC.commodityID = [_dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    if(_type == 6) {
        //网络管家
        NetDetailViewController * VC = [[NetDetailViewController alloc] init];
        VC.serviceID = [_dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if(_type == 7) {
        //新鲜事
        NewThingsDetailController *vc = [[NewThingsDetailController alloc] init];
        vc.idString = [_dataArray[indexPath.row] valueForKey:@"belongId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(_type == 9) {
        //法律服务
        HomePageLegalServiceNetDetailViewController * VC = [[HomePageLegalServiceNetDetailViewController alloc] init];
        VC.serviceID = [_dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:VC animated:YES];
    }
   
}


//取消收藏
-(void)cancelClick:(UIButton *)button
{
    [self getCancelParaDic:button.tag];
    NSString *interface;
    switch (_type) {
        case 9:
            interface = _cancelInterfaceArray[_type - 1];
            break;
            
        default:
            interface = _cancelInterfaceArray[_type];
            break;
    }
    [YGAlertView showAlertWithTitle:@"确定取消收藏吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        { 
            [YGNetService YGPOST:interface parameters:self.cancelParaDic showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
                
                NSLog(@"%@",responseObject);
                [YGAppTool showToastWithText:@"取消收藏成功"];
                [_dataArray removeObjectAtIndex:button.tag];
                [_tableView reloadData];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}

//拿到每行的接口参数
-(void)getCancelParaDic:(NSInteger)number
{
    switch (_type) {
        case 0:
            //资金扶持
            self.cancelParaDic = @{@"uId":YGSingletonMarco.user.userId,@"pId":[_dataArray[number] valueForKey:@"ID"]};
            break;
        case 1:
            //抢购
            self.cancelParaDic = @{@"usmUserId":YGSingletonMarco.user.userId,@"commodityId":[_dataArray[number] valueForKey:@"commodityId"]};
            break;
        case 2:
            //财务代记账
            self.cancelParaDic = @{@"userID":YGSingletonMarco.user.userId,@"financeID":[_dataArray[number] valueForKey:@"ID"]};
            break;
        case 3:
            //工商一体化
            self.cancelParaDic = @{@"userID":YGSingletonMarco.user.userId,@"commerceID":[_dataArray[number] valueForKey:@"ID"]};
            break;
        case 4:
            //广告位置
            self.cancelParaDic = @{@"userID":YGSingletonMarco.user.userId,@"adsID":[_dataArray[number] valueForKey:@"ID"]};
            break;
        case 5:
            //办公采购
            self.cancelParaDic = @{@"userID":YGSingletonMarco.user.userId,@"commodityID":[_dataArray[number] valueForKey:@"ID"]};
            break;
        case 6:
            //网络管家
            self.cancelParaDic = @{@"userID":YGSingletonMarco.user.userId,@"serviceID":[_dataArray[number] valueForKey:@"ID"]};
            break;
        case 7:
            //新鲜事
            self.cancelParaDic = @{@"userid":YGSingletonMarco.user.userId,@"freshNewsId":[_dataArray[number] valueForKey:@"belongId"]};
            break;
        case 9:
            //法律服务
            self.cancelParaDic = @{@"userID":YGSingletonMarco.user.userId,@"serviceID":[_dataArray[number] valueForKey:@"ID"]};
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
