//
//  TradeRecordViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TradeRecordViewController.h"
#import "TradeRecordCell.h"
#import "TradeRecoredModel.h"

#define heraderHeight           (YGScreenWidth/2+40+5)

@interface TradeRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TradeRecordViewController
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    NSMutableArray *_commentArray;
    UIView *_topBaseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)configAttribute
{
    self.view.frame = self.controllerFrame;
    _listArray = [[NSMutableArray alloc] init];
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[TradeRecordCell class] forCellReuseIdentifier:@"TradeRecordCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
//    判断父级页面是哪个
    if ([self.superVCType isEqualToString:@"netManager"])
    {
        [YGNetService YGPOST:REQUEST_NetServiceRecord parameters:@{@"serviceID":self.serviceID,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
            }
    
            [_listArray addObjectsFromArray:[TradeRecoredModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderRecord"]]];
            
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            if ([responseObject[@"orderRecord"] count] == 0) {
                [self noMoreDataFormatWithScrollView:_tableView];
                return ;
            }
            [_tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
      
    }else if ([self.superVCType isEqualToString:@"IntegrationIndustryCommerceController"])
    {
        [YGNetService YGPOST:@"CommerceRecord" parameters:@{@"commerceID":self.serviceID,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
            }
            
            [_listArray addObjectsFromArray:[TradeRecoredModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderRecord"]]];
            
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            if ([responseObject[@"orderRecord"] count] == 0) {
                [self noMoreDataFormatWithScrollView:_tableView];
                return ;
            }
            [_tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
    else if ([self.superVCType isEqualToString:@"FinancialAccountingViewController"])
    {
        [YGNetService YGPOST:@"FinanceRecord" parameters:@{@"financeID":self.serviceID,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
            }
            
            [_listArray addObjectsFromArray:[TradeRecoredModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderRecord"]]];
            
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            if ([responseObject[@"orderRecord"] count] == 0) {
                [self noMoreDataFormatWithScrollView:_tableView];
                return ;
            }
            [_tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
    else if ([self.superVCType isEqualToString:@"HomePageLegal"])
    {
        [YGNetService YGPOST:@"LawServiceRecord" parameters:@{@"serviceID":self.serviceID,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
            }
            
            [_listArray addObjectsFromArray:[TradeRecoredModel mj_objectArrayWithKeyValuesArray:responseObject[@"orderRecord"]]];
            
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            if ([responseObject[@"orderRecord"] count] == 0) {
                [self noMoreDataFormatWithScrollView:_tableView];
                return ;
            }
            [_tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    }
    [_tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TradeRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TradeRecordCell" forIndexPath:indexPath];
    cell.backgroundColor = colorWithYGWhite;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:_listArray[indexPath.row]];
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 70)];
    headerView.backgroundColor = colorWithYGWhite;
    UIView *headerBaseView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, YGScreenWidth-30, 40)];
    headerBaseView.backgroundColor = colorWithTable;
    [headerView addSubview:headerBaseView];
    NSArray *arr = @[@"买家",@"日期"];
    for (int i = 0; i<2; i++) {
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(headerBaseView.width/2*i,0,headerBaseView.width/2,40)];
        [coverButton setTitleColor:colorWithLightGray forState:UIControlStateNormal];
        [coverButton setTitle:arr[i] forState:UIControlStateNormal];
        [coverButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [headerBaseView addSubview:coverButton];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(headerBaseView.width/2, 0, 1, 40)];
    lineView.backgroundColor = colorWithLine;
    [headerBaseView addSubview:lineView];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}

//滚动是触发代理 页面顶部除segement保留 其他都折叠
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat yOffset = scrollView.contentOffset.y;//偏移的y值
    [self.tradeRecordViewControllerDelegate scrollViewDidScrollWithHeight:yOffset];
    
}
@end
