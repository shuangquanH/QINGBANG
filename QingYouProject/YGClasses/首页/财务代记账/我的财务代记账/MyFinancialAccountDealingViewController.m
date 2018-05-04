//
//  MyFinancialAccountDealingViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyFinancialAccountDealingViewController.h"
#import "MyFinancialAccountTableViewCell.h"
#import "MyFinancialAccountDetailModel.h"

@interface MyFinancialAccountDealingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation MyFinancialAccountDealingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectFromString(_controllFrame);
    [self.view addSubview:self.tableView];
    //网络请求
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];

}
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
        NSDictionary *parameters = @{
                                     @"userID":YGSingletonMarco.user.userId,
                                     @"type":@"2",
                                     @"count":self.countString,
                                     @"total":self.totalString
                                     };
        NSString *url = @"FinanceOrderList";
    
        //如果不是加载过缓存
//        if (!self.isAlreadyLoadCache)
//        {
//            //加载缓存数据
//            NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//            [self.dataArray addObjectsFromArray:[MyFinancialAccountDetailModel mj_objectArrayWithKeyValuesArray:cacheDic[@"financeOrderList"]]];
//            [_tableView reloadData];
//            self.isAlreadyLoadCache = YES;
//        }
    
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
//                             //判断服务器返回的数组是不是没数据了，如果没数据
                             if ([(NSArray *)responseObject[@"financeOrderList"] count] == 0)
                             {
                                 //调用一下没数据的方法，告诉用户没有更多
                                 [self noMoreDataFormatWithScrollView:_tableView];
                                 return;
                             }
                         }
                         //将字典数组转化为模型数组，再加入到数据源
                         [self.dataArray addObjectsFromArray:[MyFinancialAccountDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"financeOrderList"]]];
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
    
    MyFinancialAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyFinancialAccountTableViewCellID forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.dataArray[indexPath.section];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 110)];
    footView.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 1)];
    line.backgroundColor = colorWithLine;
    [footView addSubview:line];
    
    MyFinancialAccountDetailModel * model = self.dataArray[section];
    NSInteger type = [model.type integerValue];
    switch (type) {
        case 2:
        {
            UILabel *processingLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, YGScreenWidth - 15, 20)];
            processingLabel.textColor = colorWithPlaceholder;
            processingLabel.font = [UIFont systemFontOfSize:14.0];
            processingLabel.text = [NSString stringWithFormat:@"您的服务正在受理中！ %@",model.beginDate];
            [footView addSubview:processingLabel];
        }
            break;
        case 5:
        {
            CGFloat LabelW = [UILabel calculateWidthWithString:@"退款原因：" textFont:leftFont numerOfLines:1].width;

            UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, line.y + LDVPadding,LabelW, 25)];
            reasonLabel.textColor = colorWithBlack;
            reasonLabel.font = [UIFont systemFontOfSize:14.0];
            reasonLabel.text = @"退款原因：";
            
            UILabel *reasonDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(reasonLabel.x +reasonLabel.width , line.y + LDVPadding, YGScreenWidth - reasonLabel.x +reasonLabel.width - 2*LDHPadding , 25)];
            reasonDetailLabel.textColor = colorWithPlaceholder;
            reasonDetailLabel.font = [UIFont systemFontOfSize:14.0];
            reasonDetailLabel.text = model.refundReason;
            [footView addSubview:reasonDetailLabel];

            UILabel *reasonTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(reasonDetailLabel.x , reasonDetailLabel.y + reasonDetailLabel.height, YGScreenWidth - reasonLabel.x +reasonLabel.width - 2*LDHPadding , 25)];
            reasonTimeLabel.textColor = colorWithPlaceholder;
            reasonTimeLabel.font = [UIFont systemFontOfSize:14.0];
            reasonTimeLabel.text = model.refundDate;
            
            
            UILabel *sateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, reasonTimeLabel.y + reasonTimeLabel.height,LabelW, 25)];
            sateLabel.textColor = colorWithBlack;
            sateLabel.font = [UIFont systemFontOfSize:14.0];
            sateLabel.text = @"申请状态：";
            
            [footView addSubview:sateLabel];
            
            UILabel *staeDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(reasonLabel.x +reasonLabel.width , reasonTimeLabel.y + reasonTimeLabel.height, YGScreenWidth - reasonLabel.x +reasonLabel.width - 2*LDHPadding , 25)];
            staeDetailLabel.textColor = colorWithPlaceholder;
            staeDetailLabel.font = [UIFont systemFontOfSize:14.0];
            staeDetailLabel.text = @"您的申请已受理，正在退款中！";
            
            UILabel *stateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(reasonDetailLabel.x , staeDetailLabel.y + staeDetailLabel.height, YGScreenWidth - reasonLabel.x +reasonLabel.width - 2*LDHPadding , 25)];
            stateTimeLabel.textColor = colorWithPlaceholder;
            stateTimeLabel.font = [UIFont systemFontOfSize:14.0];
            stateTimeLabel.text = model.refundProcessingDate;
            
            [footView addSubview:reasonTimeLabel];
            [footView addSubview:reasonLabel];
            [footView addSubview:stateTimeLabel];
            [footView addSubview:staeDetailLabel];
        }
            break;
            default:
            break;
    }
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    MyFinancialAccountDetailModel * model = self.dataArray[section];
    NSInteger type = [model.type integerValue];
    switch (type) {
        case 2:
            return 45;
        case 5:
            return 120;
        default:
            return 0;
    }

}

static NSString * const MyFinancialAccountTableViewCellID = @"MyFinancialAccountTableViewCellID";

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.estimatedRowHeight = 120;
        _tableView.rowHeight = 220;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.estimatedRowHeight =0 ;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        
        [_tableView registerNib:[UINib  nibWithNibName:NSStringFromClass([MyFinancialAccountTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MyFinancialAccountTableViewCellID];
        
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







