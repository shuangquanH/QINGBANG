//
//  MyFinancialAccountDealedViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyFinancialAccountDealedViewController.h"
#import "MyFinancialAccountTableViewCell.h"
#import "MyFinancialAccountDetailModel.h"
#import "IntegrationtryJudgeViewController.h"

@interface MyFinancialAccountDealedViewController ()<UITableViewDelegate,UITableViewDataSource,IntegrationtryJudgeViewControllerDelegate>

@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation MyFinancialAccountDealedViewController


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
                                     @"type":@"3",
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
        case 3:
        {
        UILabel *processingLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, LDVPadding, YGScreenWidth - 30, 20)];
        processingLabel.textColor = colorWithPlaceholder;
        processingLabel.font = [UIFont systemFontOfSize:14.0];
            processingLabel.text = [NSString stringWithFormat:@"您的服务正在受理中！ %@",model.beginDate];
        [footView addSubview:processingLabel];
        
        UILabel *processedLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,processingLabel.y+processingLabel.height +  LDVPadding, YGScreenWidth - 30, 20)];
        processedLabel.textColor = colorWithPlaceholder;
        processedLabel.font = [UIFont systemFontOfSize:14.0];
            processedLabel.text = [NSString stringWithFormat:@"您的服务已经处理完！ %@",model.endDate];
        [footView addSubview:processedLabel];
        
        
        UILabel *lineTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, processedLabel.y +processedLabel.height + LDVPadding, YGScreenWidth, 1)];
        lineTwo.backgroundColor = colorWithLine;
        [footView addSubview:lineTwo];
        
        UIButton *judgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        judgeButton.frame = CGRectMake(YGScreenWidth - 15 - 90, lineTwo.y + lineTwo.height + LDVPadding, 90, 30);
        [judgeButton setTitle:@"立即评价" forState:UIControlStateNormal];
        [judgeButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        judgeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        judgeButton.clipsToBounds = YES;
        judgeButton.layer.cornerRadius = 15;
        judgeButton.layer.borderColor = colorWithMainColor.CGColor;
        judgeButton.tag = section + 100;
        [judgeButton addTarget:self action:@selector(judgeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        judgeButton.layer.borderWidth = 1;
        
        [footView addSubview:judgeButton];
        
        UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        delButton.frame = CGRectMake(YGScreenWidth - 15 - 90*2  -10, lineTwo.y + lineTwo.height + LDVPadding, 90, 30);
        [delButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [delButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        delButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        delButton.clipsToBounds = YES;
        delButton.layer.cornerRadius = 15;
        delButton.layer.borderColor = colorWithLine.CGColor;
        delButton.tag = section + 100;
        [delButton addTarget:self action:@selector(delButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        delButton.layer.borderWidth = 1;
        [footView addSubview:delButton];
            if([model.isComment isEqualToString:@"1"])
            {
                judgeButton.hidden =YES;
                delButton.frame = CGRectMake(YGScreenWidth - 15 - 90, lineTwo.y + lineTwo.height + LDVPadding, 90, 30);
            }
        
    }
            break;
    case 6:
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
        
        UILabel *returnMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, stateTimeLabel.y + stateTimeLabel.height,LabelW, 25)];
        returnMoneyLabel.textColor = colorWithBlack;
        returnMoneyLabel.font = [UIFont systemFontOfSize:14.0];
        returnMoneyLabel.text = @"退款金额：";
        [footView addSubview:returnMoneyLabel];

        UILabel *returnMoney = [[UILabel alloc]initWithFrame:CGRectMake(reasonLabel.x +reasonLabel.width , stateTimeLabel.y + stateTimeLabel.height, YGScreenWidth - reasonLabel.x +reasonLabel.width - 2*LDHPadding , 25)];
        returnMoney.textColor = colorWithPlaceholder;
        returnMoney.font = [UIFont systemFontOfSize:14.0];
        returnMoney.text = [NSString stringWithFormat:@"¥%@",model.cost];
        
        UILabel *returnTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(reasonDetailLabel.x , returnMoney.y + returnMoney.height, YGScreenWidth - reasonLabel.x +reasonLabel.width - 2*LDHPadding , 25)];
        returnTimeLabel.textColor = colorWithPlaceholder;
        returnTimeLabel.font = [UIFont systemFontOfSize:14.0];
        returnTimeLabel.text = model.refundSuccessDate;
        
        UILabel *lineTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, returnTimeLabel.y +returnTimeLabel.height + LDVPadding, YGScreenWidth, 1)];
        lineTwo.backgroundColor = colorWithLine;
        [footView addSubview:lineTwo];
        
        UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        delButton.frame = CGRectMake(YGScreenWidth - 15 - 90, lineTwo.y + lineTwo.height + LDVPadding, 90, 30);
        [delButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [delButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        delButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        delButton.clipsToBounds = YES;
        delButton.layer.cornerRadius = 15;
        delButton.layer.borderColor = colorWithLine.CGColor;
        delButton.tag = section + 100;
        [delButton addTarget:self action:@selector(delButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        delButton.layer.borderWidth = 1;
        [footView addSubview:delButton];
 
        
        [footView addSubview:returnTimeLabel];

        [footView addSubview:returnMoney];
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
        case 3:
            return 120;
        case 6:
            return 220;
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
-(void)judgeButtonClick:(UIButton *)btn
{
    NSInteger section = btn.tag -100;
    MyFinancialAccountDetailModel * model = self.dataArray[section];
    
    IntegrationtryJudgeViewController * integrationJudge = [[IntegrationtryJudgeViewController alloc]init];
    integrationJudge.row = btn.tag -100;
    integrationJudge.delegate =self;
    integrationJudge.orderID = model.orderID;
    integrationJudge.commerceID =model.financeID;
    integrationJudge.isPush =@"MyFinancialAccountDealedViewController";
    
    [self.navigationController pushViewController:integrationJudge animated:YES];
}
- (void)integrationtryJudgeWithRow:(NSInteger )row
{
    MyFinancialAccountDetailModel * model = self.dataArray[row];
    model.isComment =@"1";
    [self.dataArray replaceObjectAtIndex:row withObject:model];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:row];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)delButtonClick:(UIButton *)btn
{
    [YGAlertView showAlertWithTitle:@"确认删除订单吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[@"orderID"] = ((MyFinancialAccountDetailModel *)self.dataArray[btn.tag -100]).orderID;
            
            [YGNetService YGPOST:@"FinanceOrderDelete" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
                
                [YGAppTool showToastWithText:@"删除成功"];
                
                NSInteger section = btn.tag -100;
                [self.dataArray removeObjectAtIndex:section];
                [_tableView reloadData];
                
            } failure:^(NSError *error) {
                [YGAppTool showToastWithText:@"删除失败"];
            }];
        }
    }];
}
@end






