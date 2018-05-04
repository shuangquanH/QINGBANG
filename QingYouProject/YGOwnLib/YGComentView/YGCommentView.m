//
//  YGCommentView.m
//  zhibotest
//
//  Created by zhangkaifeng on 16/7/21.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGCommentView.h"

#import "UITableView+FDTemplateLayoutCell.h"
//#import "UITableView+FDIndexPathHeightCache.h"


@implementation YGCommentView
{
    UIView *_lastBackgroundView;
    UITableView *_tableView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    _dataSource = [[NSMutableArray alloc]init];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.sectionFooterHeight = 5;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[CommetTableViewCell class] forCellReuseIdentifier:@"xx"];
    _tableView.transform = CGAffineTransformMakeScale (1,-1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx" forIndexPath:indexPath];
    cell.fd_enforceFrameLayout = YES;
    cell.delegate = self;
    cell.realWidth = _tableView.width;
    cell.model = _dataSource[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"xx" cacheByIndexPath:indexPath configuration:^(CommetTableViewCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        cell.delegate = self;
        cell.realWidth = _tableView.width;
        cell.model = _dataSource[indexPath.section];
    }];
    
}

-(void)addWithModel:(SocketBaseModel *)model
{
    
    [_dataSource insertObject:model atIndex:0];
    [_tableView beginUpdates];
    [_tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    [_tableView endUpdates];
    if (_dataSource.count > _maxCount)
    {
        [_dataSource removeLastObject];
        [_tableView beginUpdates];
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:_dataSource.count] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
}

-(void)commetTableViewCellDidClickNameButtonWithModel:(SocketBaseModel *)model nameButton:(UIButton *)nameButton
{
    [_delegate YGCommentViewDidClickNameWithModel:model nameButton:nameButton];
    NSLog(@"%@",model.username);
}

//清理屏幕
-(void)clearCommentView
{
    [_dataSource removeAllObjects];
    [_tableView reloadData];
}

@end
