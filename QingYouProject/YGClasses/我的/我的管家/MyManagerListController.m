//
//  MyManagerListController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/7.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyManagerListController.h"
#import "MeetingOrderViewController.h"
#import "AdvertisementLocationApplyController.h"
#import "OfficePurchaseOrderListViewController.h"
#import "RepairOrderViewController.h"
#import "NetManagerWithVIPServiceViewController.h"
#import "MyHouseRentPayViewController.h"
#import "MyDecorationCenterViewController.h"
#import "MineProjectApplyViewController.h"


#import "CheckUserInfoViewController.h"
#import "HouseRentAuditViewController.h"
#import "UpLoadIDFatherViewController.h"

#import "MyOrderCheckHouseViewController.h"
#import "HomePageLegalServiceWithVIPServiceViewController.h"

@interface MyManagerListController () <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_imageArray;
    NSString *_type; //1:用户 2：工人
}

@end

@implementation MyManagerListController

-(void)loadData
{

//    _titleArray = [NSArray arrayWithObjects:@"办公采购",@"预定会议室",@"网络管家",@"广告位置",@"预约看房",@"室内报修",@"装修直通车",@"项目申报",@"房租缴纳",@"法律服务", nil];
//
//    _imageArray = [NSArray arrayWithObjects:@"mine_steward_purchasing",@"mine_steward_meettingroom",@"mine_steward_internet",@"mine_steward_ad",@"mine_steward_bookming",@"mine_steward_repair",@"mine_steward_decorate",@"mine_steward_project",@"mine_steward_rent",@"mine_steward_legal", nil];
    
    [YGNetService YGPOST:@"IndoorPicture" parameters:@{@"commenId":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        _type = [responseObject valueForKey:@"type"];
        
        
        if ([_type isEqualToString:@"2"]) {
            _titleArray = [NSArray arrayWithObjects:@"办公采购",@"预定会议室",@"网络管家",@"广告位置",@"预约看房",@"装修直通车",@"项目申报",@"房租缴纳", nil];
            
            _imageArray = [NSArray arrayWithObjects:@"mine_steward_purchasing",@"mine_steward_meettingroom",@"mine_steward_internet",@"mine_steward_ad",@"mine_steward_bookming",@"mine_steward_decorate",@"mine_steward_project",@"mine_steward_rent", nil];
//            _titleArray = [NSArray arrayWithObjects:@"办公采购",@"预定会议室",@"网络管家",@"广告位置",@"预约看房",@"装修直通车",@"项目申报",@"房租缴纳",@"法律服务", nil];
//
//            _imageArray = [NSArray arrayWithObjects:@"mine_steward_purchasing",@"mine_steward_meettingroom",@"mine_steward_internet",@"mine_steward_ad",@"mine_steward_bookming",@"mine_steward_decorate",@"mine_steward_project",@"mine_steward_rent",@"mine_steward_legal", nil];
        }
        else
        {
            _titleArray = [NSArray arrayWithObjects:@"办公采购",@"预定会议室",@"网络管家",@"广告位置",@"预约看房",@"室内报修",@"装修直通车",@"项目申报",@"房租缴纳", nil];
            
            _imageArray = [NSArray arrayWithObjects:@"mine_steward_purchasing",@"mine_steward_meettingroom",@"mine_steward_internet",@"mine_steward_ad",@"mine_steward_bookming",@"mine_steward_repair",@"mine_steward_decorate",@"mine_steward_project",@"mine_steward_rent", nil];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"我的管家";
   
    
    [self loadData];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight) style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self loginOrNot])
    {
        return;
    }
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    if ([cell.textLabel.text isEqualToString:@"办公采购"]) {
        //办公采购
        NSArray * titleArray = @[@"全部",@"待付款",@"待发货",@"已发货",@"售后"];
        NSArray * classArray = @[@"AllOfficePurchaseOrderListViewController",@"PendingPaymentOfficePurchaseViewController",@"DeliveredViewController",@"ShippedViewController",@"AfterSaleViewController"];
        OfficePurchaseOrderListViewController * vc = [[OfficePurchaseOrderListViewController alloc] initWithTitleArray:titleArray viewControllerClassStringArray:classArray navgationTitle:@"办公采购订单"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([cell.textLabel.text isEqualToString:@"预定会议室"]) {
        //预定会议室
        MeetingOrderViewController *vc = [[MeetingOrderViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([cell.textLabel.text isEqualToString:@"网络管家"]) {

        //网络管家
        NetManagerWithVIPServiceViewController * netManager = [[NetManagerWithVIPServiceViewController alloc]init];
        [self.navigationController pushViewController:netManager animated:YES];
        
    }
    if ([cell.textLabel.text isEqualToString:@"广告位置"]) {

        //广告位申请
        NSArray * titleArr = @[@"待处理",@"处理中",@"已处理"];
        NSArray * classArr = @[@"AlreadyProcessedViewController",@"AlreadyProcessedViewController",@"AlreadyProcessedViewController"];
        AdvertisementLocationApplyController * alVC= [[AdvertisementLocationApplyController alloc] initWithTitleArray:titleArr viewControllerClassStringArray:classArr navgationTitle:@"广告位置"];
        [self.navigationController pushViewController:alVC animated:YES];
        
    }
    if ([cell.textLabel.text isEqualToString:@"预约看房"]) {

        //预约看房
        
        MyOrderCheckHouseViewController * repaire =[[MyOrderCheckHouseViewController alloc]init];
        [self.navigationController pushViewController:repaire animated:YES];
    }
    if ([cell.textLabel.text isEqualToString:@"室内报修"]) {

        //室内报修
        RepairOrderViewController * repaire =[[RepairOrderViewController alloc]init];
        [self.navigationController pushViewController:repaire animated:YES];
        
    }
    if ([cell.textLabel.text isEqualToString:@"装修直通车"]) {

        //装修直通车
        MyDecorationCenterViewController *vc = [[MyDecorationCenterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if ([cell.textLabel.text isEqualToString:@"项目申报"]) {

        //项目申报
        MineProjectApplyViewController *mineProjectVC = [[MineProjectApplyViewController alloc] init];
        [self.navigationController pushViewController:mineProjectVC animated:YES];
        
    }
    if ([cell.textLabel.text isEqualToString:@"法律服务"]) {
        HomePageLegalServiceWithVIPServiceViewController * orderView  = [[HomePageLegalServiceWithVIPServiceViewController alloc]init];
        [self.navigationController pushViewController:orderView animated:YES];
        
    }
    if ([cell.textLabel.text isEqualToString:@"房租缴纳"]) {

        //房租缴纳审核
        [YGNetService YGPOST:REQUEST_HouserAudit parameters:@{@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
            //返回值state ==0是请提交审核材料 ==1待审核 ==2审核通过直接跳到房租缴纳首页 ==3审核不通过跳到传身份证页面并提示请重新上传资料审核
            if ([responseObject[@"state"] isEqualToString:@"1"]) {
                HouseRentAuditViewController *controller = [[HouseRentAuditViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
                
                
            }else if([responseObject[@"state"] isEqualToString:@"2"])
            {
                CheckUserInfoViewController *controller = [[CheckUserInfoViewController alloc]init];
                controller.pageType = @"myHousePay";
                [self.navigationController pushViewController:controller animated:YES];
                
                
            }else if ([responseObject[@"state"] isEqualToString:@"3"])
            {
                UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                controller.notioceString = @"您的资料未通过审核,请重新上传资料";
                [self.navigationController pushViewController:controller animated:YES];
            }else
            {
                UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                controller.notioceString = @"请上传资料进行审核，审核通过后可进行房租缴纳";
                [self.navigationController pushViewController:controller animated:YES];
            }
            
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
