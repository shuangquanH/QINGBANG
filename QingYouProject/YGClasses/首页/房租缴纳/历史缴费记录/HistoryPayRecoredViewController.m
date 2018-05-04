//
//  HistoryPayRecoredViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "HistoryPayRecoredViewController.h"
#import "HistoryPayRecoredTableViewCell.h"
#import "HistoryPayRecordModel.h"
#import "MyHouseRentPayDetailViewController.h"

@interface HistoryPayRecoredViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HistoryPayRecoredViewController
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSString *_lastSectionNumber;
    NSMutableArray *_mouthArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    [YGNetService YGPOST:REQUEST_PaymentRecordss parameters:@{@"phone":YGSingletonMarco.user.myContractPhoneNumber,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {

        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        NSMutableArray *rootArry = [[NSMutableArray alloc]initWithArray:[HistoryPayRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"List"]]];

        //循环取出数组中的模型判断是否与上次记录的月份相同 相同的话 如果是刷新就删除数据重新添加
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        BOOL isSameAsLast = false;
        if (headerAction == NO && rootArry.count >0 && [[((HistoryPayRecordModel *)rootArry[0]) mouth] isEqualToString:_lastSectionNumber])
        {
            tempArray = [_listArray lastObject];
            isSameAsLast = true;
        }
//        [_listArray removeAllObjects];
//        NSMutableArray *totalArray = [[NSMutableArray alloc] init];
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
            if (model == [rootArry lastObject])
            {
                if (_listArray.count == 1 && headerAction == NO) {
                    [_listArray removeAllObjects];
                }
                [_listArray addObject:tempArray];
                break;
            }
        }
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if (rootArry.count == 0) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)configUI
{
    self.naviTitle = @"历史缴费账单";
    _lastSectionNumber = @"0";
    _listArray = [[NSMutableArray alloc] init];
    _mouthArray = [[NSMutableArray alloc] init];
    
//    for (int i = 1; i<13; i++) {
//        NSMutableArray *array = [[NSMutableArray alloc]init];
//        [_listArray addObject:array];
//
//    }
 
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.estimatedRowHeight = 40;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[HistoryPayRecoredTableViewCell class] forCellReuseIdentifier:@"HistoryPayRecoredTableViewCell"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
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
    HistoryPayRecoredTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryPayRecoredTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellType = @"cell";
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
    HistoryPayRecordModel *model = _listArray[indexPath.section][indexPath.row];
    MyHouseRentPayDetailViewController *controller = [[MyHouseRentPayDetailViewController alloc] init];
    controller.itemID = model.id;
    [self.navigationController pushViewController:controller animated:YES];
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

@end
