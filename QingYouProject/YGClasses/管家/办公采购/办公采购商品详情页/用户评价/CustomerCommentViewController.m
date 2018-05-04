//
//  CustomerCommentViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/21.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CustomerCommentViewController.h"
#import "OfficePurchaseTableViewCell.h"//评论Cell
#import "OfficePurchaseDetailModel.h"//模型

@interface CustomerCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView  */
@property (nonatomic,strong) UITableView * tableView;
/** 每个展示几个图片  */
@property (nonatomic,assign) NSInteger imageCount;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation CustomerCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.imageCount = 4;
    self.navigationItem.title = [NSString stringWithFormat:@"用户评价(%@)",self.commentCount];
    [self.view addSubview:self.tableView];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.backgroundColor = kWhiteColor;

}

//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    NSDictionary *parameters = @{
                                 @"commodityID":self.commodityID,
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"ProcurementCommentList";
    
    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        [self.dataArray addObjectsFromArray:[OfficePurchaseDetailModel mj_objectArrayWithKeyValuesArray:cacheDic[@"commentList"]]];
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
                         if ([responseObject[@"commentList"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:_tableView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                     [self.dataArray addObjectsFromArray:[OfficePurchaseDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"commentList"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:self.dataArray shouldAddToView:_tableView headerAction:headerAction];
                     [_tableView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:_tableView.frame listArray:self.dataArray];
     }];
}


- (void)refreshActionWithIsRefreshHeaderAction0:(BOOL)headerAction
{
    
    //获取全局并发队列
    dispatch_queue_t globleQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //异步任务执行时间
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    
    dispatch_after(delayTime, globleQueue, ^{
        
        //异步返回主线程，根据获取的数据，更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSMutableArray * arr = [NSMutableArray array];
            
            for (int i = 0; i < 10; i++) {
                OfficePurchaseDetailModel * model = [[OfficePurchaseDetailModel alloc] init];
                model.userName = [NSString stringWithFormat:@"%d = name",i];
                
                model.context = [NSString stringWithFormat:@"%d = comment",i];
                model.countOfArr = arc4random() % self.imageCount;
                
                [arr addObject:model];
            }
           
            
            if (headerAction) {//刷新
                
                [self.dataArray removeAllObjects];
                
            }
            
            //控制Footer状态
            if ((arr.count == 0) || (arr.count < [self.countString intValue])) {//无数据
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.dataArray addObjectsFromArray:arr];
            [self.tableView.mj_header endRefreshing];

            //刷新数据
            [self.tableView reloadData];
        });
        
    });
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LDLog(@"111")
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OfficePurchaseDetailModel * model = self.dataArray[indexPath.row];
    NSArray * imageArry;
    if(model.imgs.length >0)
       imageArry = [model.imgs componentsSeparatedByString:@","];
    NSString * reuseIdentifier = [NSString stringWithFormat:@"%ld",imageArry.count];
    
    OfficePurchaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.model = model;
    
    //cell.backgroundColor = LDRandomColor;   
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static NSString * const  OfficePurchaseTableViewCellId = @"OfficePurchaseTableViewCellId";
- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 150;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 0.01;
        _tableView.sectionFooterHeight = 0.01;

        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
        [self createRefreshWithScrollView:_tableView containFooter:NO];
        //注册cell
        for (NSInteger i = 0; i < self.imageCount; i++) {
            NSString * reuseIdentifier = [NSString stringWithFormat:@"%ld",i];
            
            [self.tableView registerClass:[OfficePurchaseTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        }
        
       
        
        if (@available(iOS 11.0, *)) {

            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;

        } else {

            self.automaticallyAdjustsScrollViewInsets = YES;

        }
        
        _tableView.backgroundColor = kWhiteColor;
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
