//
//  WaitToNetManagerViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WaitToNetManagerViewController.h"
#import "WaitToNetManagerTableViewCell.h"
#import "WaitToNetManagerModel.h"

@interface WaitToNetManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) UIImageView * safeguardImage;
@property (nonatomic,strong) UIView * headerView;

@property (nonatomic,strong) UILabel * safeguardi;
@property (nonatomic,strong) UIImageView * safeImage;
@property (nonatomic,strong) UILabel * orderNumberLabel;


@end

@implementation WaitToNetManagerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectFromString(_controllFrame);
    [self.view addSubview:self.tableView];
    //网络请求
    [self createRefreshWithScrollView:_tableView containFooter:YES];
}
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"userID":YGSingletonMarco.user.userId,
                                 @"type":@"1",
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    
    NSString *url = @"NetOrder";
    if([self.pushView isEqualToString:@"isVIP"])
         url = @"NetVIPOrder";
    
//    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        if([self.pushView isEqualToString:@"isVIP"])
//            [self.dataArray addObjectsFromArray:[WaitToNetManagerModel mj_objectArrayWithKeyValuesArray:cacheDic[@"netVipOrder"]]];
//        else
//            [self.dataArray addObjectsFromArray:[WaitToNetManagerModel mj_objectArrayWithKeyValuesArray:cacheDic[@"orderList"]]];
//        [_tableView reloadData];
//        self.isAlreadyLoadCache = YES;
//    }
    
    [YGNetService YGPOST:url
              parameters:parameters
         showLoadingView:NO
              scrollView:_tableView
                 success:^( id responseObject) {
                     
                     //如果是刷新
                     if (headerAction)
                     {
                         //先移除数据源所有数据
                         [self.dataArray removeAllObjects];
                     }
                     //如果是加载
                     else
                     {
                         if([self.pushView isEqualToString:@"isVIP"])
                         {
                             //判断服务器返回的数组是不是没数据了，如果没数据
                             if ([responseObject[@"netVipOrder"] count] == 0)
                             {
                                 //调用一下没数据的方法，告诉用户没有更多
                                 [self noMoreDataFormatWithScrollView:_tableView];
                                 return;
                             }
                         }
                         else
                         {
                             //判断服务器返回的数组是不是没数据了，如果没数据
                             if ([responseObject[@"orderList"] count] == 0)
                             {
                                 //调用一下没数据的方法，告诉用户没有更多
                                 [self noMoreDataFormatWithScrollView:_tableView];
                                 return;
                             }
                         }
                   
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                     if([self.pushView isEqualToString:@"isVIP"])
                         [self.dataArray addObjectsFromArray:[WaitToNetManagerModel mj_objectArrayWithKeyValuesArray:responseObject[@"netVipOrder"]]];
                     else
                         [self.dataArray addObjectsFromArray:[WaitToNetManagerModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderList"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:self.dataArray shouldAddToView:_tableView headerAction:headerAction];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:self.dataArray];
     }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WaitToNetManagerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:WaitToNetManagerTableViewCellID forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.dataArray[indexPath.section];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return [tableView fd_heightForCellWithIdentifier:WaitToNetManagerTableViewCellID                    cacheByIndexPath:indexPath configuration:^(WaitToNetManagerTableViewCell *cell) {
         cell.model = self.dataArray[indexPath.section];
        }];;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WaitToNetManagerModel * model = self.dataArray[section];
    
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 5)];
    lineLabel.backgroundColor = colorWithTable;
    self.headerView.backgroundColor =[UIColor whiteColor];
    [self.headerView addSubview:lineLabel];
    
    self.safeguardi = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 20, 20)];
    self.safeguardi.text = model.serviceName;
    if([self.pushView isEqualToString:@"isVIP"])
        self.safeguardi.text = model.VIPType;

    CGSize size = [self.safeguardi.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:leftFont,NSFontAttributeName,nil]];
    self.safeguardi.frame = CGRectMake(YGScreenWidth - size.width - LDHPadding, 5, size.width, 40);
    self.safeguardi.font = leftFont;
    self.safeguardi.textColor = colorWithMainColor;
    [self.headerView addSubview:self.safeguardi];
    
    self.safeImage=[[UIImageView alloc]initWithFrame:CGRectMake(YGScreenWidth -size.width - 2*LDHPadding  - 14, (40 - 14)/2 + 5, 14, 14)];
    [self.headerView addSubview:self.safeImage];
    
    self.safeImage.image = [UIImage imageNamed:@"mine_network_computer_green"];
    if([self.pushView isEqualToString:@"isVIP"])
        self.safeImage.image = [UIImage imageNamed:@"mine_network_gem_green"];

    self.orderNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(LDHPadding, 5, YGScreenWidth - LDHPadding *4 - size.width - self.safeImage.width, 40)];
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号 %@",model.number];
    [self.headerView addSubview:self.orderNumberLabel];
    self.orderNumberLabel.font = LD13Font;
    self.orderNumberLabel.textColor = colorWithLightGray;
    
    UILabel * lineTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, self.headerView.height -1, YGScreenWidth, 1)];
    lineTwo.backgroundColor = colorWithTable;
    [self.headerView addSubview:lineTwo];
    
    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
//删除订单

static NSString * const WaitToNetManagerTableViewCellID = @"WaitToNetManagerTableViewCellID";

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight = 220;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.estimatedRowHeight =0 ;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        
        [_tableView registerNib:[UINib  nibWithNibName:NSStringFromClass([WaitToNetManagerTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WaitToNetManagerTableViewCellID];
        
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

@end


