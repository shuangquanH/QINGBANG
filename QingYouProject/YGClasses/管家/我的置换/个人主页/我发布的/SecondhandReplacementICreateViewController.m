//
//  SecondhandReplacementICreateViewController.m
//  QingYouProject
//
//  Created by apple on 2017/12/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondhandReplacementICreateViewController.h"
#import "SecondhandReplacementICreateTableViewCell.h"
#import "SecondhandReplacementICreateModel.h"
#import "YGVerticalAlertView.h"
#import "BabyDetailsController.h"
#import "SeccondHandExchangePublishViewController.h"

@interface SecondhandReplacementICreateViewController ()<UITableViewDelegate,UITableViewDataSource,SecondhandReplacementICreateTableViewCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray * _dataArray;
}

@end

@implementation SecondhandReplacementICreateViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"我发布的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray = [[NSMutableArray alloc]init];
    [self.view addSubview:self.tableView];
    //网络请求
        [self createRefreshWithScrollView:_tableView containFooter:YES];
}

#pragma mark - 网络请求
//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"userId":YGSingletonMarco.user.userId,
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"MyPsted";
    
    //如果不是加载过缓存
    if (!self.isAlreadyLoadCache)
    {
        //加载缓存数据
        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
        [_dataArray addObjectsFromArray:[SecondhandReplacementICreateModel mj_objectArrayWithKeyValuesArray:cacheDic[@"merchandise"]]];
        [_tableView reloadData];
        self.isAlreadyLoadCache = YES;
    }
    
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
                         if ([responseObject[@"merchandise"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                  [_dataArray addObjectsFromArray:[SecondhandReplacementICreateModel mj_objectArrayWithKeyValuesArray:responseObject[@"merchandise"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:headerAction];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:_dataArray];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SecondhandReplacementICreateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SecondhandReplacementICreateTableViewCellID];
    cell.row = indexPath.row;
    cell.delegate = self;
    [cell setModel:(SecondhandReplacementICreateModel *)_dataArray[indexPath.row]];
    return cell;
}
- (void)secondhandReplacementICreateTableViewCellPlatformButton:(UIButton *)btn withRow:(NSInteger)row
{
    NSDictionary *parameters = @{
                                 @"id":((SecondhandReplacementICreateModel *)_dataArray[row]).ID,
                                 };
    [YGNetService YGPOST:@"Reclaim" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
        NSString * bottomMargin = responseObject[@"bottomMargin"];
        
        //重新申请
       if([((SecondhandReplacementICreateModel *)_dataArray[row]).bottomStatus isEqualToString:@"3"])
       {
           [YGAlertView showAlertWithTitle:[NSString stringWithFormat:@"%@",responseObject[@"douDi"]] buttonTitlesArray:@[@"放弃",@"申请"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
               if (buttonIndex == 0) {
                   return ;
               }else
               {
                   NSDictionary *parameters = @{
                                                @"id":((SecondhandReplacementICreateModel *)_dataArray[row]).ID,
                                                @"type":@"3"
                                                };
                   [YGNetService YGPOST:@"dealDozen" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
                       
                       [YGAppTool showToastWithText:@"申请成功"];
                       
                   } failure:^(NSError *error) {
                       
                   }];
               }
           }];
       }
        else if (bottomMargin.length)//可以查看详情
        {
            [YGVerticalAlertView showAlertWithTitle:[NSString stringWithFormat:@"%@",responseObject[@"douDi"]] buttonTitlesArray:@[@"同意",@"查看",@"拒绝"] buttonColorsArray:@[colorWithMainColor,colorWithBlack,colorWithBlack] handler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    NSDictionary *parameters = @{
                                                 @"id":((SecondhandReplacementICreateModel *)_dataArray[row]).ID,
                                                 @"type":@"1"
                                                 };
                    [YGNetService YGPOST:@"dealDozen" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
                        
                        [YGAppTool showToastWithText:@"已同意"];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }else if (buttonIndex == 1) {
                    BabyDetailsController *vc = [[BabyDetailsController alloc]init];
                    vc.idString = responseObject[@"bottomMargin"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    NSDictionary *parameters = @{
                                                 @"id":((SecondhandReplacementICreateModel *)_dataArray[row]).ID,
                                                 @"type":@"2"
                                                 };
                    [YGNetService YGPOST:@"dealDozen" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
                        
                        [YGAppTool showToastWithText:@"已拒绝"];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }];
        }
        else if (((SecondhandReplacementICreateModel *)_dataArray[row]).bottomStatus.length)
        {
            [YGAlertView showAlertWithTitle:[NSString stringWithFormat:@"%@",responseObject[@"douDi"]] buttonTitlesArray:@[@"拒绝",@"同意"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    NSDictionary *parameters = @{
                                                 @"id":((SecondhandReplacementICreateModel *)_dataArray[row]).ID,
                                                 @"type":@"2"
                                                 };
                    [YGNetService YGPOST:@"dealDozen" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
                        
                        [YGAppTool showToastWithText:@"已拒绝"];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }else
                {
                    NSDictionary *parameters = @{
                                                 @"id":((SecondhandReplacementICreateModel *)_dataArray[row]).ID,
                                                 @"type":@"1"
                                                 };
                    [YGNetService YGPOST:@"dealDozen" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
                        
                        [YGAppTool showToastWithText:@"已同意"];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
            }];
        }
        
    } failure:^(NSError *error) {
      
    }];
}
- (void)secondhandReplacementICreateTableViewCellEditBtn:(UIButton *)btn withRow:(NSInteger)row
{
    SeccondHandExchangePublishViewController * publishView = [[SeccondHandExchangePublishViewController alloc]init];
    publishView.pageType =@"SecondhandReplacementICreateViewController";
    publishView.editModel = ((SecondhandReplacementICreateModel *)_dataArray[row]);
    [self.navigationController pushViewController:publishView animated:YES];
}
- (void)secondhandReplacementICreateTableViewCellDeleteBtn:(UIButton *)btn withRow:(NSInteger)row
{
    [YGAlertView showAlertWithTitle:@"确定删除商品吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSDictionary *parameters = @{
                                         @"id":((SecondhandReplacementICreateModel *)_dataArray[row]).ID,
                                         };
            [YGNetService YGPOST:@"DeleteGoods" parameters:parameters showLoadingView:YES scrollView:nil success:^(id responseObject) {
                
                [YGAppTool showToastWithText:@"已删除"];
                [_dataArray removeObjectAtIndex:row];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}

static NSString * const SecondhandReplacementICreateTableViewCellID = @"SecondhandReplacementICreateTableViewCellID";

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat H = kScreenH - YGNaviBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 90;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        [_tableView setSeparatorColor:colorWithLine];
        [_tableView registerClass:[SecondhandReplacementICreateTableViewCell class] forCellReuseIdentifier:SecondhandReplacementICreateTableViewCellID];
    }
    return _tableView;
}

@end









