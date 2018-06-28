//
//  WaitReplyViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "WaitReplyViewController.h"
#import "WaitReplyCell.h"//待回复cell
#import "WaitReplyModel.h"//待回复model
#import "ComplaintsDetailViewController.h"//投诉详情

@interface WaitReplyViewController ()<UITableViewDelegate,UITableViewDataSource,ComplaintsDetailViewControllerDelegate,WaitReplyCellDelegate>
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation WaitReplyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)addModelToDataArray:(WaitReplyModel *) model
{
    [self.dataArray insertObject:model atIndex:0];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectFromString(_controllFrame);

    [self.view addSubview:self.tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
}

//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    
    NSDictionary *parameters = @{
                                 @"userId":YGSingletonMarco.user.userId,
                                 @"replyType":@"1",
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"SearchToReply";
    
    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        [self.dataArray addObjectsFromArray:[WaitReplyModel mj_objectArrayWithKeyValuesArray:cacheDic[@"listResp"]]];
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
                         [self.dataArray removeAllObjects];
                     }
                     //如果是加载
                     else
                     {
                         //判断服务器返回的数组是不是没数据了，如果没数据
                         if ([responseObject[@"listResp"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                     [self.dataArray addObjectsFromArray:[WaitReplyModel mj_objectArrayWithKeyValuesArray:responseObject[@"listResp"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:self.dataArray shouldAddToView:_tableView headerAction:headerAction];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:self.dataArray];
     }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView fd_heightForCellWithIdentifier:WaitReplyCellID cacheByIndexPath:indexPath configuration:^(WaitReplyCell * cell) {
        
        cell.model = self.dataArray[indexPath.row];

    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WaitReplyCell * cell = [tableView dequeueReusableCellWithIdentifier:WaitReplyCellID forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    cell.row = (int)indexPath.row;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ComplaintsDetailViewController * VC =  [[ComplaintsDetailViewController alloc] init];
    VC.complainId = ((WaitReplyModel *)self.dataArray[indexPath.row]).ID;
    VC.isPush =@"waiteReply";
    VC.delegate = self;
    VC.row = (int)indexPath.row;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)ComplaintsDetailViewControllerDelegateDeletewithrow:(int)row
{
    [self.dataArray removeObjectAtIndex:row];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
}
- (void)WaitReplyCellDelegateDeletewithrow:(int)row
{
    [YGAlertView showAlertWithTitle:@"确定要撤销投诉吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }else
        {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[@"id"] = ((WaitReplyModel *)self.dataArray[row]).ID;
            
            [YGNetService YGPOST:@"DeletComplain" parameters:dict showLoadingView:NO scrollView:nil success:^(id responseObject) {
                
                [YGAppTool showToastWithText:@"撤销成功"];
                
                [self.dataArray removeObjectAtIndex:row];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
                
            } failure:^(NSError *error) {
                [YGAppTool showToastWithText:@"撤销失败"];
            }];
            
        }
    }];
}
static NSString * const WaitReplyCellID = @"WaitReplyCellID";

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KAPP_WIDTH, self.view.height) style:UITableViewStyleGrouped];
//        _tableView.backgroundColor = kBlueColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.estimatedRowHeight = 150;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.estimatedRowHeight =0 ;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WaitReplyCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WaitReplyCellID];
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
