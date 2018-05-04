//
//  MineIntergralRecordViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralRecordViewController.h"
#import "MineIntergralRecordTableViewCell.h"
#import "MineIntergralRecordModel.h"

@interface MineIntergralRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MineIntergralRecordViewController
{
    UITableView *_tableView;
    NSMutableArray *_listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)configAttribute
{
    self.naviTitle = @"青币记录";
    
    _listArray = [[NSMutableArray alloc] init];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"IntegralRecording" parameters:@{@"uid":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }

        [_listArray addObjectsFromArray:[MineIntergralRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"list1"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([(NSArray *)responseObject[@"list1"] count] < [YGPageSize integerValue])
        {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {

    }];
}
- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    [_tableView registerNib:[UINib nibWithNibName:@"MineIntergralRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineIntergralRecordTableViewCell"];
    _tableView.showsVerticalScrollIndicator = NO;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MineIntergralRecordTableViewCell class] forCellReuseIdentifier:@"MineIntergralRecordTableViewCell"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];


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
    MineIntergralRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineIntergralRecordTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MineIntergralRecordModel *model = _listArray[indexPath.row];
    [cell setModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
