//
//  DecorationOrderDetailsController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "DecorationOrderDetailsController.h"
#import "DecorationOrderDetailCell.h"
#import "QuotePlanViewController.h"

@interface DecorationOrderDetailsController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titleArray;
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation DecorationOrderDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"订单信息详情";
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, 0, 80, 35);
    [submitButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [submitButton setTitle:@"报价方案" forState:normal];
    submitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [submitButton addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _dataArray = [NSMutableArray array];
    _titleArray = [NSArray arrayWithObjects:@"订单编号:",@"合同编号:",@"合同报价:",@"期   数:",@"发包方:",@"发包方联系人:",@"发包方联系方式:",@"承包方:",@"承包方联系人:",@"承包方联系方式:",@"合同备注:", nil];
    [self configUI];
    
    [self loadData];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
   [_tableView registerNib:[UINib nibWithNibName:@"DecorationOrderDetailCell" bundle:nil] forCellReuseIdentifier:@"DecorationOrderDetailCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 35;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)loadData
{
    [YGNetService YGPOST:@"MyOrderDecorationDetail" parameters:@{@"id":self.orderIdString} showLoadingView:NO scrollView:_tableView success:^(id responseObject){
        
        NSLog(@"%@",responseObject);
        NSDictionary *resuleDic = [responseObject valueForKey:@"fitmentOrder"];
        
        [_dataArray addObject:[resuleDic valueForKey:@"orderNum"]]; //订单编号
        [_dataArray addObject:[resuleDic valueForKey:@"contractNum"]]; //合同编号
        [_dataArray addObject:[NSString stringWithFormat:@"%@万元",[resuleDic valueForKey:@"contractPrice"]]]; //合同报价
        [_dataArray addObject:[NSString stringWithFormat:@"%@",@"3期"]]; //期款
        [_dataArray addObject:[resuleDic valueForKey:@"employer"]]; //发包方
        [_dataArray addObject:[resuleDic valueForKey:@"employerLinkman"]]; //发包方联系人
        [_dataArray addObject:[resuleDic valueForKey:@"employerPhone"]]; //发包方联系方式
        [_dataArray addObject:[resuleDic valueForKey:@"contractor"]]; //承包方
        [_dataArray addObject:[resuleDic valueForKey:@"contractorLinkman"]]; //承包方联系人
        [_dataArray addObject:[resuleDic valueForKey:@"contractorPhone"]]; //承包方联系方式
        [_dataArray addObject:[resuleDic valueForKey:@"remarks"]]; //合同备注
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DecorationOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DecorationOrderDetailCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = _titleArray[indexPath.row];
    if (_dataArray.count) {
        cell.dataLabel.text = _dataArray[indexPath.row];
    }
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
    if (indexPath.row == 10) {
        if (_dataArray.count) {
            NSString *remarkString = _dataArray[10];
            if(remarkString.length)
            {
                if([tableView fd_heightForCellWithIdentifier:@"DecorationOrderDetailCell" cacheByIndexPath:indexPath configuration:^(DecorationOrderDetailCell *cell) {
                    cell.dataLabel.text = remarkString;
                }] < 35)
                {
                    return 35;
                }else
                {
                    return [tableView fd_heightForCellWithIdentifier:@"DecorationOrderDetailCell" cacheByIndexPath:indexPath configuration:^(DecorationOrderDetailCell *cell) {
                        cell.dataLabel.text = remarkString;
                    }];
                }
            }
        }
    }
    return 35;
}
-(void)submitInfo:(UIButton *)button
{
    [YGNetService YGPOST:@"getOrderText" parameters:@{@"id":self.orderIdString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        QuotePlanViewController *vc = [[QuotePlanViewController alloc]init];
        vc.contentUrl = [responseObject valueForKey:@"text"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
