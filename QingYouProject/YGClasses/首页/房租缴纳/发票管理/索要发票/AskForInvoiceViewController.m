//
//  AskForInvoiceViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/2.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AskForInvoiceViewController.h"
#import "HistoryPayRecoredTableViewCell.h"
#import "HistoryPayRecordModel.h"
#import "AskForInvoiceInputEmailAddressView.h"

@interface AskForInvoiceViewController ()<UITableViewDelegate,UITableViewDataSource,HistoryPayRecoredTableViewCellDelegate>

@end

@implementation AskForInvoiceViewController
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSString *_lastSectionNumber;
    NSMutableArray *_mouthArray;
    UIButton *_selectAllButton;
    UIView *_bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    [YGNetService YGPOST:REQUEST_DemandPaymentInvoice parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        if (headerAction == YES) {
            [_listArray removeAllObjects];
            _selectAllButton.selected = NO;
        }
        NSMutableArray *rootArry = [[NSMutableArray alloc]initWithArray:[HistoryPayRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"List"]]];

        if (headerAction == NO) {
            _selectAllButton.selected = NO;
        }
        //循环取出数组中的模型判断是否与上次记录的月份相同 相同的话 如果是刷新就删除数据重新添加
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        BOOL isSameAsLast = false;
        if (headerAction == NO && rootArry.count >0 && [[((HistoryPayRecordModel *)rootArry[0]) mouth] isEqualToString:_lastSectionNumber])
        {
            tempArray = [_listArray lastObject];
            isSameAsLast = true;
        }
        for (HistoryPayRecordModel *model in rootArry)
        {
            
            if (![model.mouth isEqualToString:_lastSectionNumber])
            {
                NSMutableArray *array;
                if (isSameAsLast == true) {
                    array = [[NSMutableArray alloc] initWithArray:[tempArray copy]];
                    [_listArray replaceObjectAtIndex:_listArray.count-1 withObject:array];
                    [tempArray removeAllObjects];
                    isSameAsLast = false;
                }
                if (tempArray.count != 0)
                {
                    array = [[NSMutableArray alloc] initWithArray:[tempArray copy]];
                    [_listArray addObject:array];
                }
                _lastSectionNumber = model.mouth;
                [tempArray removeAllObjects];
            }
            
            if ([model.mouth isEqualToString:_lastSectionNumber])
            {
                
                [tempArray addObject:model.copy];
                
            }
            if (model == [rootArry lastObject]  )
            {
                [_listArray addObject:tempArray];
            }
        }
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        _bottomView.hidden = NO;
        if (rootArry.count == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
            _bottomView.hidden = YES;
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)configUI
{
    self.naviTitle = @"可开票账单";
    _lastSectionNumber = @"0";
    _listArray = [[NSMutableArray alloc] init];
    _mouthArray = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45-YGBottomMargin) style:UITableViewStylePlain];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.estimatedRowHeight = 40;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[HistoryPayRecoredTableViewCell class] forCellReuseIdentifier:@"AskForInvoiceViewController"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenHeight-YGNaviBarHeight-45-YGBottomMargin-YGStatusBarHeight, YGScreenWidth, 45+YGBottomMargin)];
    _bottomView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_bottomView];
    
    _selectAllButton = [[UIButton alloc]initWithFrame:CGRectMake(10,0,70,_bottomView.height)];
    [_selectAllButton setImage:[UIImage imageNamed:@"nochoice_btn_gray"] forState:UIControlStateNormal];
    [_selectAllButton setImage:[UIImage imageNamed:@"choice_btn_green"] forState:UIControlStateSelected];
    [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_selectAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [_selectAllButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_selectAllButton addTarget:self action:@selector(selectAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectAllButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_bottomView addSubview:_selectAllButton];
    _selectAllButton.selected = NO;
    
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth/2,0,YGScreenWidth/2,_bottomView.height)];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    submitButton.backgroundColor = colorWithMainColor;
    [submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    [_bottomView addSubview:submitButton];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = _listArray[section];
    return array.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryPayRecoredTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"AskForInvoiceViewController" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    HistoryPayRecordModel *model = _listArray[indexPath.section][indexPath.row];
    [cell setModel:model withIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self.delegate takeTypeValueBackWithValue:_typeArr[indexPath.row]];
    //    [self back];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *array = _listArray[section];
    if (array.count>0) {
        return 40;
        
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HistoryPayRecordModel *model = _listArray[section][0];
    if (((NSArray *)_listArray[section]).count>0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
        view.backgroundColor = colorWithTable;
        
        UILabel *monthLabel = [[UILabel alloc]init];
        monthLabel.textColor = colorWithDeepGray;
        monthLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        monthLabel.text = model.mouth;
        monthLabel.numberOfLines = 0;
        monthLabel.frame = CGRectMake(10, 10,60, 20);
        [view addSubview:monthLabel];
        return view;
    }
    return nil;
}
#pragma 代理

- (void)selectButtonClickWithIndexPath:(NSIndexPath *)indexPath
{
    HistoryPayRecordModel *model = _listArray[indexPath.section][indexPath.row];
    model.isSelect = !model.isSelect;
}

#pragma 点击
- (void)selectAllButtonAction:(UIButton *)btn
{
    if (_listArray.count == 0) {
        [YGAppTool showToastWithText:@"没有可选账单"];
        return;
    }
    btn.selected = !btn.selected;
    for (int i = 0; i<_listArray.count; i++) {
        NSArray *array = _listArray[i];
        for (int j = 0; j<array.count; j++) {
            HistoryPayRecordModel *model = array[j];
            model.isSelect = btn.selected;
        }
    }
    [_tableView reloadData];
}

- (void)submitButtonAction:(UIButton *)btn
{
    if (_listArray.count == 0) {
        [YGAppTool showToastWithText:@"没有可选账单提交"];
        return;
    }
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    int count = 0;
    for (int i = 0; i<_listArray.count; i++) {
        NSArray *array = _listArray[i];
        for (int j = 0; j<array.count; j++) {
            HistoryPayRecordModel *model = array[j];
            if (model.isSelect == YES) {
                [ids addObject:model.id];
                count ++;
            }
        }
    }
    
    if (count == 0) {
        [YGAppTool showToastWithText:@"请选择至少一条数据开具发票"];
        return ;
    }
    NSString *idsString = [ids componentsJoinedByString:@","];
    
    HistoryPayRecordModel *model = _listArray[0][0];
    if ([model.status isEqualToString:@"1"])
    {
        [AskForInvoiceInputEmailAddressView showAlertWithTitle:model.email buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithPlaceholder,colorWithMainColor] handler:^(NSInteger buttonIndex,NSString *emailAddress) {
            
            if (buttonIndex == 1) {
                if ([YGAppTool isNotEmail:emailAddress]) {
                    return;
                }
                [YGNetService YGPOST:REQUEST_IssueInvoice parameters:@{@"ids":idsString,@"status":model.status,@"email":emailAddress} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                    [YGAlertView showAlertWithTitle:@"您的电子发票已发送到您的邮箱\n请您及时查收" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
                        [self refreshActionWithIsRefreshHeaderAction:YES];
                    }];
                } failure:^(NSError *error) {
                    
                }];
            }
        }];
    }else
    {
        [YGNetService YGPOST:REQUEST_IssueInvoice parameters:@{@"ids":idsString,@"status":model.status,@"email":@""} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            [YGAlertView showAlertWithTitle:@"您的发票已开出\n请您尽快到青网财务领取" buttonTitlesArray:@[@"确定"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
                [self refreshActionWithIsRefreshHeaderAction:YES];
            }];
        } failure:^(NSError *error) {
            
        }];
    }
  
    
    
   
}
@end
