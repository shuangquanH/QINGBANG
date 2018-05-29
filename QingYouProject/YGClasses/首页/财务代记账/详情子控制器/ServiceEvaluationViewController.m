//
//  ServiceEvaluationViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ServiceEvaluationViewController.h"
#import "ServiceEvalutionModel.h"
#import "ServiceEvalutionCell.h"
#define heraderHeight           (YGScreenWidth/2+40+5)
#import <WebKit/WebKit.h>

@interface ServiceEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate>

@end

@implementation ServiceEvaluationViewController
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    UIView *_baseView;
    SDCycleScrollView *_adScrollview; //广告轮播
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)configAttribute
{

    self.view.frame = self.controllerFrame;
    _listArray = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, YGScreenHeight-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setSeparatorColor:colorWithLine];
    [_tableView registerClass:[ServiceEvalutionCell class] forCellReuseIdentifier:@"ServiceEvalutionCell"];
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self refreshActionWithIsRefreshHeaderAction:YES];
    
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [self endRefreshWithScrollView:_tableView];
//    判断父级页面是哪个
    if ([self.superVCType isEqualToString:@"netManager"])
    {
        [YGNetService YGPOST:REQUEST_NetServiceComment parameters:@{@"serviceID":self.serviceID,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
            }
 
            [_listArray addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:responseObject[@"netComment"]]];
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            if ([responseObject[@"netComment"] count] == 0) {
                [self noMoreDataFormatWithScrollView:_tableView];
            }
            [_tableView reloadData];

            
        } failure:^(NSError *error) {
            
        }];
        
    }else  if ([self.superVCType isEqualToString:@"IntegrationIndustryCommerceController"])

    {
        [YGNetService YGPOST:@"CommerceComment" parameters:@{@"commerceID":self.serviceID,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
            }
            
            [_listArray addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:responseObject[@"commerceComment"]]];
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            if ([responseObject[@"commerceComment"] count] == 0) {
                [self noMoreDataFormatWithScrollView:_tableView];
                return ;
            }
            [_tableView reloadData];
            
            
        } failure:^(NSError *error) {
            
        }];
    }
    else  if ([self.superVCType isEqualToString:@"FinancialAccountingViewController"])
        
    {
        [YGNetService YGPOST:@"FinanceComment" parameters:@{@"financeID":self.serviceID,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
            }
            
            [_listArray addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:responseObject[@"financeComment"]]];
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            if ([responseObject[@"financeComment"] count] == 0) {
                [self noMoreDataFormatWithScrollView:_tableView];
                return ;
            }
            [_tableView reloadData];
            
            
        } failure:^(NSError *error) {
            
        }];
    }
    else  if ([self.superVCType isEqualToString:@"HomePageLegal"])
        
    {
        [YGNetService YGPOST:@"LawServiceComment" parameters:@{@"serviceID":self.serviceID,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
            }
            
            [_listArray addObjectsFromArray:[ServiceEvalutionModel mj_objectArrayWithKeyValuesArray:responseObject[@"lawComment"]]];
            [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
            if ([responseObject[@"lawComment"] count] == 0) {
                [self noMoreDataFormatWithScrollView:_tableView];
                return ;
            }
            [_tableView reloadData];
            
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    [_tableView reloadData];
    
}
#pragma mark ------------tabelView相关


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"ServiceEvalutionCell" cacheByIndexPath:indexPath configuration:^(ServiceEvalutionCell *cell) {
        
        cell.fd_enforceFrameLayout = YES;
        [cell setModel:_listArray[indexPath.row]];

    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ServiceEvalutionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceEvalutionCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = colorWithYGWhite;
    cell.fd_enforceFrameLayout = YES;
    [cell setModel:_listArray[indexPath.row]];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
}

//滚动是触发代理 页面顶部除segement保留 其他都折叠
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;//偏移的y值
    [self.serviceEvaluationViewControllerDelegate scrollViewDidScrollWithHeight:yOffset];
    
}

@end
