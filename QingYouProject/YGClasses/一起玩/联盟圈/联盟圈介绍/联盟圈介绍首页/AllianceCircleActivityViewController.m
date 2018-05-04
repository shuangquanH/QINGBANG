//
//  AllianceCircleActivityViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceCircleActivityViewController.h"
#import "PlayTogetherCell.h"
#import "ActivityListModel.h"
#import "PlayTogetherDetailViewController.h"

@interface AllianceCircleActivityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
}

@property (nonatomic, copy) void (^loadCircleData)(void);
@property (nonatomic, copy) void (^loadVideoData)(void);

@end

@implementation AllianceCircleActivityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    
    __weak typeof (UITableView)*tableView = _tableView;
    _loadCircleData = ^{
        [tableView.mj_header beginRefreshing];
    };
}

- (void)configAttribute
{
    self.view.frame = self.controllerFrame;
    _listArray = [[NSMutableArray alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self refreshActionWithIsRefreshHeaderAction:YES];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityListModel *model = _listArray[indexPath.row];
    
    PlayTogetherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayTogetherCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PlayTogetherCell" owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = model;
//    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YGScreenWidth * 0.84;

//    AllianceCircleActivityModel *model = _listArray[indexPath.section];
//    
//    return [tableView fd_heightForCellWithIdentifier:@"PlayTogetherCell" cacheByIndexPath:indexPath configuration:^(PlayTogetherCell *cell) {
////        cell.model = _listArray[indexPath.section];
//    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityListModel *model = _listArray[indexPath.row];
    PlayTogetherDetailViewController *controller = [[PlayTogetherDetailViewController alloc]init];
    controller.activityID = model.ID;
    controller.official = model.official;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    //    NSString *userId;
    //    if (YGSingletonMarco.user)
    //    {
    //        userId = YGSingletonMarco.user.ID;
    //    }
    //    else
    //    {
    //        userId = @"";
    //    }
    [self endRefreshWithScrollView:_tableView];

    [YGNetService YGPOST:REQUEST_getAllianceActivity parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId,@"count":self.countString,@"total":self.totalString} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        if (headerAction)
        {
            [_listArray removeAllObjects];
        }
            if ([responseObject[@"list"] count] == 0)
            {
                [self noMoreDataFormatWithScrollView:_tableView];
            }
        [_listArray addObjectsFromArray:[ActivityListModel mj_objectArrayWithKeyValuesArray:responseObject[@"aList"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;//偏移的y值

    [self.allianceCircleActivityViewControllerDelegate scrollViewDidScrollWithHeight:yOffset];
}

@end
