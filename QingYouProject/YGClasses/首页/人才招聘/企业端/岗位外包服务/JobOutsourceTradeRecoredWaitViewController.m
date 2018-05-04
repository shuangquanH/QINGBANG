//
//  JobOutsourceTradeRecoredWaitViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "JobOutsourceTradeRecoredWaitViewController.h"
#import "JobOutsourceTradeRecoredTableViewCell.h"
#import "JobOutSourceRecoredModel.h"

@interface JobOutsourceTradeRecoredWaitViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    
}

@end

@implementation JobOutsourceTradeRecoredWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];

}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_MyOutsourcingApply parameters:@{@"userid":YGSingletonMarco.user.userId,@"type":@"1",@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        [_listArray addObjectsFromArray:[JobOutSourceRecoredModel mj_objectArrayWithKeyValuesArray:responseObject[@"OutsourcingApplyAuditList"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([responseObject[@"OutsourcingApplyAuditList"] count] == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)configAttribute
{
    _listArray = [[NSMutableArray alloc] init];

}
- (void)configUI
{
    self.view.frame = self.controllerFrame;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-40) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[JobOutsourceTradeRecoredTableViewCell class] forCellReuseIdentifier:@"JobOutsourceTradeRecoredTableViewCell"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
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
    JobOutsourceTradeRecoredTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"JobOutsourceTradeRecoredTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _listArray[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JobOutSourceRecoredModel *model = _listArray[section];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    lineView.backgroundColor = colorWithTable;
    [footerView addSubview:lineView];
    
    UILabel  *money = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 35)];
    money.text = [NSString stringWithFormat:@"订单号 %@",model.orderNo];
    money.textAlignment = NSTextAlignmentLeft;
    money.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    money.textColor = colorWithDeepGray;
    money.frame = CGRectMake(10,money.y , money.width,35);
    [footerView addSubview:money];
    
    return footerView;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,7,70,25)];
    [deleteButton setTitle:@"撤销申请" forState:UIControlStateNormal];
    [deleteButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deliverCurriculumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.layer.borderColor = colorWithLine.CGColor;
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.cornerRadius = 12;
    deleteButton.tag = 1000+section;
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [deleteButton sizeToFit];
    [footerView addSubview:deleteButton];
    deleteButton.frame = CGRectMake(YGScreenWidth-deleteButton.width-30,5,deleteButton.width+20,30);;
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45;
}

- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    [YGAlertView showAlertWithTitle:@"您确定要撤销这条申请吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            JobOutSourceRecoredModel *model = _listArray[btn.tag-1000];
            [YGNetService YGPOST:REQUEST_DelMyOutsourcingApply parameters:@{@"id":model.id} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
                [YGAppTool showToastWithText:@"撤销订单成功！"];
                [_listArray removeObjectAtIndex:btn.tag-1000];
                [_tableView reloadData];
            } failure:^(NSError *error) {
                
            }];
        }
    }];

}
@end
