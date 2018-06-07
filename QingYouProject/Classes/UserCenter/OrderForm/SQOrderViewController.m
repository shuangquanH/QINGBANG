//
//  SQOrderViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/16.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQOrderViewController.h"

#import "SQOrderTableHeaderView.h"

/** 房租缴纳 待审核状态  */
#import "HouseRentAuditViewController.h"
/** 房租缴纳 审核通过状态(水电缴费首页) */
#import "CheckUserInfoViewController.h"
/** 房租缴纳 用户资料审核  */
#import "UpLoadIDFatherViewController.h"

/** 工商一体化  */
#import "MyIntegrationIndustryCommerceController.h"
/** 财税代理  */
#import "MyFinancialAccountViewController.h"
/** 办公采购订单  */
#import "OfficePurchaseOrderListViewController.h"
/** 装修订单  */
#import "SQDecorationOrderVC.h"
/** 会议室预定  */
#import "MeetingOrderViewController.h"
/** 项目申报  */
#import "MineProjectApplyViewController.h"
/** 我的人才招聘  */
#import "MyRecruitViewController.h"

#import "WKMyOrderUnreadCountModel.h"
#import "WKUserCenterBadgeCell.h"

@interface SQOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray                   *orderFormArr;
@property (nonatomic, strong) SQBaseTableView           *tableview;
@property (nonatomic, strong) WKMyOrderUnreadCountModel *unreadInfo;
@end

@implementation SQOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"我的订单";
    
    [self sendUnreadBadgeReqeust];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"SQOrderFormListPlist" ofType:@"plist"];
    self.orderFormArr = [NSArray arrayWithContentsOfFile:path];
    [self.view addSubview:self.tableview];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)sendUnreadBadgeReqeust {
    [SQRequest post:KAPI_UNREADORDERBADGE param:nil success:^(id response) {
        if ([response[@"state"] isEqualToString:@"success"]) {
            self.unreadInfo = [WKMyOrderUnreadCountModel yy_modelWithJSON:response[@"data"]];
            [self.tableview reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderFormArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKUserCenterBadgeCell *cell = [WKUserCenterBadgeCell cellWithTableView:tableView];
    cell.imageView.image = [UIImage imageNamed:@"mine_instashot"];
    cell.textLabel.text = self.orderFormArr[indexPath.section][@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self loginOrNot]) {
        return;
    }
    NSString *titlestr = self.orderFormArr[indexPath.section][@"title"];
    
    if ([titlestr isEqualToString:@"水电缴费"]) {
        [YGNetService YGPOST:REQUEST_HouserAudit parameters:@{@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
            //返回值state=0是请提交审核材料,=1待审核,=2审核通过直接跳到房租缴纳首页,=3审核不通过跳到传身份证页面并提示请重新上传资料审核
            if ([responseObject[@"state"] isEqualToString:@"1"]) {
                HouseRentAuditViewController *controller = [[HouseRentAuditViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
                
            } else if([responseObject[@"state"] isEqualToString:@"2"]) {
                CheckUserInfoViewController *controller = [[CheckUserInfoViewController alloc]init];
                controller.pageType = @"myHousePay";
                [self.navigationController pushViewController:controller animated:YES];
                
            }else if ([responseObject[@"state"] isEqualToString:@"3"]) {
                UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                controller.notioceString = @"您的资料未通过审核,请重新上传资料";
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                controller.notioceString = @"请上传资料进行审核，审核通过后可进行房租缴纳";
                [self.navigationController pushViewController:controller animated:YES];
            }
        } failure: nil];
    }
    if ([titlestr isEqualToString:@"工商代办"]) {
        MyIntegrationIndustryCommerceController * myIntegrationIndustry = [[MyIntegrationIndustryCommerceController alloc]init];
        [self.navigationController pushViewController:myIntegrationIndustry animated:YES];
    }
    if ([titlestr isEqualToString:@"财税代理"]) {
        MyFinancialAccountViewController * myFinancialAccount = [[MyFinancialAccountViewController alloc]init];
        [self.navigationController pushViewController:myFinancialAccount animated:YES];
    }
    
    if ([titlestr isEqualToString:@"办公采购"]) {
        OfficePurchaseOrderListViewController * vc = [[OfficePurchaseOrderListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([titlestr isEqualToString:@"办公装修"]) {
        SQDecorationOrderVC *vc = [[SQDecorationOrderVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([titlestr isEqualToString:@"会议室预定"]) {
        MeetingOrderViewController *vc = [[MeetingOrderViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([titlestr isEqualToString:@"项目申报"]) {
        MineProjectApplyViewController *mineProjectVC = [[MineProjectApplyViewController alloc] init];
        [self.navigationController pushViewController:mineProjectVC animated:YES];
    }
    if ([titlestr isEqualToString:@"人才招聘"]) {
        MyRecruitViewController *vc = [[MyRecruitViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        _tableview = [[SQBaseTableView alloc] initWithFrame:CGRectZero];
        _tableview.rowHeight = 60;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

@end
