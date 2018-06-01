//
//  SQServiceFormViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQServiceFormViewController.h"

/** 项目申报  */
#import "MineProjectApplyViewController.h"

/** 我的资金扶持  */
#import "MyFundSupportViewController.h"

/** 物业服务(室内保修)  */
#import "RepairOrderViewController.h"

/** 广告位招商  */
#import "AdvertisementLocationApplyController.h"

/** 我的人才招聘  */
#import "MyRecruitViewController.h"



@interface SQServiceFormViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray       *orderFormArr;
@property (nonatomic, strong) SQBaseTableView       *tableview;

@end

@implementation SQServiceFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"我的申请单";
    NSString *path = [[NSBundle mainBundle]pathForResource:@"SQServiceFormListPlist" ofType:@"plist"];
    self.orderFormArr = [NSArray arrayWithContentsOfFile:path];
    [self.view addSubview:self.tableview];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderFormArr.count;
}
- (UIView   *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UITableViewCell  *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQBaseTableViewCell *cell = [SQBaseTableViewCell cellWithTableView:tableView];
    cell.imageView.image = [UIImage imageNamed:@"mine_instashot"];
    cell.textLabel.text = self.orderFormArr[indexPath.section][@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self loginOrNot]) {
        return;
    }
    NSString    *titlestr = self.orderFormArr[indexPath.section][@"title"];
    
    if ([titlestr isEqualToString:@"项目申报"]) {
        MineProjectApplyViewController *mineProjectVC = [[MineProjectApplyViewController alloc] init];
        [self.navigationController pushViewController:mineProjectVC animated:YES];
    }
    
    if ([titlestr isEqualToString:@"资金扶持"]) {
        MyFundSupportViewController *vc = [[MyFundSupportViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([titlestr isEqualToString:@"物业服务"]) {
        RepairOrderViewController * repaire =[[RepairOrderViewController alloc]init];
        [self.navigationController pushViewController:repaire animated:YES];
    }
    
    if ([titlestr isEqualToString:@"广告位招商"]) {
        AdvertisementLocationApplyController * alVC= [[AdvertisementLocationApplyController alloc] init];
        [self.navigationController pushViewController:alVC animated:YES];
    }
    
    if ([titlestr isEqualToString:@"人才招聘"]) {
        MyRecruitViewController *vc = [[MyRecruitViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}


#pragma mark LazyLoad
- (SQBaseTableView  *)tableview {
    if (!_tableview) {
        _tableview = [[SQBaseTableView   alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT)];
        _tableview.rowHeight = 60;
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}


@end
