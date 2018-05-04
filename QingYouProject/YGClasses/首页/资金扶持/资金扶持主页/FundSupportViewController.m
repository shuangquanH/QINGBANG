//
//  FundSupportViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "FundSupportViewController.h"
#import "FundSupportTableViewCell.h"
#import "FundSupportModel.h"

#import "RoadShowHallViewController.h"
#import "CrowdFundingHallViewController.h"
#import "ServiceHallViewController.h"

@interface FundSupportViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
}

@end

@implementation FundSupportViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self loadData];
 
}

-(void)loadData
{
    [self startPostWithURLString:REQUEST_ResolvePicture parameters:@{} showLoadingView:NO scrollView:nil];
}

- (void)didReceiveSuccessResponeseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{
    NSArray *resp = @[
                      @{
                          @"title":@"您是项目发起人，需要撰写商业计划书",
                          @"keyWord":@"服务",
                          },
                      @{
                          @"title":@"您是投资人，正在寻找优质项目",
                          @"keyWord":@"众筹"
                          },
                      @{
                          @"title":@"您是创始人，您想展示您的项目",
                          @"keyWord":@"路演"
                          }
                      
                      ];
    for (int i = 0;i<resp.count;i++) {
        FundSupportModel *modle = [[FundSupportModel alloc] init];
        NSDictionary *dict = resp[i];
        modle.keyWord = dict[@"keyWord"];
        modle.title =  dict[@"title"];
        modle.picture = responseObject[[NSString stringWithFormat:@"picture%d",i+1]];
        [_listArray addObject:modle];
    }
    [_tableView reloadData];
}

- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc]init];
    self.naviTitle = @"资金扶持";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];
    
}

- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-YGBottomMargin) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[FundSupportTableViewCell class] forCellReuseIdentifier:@"FundSupportTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FundSupportModel *model = _listArray[indexPath.row];
    
    FundSupportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundSupportTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.5+40;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        switch (indexPath.row) {
            case 0:
            {
                ServiceHallViewController *controller = [[ServiceHallViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
            case 1:
            {
//                [YGNetService YGPOST:REQUEST_authentication parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                    
//                    YGSingletonMarco.user.isCertified =[responseObject[@"zhiMaXinYong"] boolValue];
                    CrowdFundingHallViewController *controller = [[CrowdFundingHallViewController alloc]init];
                    [self.navigationController pushViewController:controller animated:YES];
//                } failure:^(NSError *error) {
//
//                }];
                break;
            }
            case 2:
            {
                
                RoadShowHallViewController *controller = [[RoadShowHallViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
        }

    
    
   

}





@end
