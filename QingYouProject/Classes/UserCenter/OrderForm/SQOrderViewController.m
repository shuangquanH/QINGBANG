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
#import "WKUserCenterCell.h"

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
        if ([response[@"code"] isEqualToString:@"0"]) {
            self.unreadInfo = [WKMyOrderUnreadCountModel yy_modelWithJSON:response[@"data"][@"badgeNum"]];
            [self.tableview reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)readBadgeNumberWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return self.unreadInfo.houserAudit_badgeNum;
        case 1:
            return self.unreadInfo.industrial_badgeNum;
        case 2:
            return self.unreadInfo.taxation_badgeNum;
        case 3:
            return self.unreadInfo.procurementOfOffice_badgeNum;
        case 4:
            return self.unreadInfo.decorate_badgeNum;
        case 5:
            return self.unreadInfo.meetingRoom_badgeNum;
        case 6:
            return self.unreadInfo.recruitment_badgeNum;
        case 7:
            return self.unreadInfo.projectApplication_badgeNum;
        default:
            return 0;
    }
}

- (void)badgeToZeroWithIndexPath:(NSIndexPath *)indexPath {
    WKUserCenterCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    [cell configBadgeNum:0];
    switch (indexPath.section) {
        case 0:
            self.unreadInfo.houserAudit_badgeNum = 0;
            break;
        case 1:
            self.unreadInfo.industrial_badgeNum = 0;
            break;
        case 2:
            self.unreadInfo.taxation_badgeNum = 0;
            break;
        case 3:
            self.unreadInfo.procurementOfOffice_badgeNum = 0;
            break;
        case 4:
            self.unreadInfo.decorate_badgeNum = 0;
            break;
        case 5:
            self.unreadInfo.meetingRoom_badgeNum = 0;
            break;
        case 6:
            self.unreadInfo.recruitment_badgeNum = 0;
            break;
        case 7:
            self.unreadInfo.projectApplication_badgeNum = 0;
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderFormArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.orderFormArr.count - 1) {
        return CGFLOAT_MIN;
    }
    return KSCAL(20);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WKUserCenterCell *cell = [WKUserCenterCell cellWithTableView:tableView];
    NSDictionary *dict = self.orderFormArr[indexPath.section];
    cell.userImageView.image = [UIImage imageNamed:dict[@"image"]];
    cell.titleLabel.text = dict[@"title"];
    [cell configBadgeNum:[self readBadgeNumberWithIndexPath:indexPath]];
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
    
    [self badgeToZeroWithIndexPath:indexPath];
}

#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        _tableview = [[SQBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.rowHeight = KSCAL(88);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.estimatedRowHeight = 0.0;
        _tableview.estimatedSectionFooterHeight = 0.0;
        _tableview.estimatedSectionHeaderHeight = 0.0;
        _tableview.backgroundColor = kCOLOR_RGB(239, 239, 239);
    }
    return _tableview;
}

@end
