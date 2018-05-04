//
//  CommentViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#define heraderHeight           (YGScreenWidth/2+40+5)

@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CommentViewController
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
    NSMutableArray *_commentArray;
    UIView *_topBaseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
  
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight- 49) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"CommentTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = colorWithYGWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //设置内容偏移
    _tableView.contentInset = UIEdgeInsetsMake(heraderHeight, 0, 0, 0);
    //设置滚动条偏移
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(heraderHeight, 0, 0, 0);
    //功能按钮底部
    _topBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    _topBaseView.backgroundColor = colorWithMainColor;
    [self.view addSubview:_topBaseView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [self endRefreshWithScrollView:_tableView];
    
    _listArray = (NSMutableArray *)@[
                                     @{
                                         @"name":@"旅程米兰公馆",
                                         @"detail":@"绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大",
                                         @"img":@"http://p1.bqimg.com/567571/dc71b8a101d76dbd.png",
                                         @"comment":
                                             @[
                                                 @{
                                                     @"name":@"旅程米兰公馆",
                                                     @"detail":@"绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 ",
                                                     },
                                                 @{
                                                     @"name":@"旅程米兰公馆",
                                                     @"detail":@"绿地洋房 领略大海的魅力 ",
                                                     },
                                                 @{
                                                     @"name":@"旅程米兰公馆",
                                                     @"detail":@"绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力",
                                                     }
                                                 
                                                 ]
                                         },
                                     @{
                                         @"name":@"旅程米兰公馆",
                                         @"detail":@"绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力",
                                         @"img":@"http://p1.bqimg.com/567571/dc71b8a101d76dbd.png",
                                         @"comment":
                                             @[
                                                 @{
                                                     @"name":@"旅程米兰公馆",
                                                     @"detail":@"绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略",
                                                     },
                                                 @{
                                                     @"name":@"旅程米兰公馆",
                                                     @"detail":@"绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房",
                                                     },
                                                 @{
                                                     @"name":@"旅程米兰公馆",
                                                     @"detail":@"绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力 绿地洋房 领略大海的魅力",
                                                     }
                                                 
                                                 ]
                                         }
                                     
                                     
                                     
                                     ];
    _commentArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in _listArray) {
        [_commentArray addObject:dict[@"comment"]];
        
    }
    [_tableView reloadData];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [tableView fd_heightForCellWithIdentifier:@"CommentTableViewCell" cacheByIndexPath:indexPath configuration:^(CommentTableViewCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        [cell setDict:_commentArray[indexPath.section][indexPath.row]];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)_commentArray[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.fd_enforceFrameLayout = YES;
    [cell setDict:_commentArray[indexPath.section][indexPath.row]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [self headerViewWithData:_listArray[section]];
    return headerView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    return [self headerViewWithData:_listArray[section]];
}

- (UIView *)headerViewWithData:(NSDictionary *)dict
{
    
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    
    //左线
    UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
    leftImageView.frame = CGRectMake(10, 20, 60, 60);
    leftImageView.layer.borderColor = colorWithLine.CGColor;
    leftImageView.layer.borderWidth = 0.5;
    leftImageView.backgroundColor = colorWithMainColor;
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:leftImageView];
    
    //热门推荐label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    titleLabel.text = dict[@"name"];
    titleLabel.frame = CGRectMake(leftImageView.x+leftImageView.width+10, leftImageView.y,YGScreenWidth-100-15, 20);
    [headerView addSubview:titleLabel];
    
    
    //热门推荐label
    UILabel *describeLabel = [[UILabel alloc]init];
    describeLabel.frame = CGRectMake(titleLabel.x,titleLabel.y+titleLabel.height+5 , YGScreenWidth-100, 0);
    describeLabel.textColor = colorWithBlack;
    describeLabel.text = dict[@"detail"];
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    describeLabel.numberOfLines = 0;
    [describeLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-100];
    [headerView addSubview:describeLabel];
    
    //时间label
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.frame = CGRectMake(titleLabel.x,describeLabel.y+describeLabel.height+5 , 100, 20);
    dateLabel.textColor = colorWithDeepGray;
    dateLabel.text = @"9-20 12:17:12";
    dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    dateLabel.numberOfLines = 0;
    [dateLabel sizeToFit];
    dateLabel.frame = CGRectMake(titleLabel.x,describeLabel.y+describeLabel.height+5 , dateLabel.width, 20);
    [headerView addSubview:dateLabel];
    
    //大button
    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(dateLabel.x+dateLabel.width+10, dateLabel.y, 60, 20)];
    [coverButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setTitle:@"回复" forState:UIControlStateNormal];
    [coverButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    coverButton.contentMode = UIViewContentModeLeft;
    [headerView addSubview:coverButton];
    coverButton.centery = dateLabel.centery;
    
    headerView.frame = CGRectMake(0, 0, YGScreenWidth, (20+describeLabel.height+20+10)>60?(20+describeLabel.height+10+20+20):60);
    return headerView;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth*0.7)];
    
    UILabel *describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
    describeLabel.textColor = colorWithBlack;
    describeLabel.text = [NSString stringWithFormat:@"查看剩余%d条消息",arc4random()%100];
    describeLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [describeLabel sizeToFitHorizontal];
   
    //大button
    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, describeLabel.width+40, 40)];
    [coverButton addTarget:self action:@selector(coverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setTitle:describeLabel.text forState:UIControlStateNormal];
    [coverButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [coverButton setImage:[UIImage imageNamed:@"go_gray.png"] forState:UIControlStateNormal];
    [coverButton setImageEdgeInsets:UIEdgeInsetsMake(0, describeLabel.width, 0, 0)];
    [footerView addSubview:coverButton];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

        return 40;

}

- (void)coverButtonClick:(UIButton *)btn
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //页面没有加载的时候不进行调整
    if (!self.view.window) {
        
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //上拉加载更多（头部还没有隐藏），动态移动header
    if (offsetY >= -heraderHeight & offsetY <= 0)
    {
        _topBaseView.frame = CGRectMake(_topBaseView.x, -offsetY - heraderHeight, _topBaseView.width, _topBaseView.height);
    }else if(offsetY > 0){ //头部隐藏，固定头部位置
        
        _topBaseView.frame = CGRectMake(_topBaseView.x,  -heraderHeight, _topBaseView.width, _topBaseView.height);
    
    }else
    { //下拉刷新
        _topBaseView.frame = CGRectMake(_topBaseView.x, 0, _topBaseView.width, _topBaseView.height);
        
    }
    
}
@end
