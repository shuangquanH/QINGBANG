//
//  SecondhandReplacementMyInteractionViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementMyInteractionViewController.h"
#import "SecondhandReplacementMyInteractionTableViewCell.h"
#import "SecondhandReplacementMyInteractionModel.h"
#import "BabyDetailsController.h"
#import "SecondHandPayController.h"

@interface SecondhandReplacementMyInteractionViewController ()<UITableViewDelegate,UITableViewDataSource,SecondhandReplacementMyInteractionTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray * _dataArray;
}
@end

@implementation SecondhandReplacementMyInteractionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle =@"我的互动";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStylePlain];
    [_tableView registerClass:[SecondhandReplacementMyInteractionTableViewCell class] forCellReuseIdentifier:@"SecondhandReplacementMyInteractionTableViewCell"];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _dataArray = [[NSMutableArray alloc]init];
    //网络请求
    [self createRefreshWithScrollView:_tableView containFooter:YES];
}


#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"uid":YGSingletonMarco.user.userId,
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"myInteraction";
    
    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        [_dataArray addObjectsFromArray:[SecondhandReplacementMyInteractionModel mj_objectArrayWithKeyValuesArray:cacheDic[@"rList"]]];
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
                         [_dataArray removeAllObjects];
                     }
                     //如果是加载
                     else
                     {
                         //判断服务器返回的数组是不是没数据了，如果没数据
                         if ([responseObject[@"rList"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                     [_dataArray addObjectsFromArray:[SecondhandReplacementMyInteractionModel mj_objectArrayWithKeyValuesArray:responseObject[@"rList"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:headerAction];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:_dataArray];
     }];
}

- (void)secondhandReplacementMyInteractionTableViewCellRefuseButtonButton:(UIButton *)btn withRow:(NSInteger)row
{
    [YGAlertView showAlertWithTitle:@"确认拒绝交换吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    return ;
                }else
                {
                    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                    dict[@"id"] = ((SecondhandReplacementMyInteractionModel *)_dataArray[row]).ID;
        
                    [YGNetService YGPOST:@"refuseReplace" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
                        [YGAppTool showToastWithText:@"已拒绝"];
        
                        [_dataArray removeObjectAtIndex:row];
                        [_tableView reloadData];
        
                    } failure:^(NSError *error) {
                        [YGAppTool showToastWithText:@"操作失败"];
                    }];
                }
            }];
}
- (void)secondhandReplacementMyInteractionTableViewCellAgreeButtonButton:(UIButton *)btn withRow:(NSInteger)row
{
    SecondhandReplacementMyInteractionModel *model = _dataArray[row];
    
    if([model.status isEqualToString:@"2"])
    {
        SecondHandPayController *vc = [[SecondHandPayController alloc]init];
        vc.replaceIdString = model.ID;
        vc.payType = @"2";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [YGAlertView showAlertWithTitle:@"确认同意交换吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                return ;
            }else
            {
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                dict[@"id"] = model.ID;
                
                [YGNetService YGPOST:@"agreeReplace" parameters:dict showLoadingView:YES scrollView:nil success:^(id responseObject) {
                    
//                    [YGAppTool showToastWithText:@"已同意"];
                    
//                    [_dataArray removeObjectAtIndex:row];
//                    [_tableView reloadData];
                    SecondHandPayController *vc = [[SecondHandPayController alloc]init];
                    vc.payType = @"2";
                    vc.orderNumberString = responseObject[@"order"][@"orderNum"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    
                } failure:^(NSError *error) {
                }];
            }
        }];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondhandReplacementMyInteractionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondhandReplacementMyInteractionTableViewCell" forIndexPath:indexPath];
    cell.delegate =self;
    cell.row =indexPath.row;
    cell.model = _dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"SecondhandReplacementMyInteractionTableViewCell" cacheByIndexPath:indexPath configuration:^(SecondhandReplacementMyInteractionTableViewCell *cell) {
  
        [cell setModel:_dataArray[indexPath.row]];
        
    }];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
- (void)secondhandReplacementMyInteractionTableViewCellMyGoodsDetailWithRow:(NSInteger)row
{
    BabyDetailsController *vc = [[BabyDetailsController alloc]init];
    vc.idString = [_dataArray[row] valueForKey:@"wantChange"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)secondhandReplacementMyInteractionTableViewCellOtherGoodsDetailWithRow:(NSInteger)row
{
    BabyDetailsController *vc = [[BabyDetailsController alloc]init];
    vc.idString = [_dataArray[row] valueForKey:@"tobeChange"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

