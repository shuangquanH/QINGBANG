//
//  BreakContractBillViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BreakContractBillViewController.h"
#import "BreakContractBillTableViewCell.h"
#import "BreakContractBillModel.h"
#import "BillsDetailViewController.h"
#import "PayImmediatelyViewController.h"

@interface BreakContractBillViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BreakContractBillViewController
{
    UITableView *_tableView;
    NSMutableArray *_listArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];

}
- (void)configAttribute
{
    self.naviTitle = @"待支付账单";
    _listArray = [[NSMutableArray alloc] init];
}

- (void)loadData
{
    [self startPostWithURLString:REQUEST_HouserPayList parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber} showLoadingView:YES scrollView:nil];
}

-(void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    for (BreakContractBillModel *model in _listArray) {
        if ([model.title isEqualToString:@"房租"]) {
            model.state = responseObject[@"house"][@"state"];
            model.startTime = responseObject[@"house"][@"startTime"];
            model.endTime = responseObject[@"house"][@"endTime"];

        }
        if ([model.title isEqualToString:@"水费"]) {
            model.state = responseObject[@"water"][@"state"];
            model.startTime = responseObject[@"water"][@"startTime"];
            model.endTime = responseObject[@"water"][@"endTime"];
            
        }
        if ([model.title isEqualToString:@"电费"]) {
            model.state = responseObject[@"electricity"][@"state"];
            model.startTime = responseObject[@"electricity"][@"startTime"];
            model.endTime = responseObject[@"electricity"][@"endTime"];
            
        }
    }
    
    [_tableView reloadData];
}

- (void)didReceiveFailureResponeseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{
    
}

- (void)configUI
{
    NSArray *arr  = @[
                                      @{
                                          @"img":@"steward_chummage_icon_white",
                                          @"title":@"房租",
                                          @"startTime":@"2017-3-19",
                                          @"endTime":@"2017-9-19",
                                          @"state":@"1",
                                          @"backGroundImg":@"steward_paytherent_chummage_bj"
                                          },
                                      @{
                                          @"img":@"steward_waterrate_icon_white",
                                          @"title":@"水费",
                                          @"startTime":@"2017-3-19",
                                          @"endTime":@"2017-9-19",
                                          @"state":@"1",
                                          @"backGroundImg":@"steward_paytherent_waterrate_bj"

                                          },
                                      @{
                                          @"img":@"steward_energycharge_icon_white",
                                          @"title":@"电费",
                                          @"startTime":@"2017-3-19",
                                          @"endTime":@"2017-9-19",
                                          @"state":@"1",
                                          @"backGroundImg":@"steward_paytherent_energycharge_bj"

                                          }
                                      ];
    
    
    [_listArray addObjectsFromArray:[BreakContractBillModel mj_objectArrayWithKeyValuesArray:arr]];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[BreakContractBillTableViewCell class] forCellReuseIdentifier:@"BreakContractBillTableViewCell"];
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BreakContractBillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BreakContractBillTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _listArray[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BreakContractBillModel *model = _listArray[indexPath.section];

    if (![model.state isEqualToString:@"1"]) {
        return;
    }
    if ([model.title isEqualToString:@"水费"])
    {
        PayImmediatelyViewController *controller = [[PayImmediatelyViewController alloc] init];
        controller.type = @"2";
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if ([model.title isEqualToString:@"电费"])
    {
        PayImmediatelyViewController *controller = [[PayImmediatelyViewController alloc] init];
        controller.type = @"3";
        [self.navigationController pushViewController:controller animated:YES];
    }else
    {
        BillsDetailViewController *controller = [[BillsDetailViewController alloc] init];
        controller.pageType = @"waitToPay";
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    return view;
}

@end
