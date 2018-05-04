//
//  JobOutsourceTradeRecoredFinishViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "JobOutsourceTradeRecoredFinishViewController.h"
#import "JobOutsourceTradeRecoredTableViewCell.h"
#import "JobOutSourceRecoredModel.h"

@interface JobOutsourceTradeRecoredFinishViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
}


@end

@implementation JobOutsourceTradeRecoredFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];

}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_MyOutsourcingApply parameters:@{@"userid":YGSingletonMarco.user.userId,@"type":@"3",@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
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
    money.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    money.textColor = colorWithDeepGray;
    [footerView addSubview:money];
    [money sizeToFit];
    money.frame = CGRectMake(10,money.y , money.width, 35);
    
    return footerView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    JobOutSourceRecoredModel *model = _listArray[section];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    footerView.backgroundColor = colorWithYGWhite;
    
    UILabel  *dealingNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
    dealingNoticeLabel.text = [NSString stringWithFormat:@"您的服务正在受理中！ %@",model.middleTime];
    dealingNoticeLabel.textAlignment = NSTextAlignmentLeft;
    dealingNoticeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    dealingNoticeLabel.textColor = colorWithDeepGray;
    [dealingNoticeLabel sizeToFit];
    dealingNoticeLabel.frame = CGRectMake(10,dealingNoticeLabel.y , dealingNoticeLabel.width, 20);
    [footerView addSubview:dealingNoticeLabel];
    
    UILabel  *finishNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,dealingNoticeLabel.y+dealingNoticeLabel.height , YGScreenWidth-20, 20)];
    finishNoticeLabel.text = [NSString stringWithFormat:@"您的服务已经处理完！ %@",model.endTime];
    finishNoticeLabel.textAlignment = NSTextAlignmentLeft;
    finishNoticeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    finishNoticeLabel.textColor = colorWithDeepGray;
    [finishNoticeLabel sizeToFit];
    finishNoticeLabel.frame = CGRectMake(10,finishNoticeLabel.y , finishNoticeLabel.width, 20);
    [footerView addSubview:finishNoticeLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithTable;
    [footerView addSubview:lineView];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,lineView.y+lineView.height+10,70,25)];
    [deleteButton setTitle:@"删除申请" forState:UIControlStateNormal];
    [deleteButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deliverCurriculumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.layer.borderColor = colorWithLine.CGColor;
    deleteButton.layer.borderWidth = 1;
    deleteButton.layer.cornerRadius = 12;
    deleteButton.tag = 10000+section;
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [deleteButton sizeToFit];
    [footerView addSubview:deleteButton];
    deleteButton.frame = CGRectMake(YGScreenWidth-deleteButton.width-30,deleteButton.y,deleteButton.width+20,25);;
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 105;
}

//删除操作
- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    [YGAlertView showAlertWithTitle:@"您确定要删除这条申请吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            JobOutSourceRecoredModel *model = _listArray[btn.tag-10000];
            [YGNetService YGPOST:REQUEST_DelMyOutsourcingApply parameters:@{@"id":model.id} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
                [YGAppTool showToastWithText:@"删除订单成功！"];
                [_listArray removeObjectAtIndex:btn.tag-10000];
                [_tableView reloadData];
            } failure:^(NSError *error) {
                
            }];
        }
    }];

}
@end
