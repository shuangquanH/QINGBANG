//
//  LDPendingVC.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDPendingVC.h"
#import "LDPendingCell.h"//待处理cell
@interface LDPendingVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableview  */
@property (nonatomic,strong) UITableView * tableView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation LDPendingVC


- (void)viewDidLoad {
    [super viewDidLoad];
    //添加tableView
    [self.view addSubview:self.tableView];
    
    //网络请求
    [self sendRequest];
    
    self.view.backgroundColor = kBlueColor;
}
#pragma mark - 网络请求数据
- (void)sendRequest{
    
    
}

#pragma mark - tableViewDelegate And DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LDPendingCell * cell = [tableView dequeueReusableCellWithIdentifier:LDPendingCellId];
    
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
    
}
#pragma mark - cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LDLogFunc
    
}

static NSString * const LDPendingCellId = @"LDPendingCellId";
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 ) style:UITableViewStylePlain];
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LDPendingCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LDPendingCellId];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
        }
   
    return _tableView;
}


@end
