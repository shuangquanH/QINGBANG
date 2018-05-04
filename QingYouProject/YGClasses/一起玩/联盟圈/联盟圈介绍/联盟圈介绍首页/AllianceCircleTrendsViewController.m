//
//  AllianceCircleTrendsViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceCircleTrendsViewController.h"
#import "AllianceCircleTrendsCell.h"
#import "AllianceCircleTrendsModel.h"
#import "KSPhotoBrowser.h"
#import "AllianceCircleTrendsCommentDetailViewController.h"

#import "AlliancePublishTrendsViewController.h"

@interface AllianceCircleTrendsViewController ()<AllianceCircleTrendsViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,AllianceCircleTrendsCellDelegate>
{
    NSMutableArray *_listArray;
    UITableView *_tableView;
}


@end

@implementation AllianceCircleTrendsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)configAttribute
{
    self.view.frame = self.controllerFrame;
    _listArray = [[NSMutableArray alloc]init];
    [self configUI];

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

    [YGNetService YGPOST:REQUEST_getDynamic parameters:@{@"userID":YGSingletonMarco.user.userId,@"allianceID":_allianceID,@"count":self.countString,@"total":self.totalString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES)
        {
            [_listArray removeAllObjects];
        }
        if ([responseObject[@"dynamicList"] count] == 0)
        {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        [_listArray addObjectsFromArray:[AllianceCircleTrendsModel mj_objectArrayWithKeyValuesArray:responseObject[@"dynamicList"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)configUI
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-49) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = colorWithTable;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
        _tableView.separatorColor  = colorWithLine;

    for (int i = 0; i<=9; i++)
    {
        [_tableView registerClass:[AllianceCircleTrendsCell class] forCellReuseIdentifier:[YGAppTool stringValueWithInt:i]];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [self refreshActionWithIsRefreshHeaderAction:YES];
    if (@available(iOS 11.0, *)) {
        
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    if (![self.isMember isEqualToString:@"1"])
//    {
//        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,self.view.height-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
//        coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
//        [coverButton addTarget:self action:@selector(publishTrendsAction) forControlEvents:UIControlEventTouchUpInside];
//        coverButton.backgroundColor = colorWithMainColor;
//        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
//        [self addSubview:coverButton];
//        [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
//
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, self.view.height-45-YGBottomMargin) style:UITableViewStyleGrouped];
//        [coverButton setTitle:@"发动态" forState:UIControlStateNormal];
//    }
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
    AllianceCircleTrendsModel *model = _listArray[indexPath.row];
    NSString *identifier;
    
    identifier = [YGAppTool stringValueWithInt:(int)model.imgArr.count];
    
    AllianceCircleTrendsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllianceCircleTrendsModel *model = _listArray[indexPath.row];
    NSString *identifier;
    
    identifier = [YGAppTool stringValueWithInt:(int)model.imgArr.count];
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(AllianceCircleTrendsCell *cell) {
        cell.model = _listArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.isMember isEqualToString:@"1"]) {
        [YGAppTool showToastWithText:@"请先加入联盟哦~"];
        return;
    }
    AllianceCircleTrendsModel *model = _listArray[indexPath.row];
    AllianceCircleTrendsCommentDetailViewController *controller = [[AllianceCircleTrendsCommentDetailViewController alloc]init];
    controller.allianceID = _allianceID;
    controller.headerModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}


//点赞
-(void)circleTableViewCell:(AllianceCircleTrendsCell *)cell didClickGoodButtonWithModel:(AllianceCircleTrendsModel *)model goodButton:(UIButton *)button
{
    if (![self.isMember isEqualToString:@"1"]) {
        [YGAppTool showToastWithText:@"请先加入联盟哦~"];
        return;
    }
    // 点赞与取消点赞
    [YGNetService YGPOST:REQUEST_likeAllianceDynamic parameters:@{@"dynamicID":model.dynamicID,@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        button.selected = !button.isSelected;
        [button showQAnimate];
        model.isLike = [YGAppTool stringValueWithInt:button.selected];
        
        if (button.isSelected)
        {
            model.likeCount = [YGAppTool stringValueWithInt:model.likeCount.intValue + 1];
        }
        else
        {
            model.likeCount = [YGAppTool stringValueWithInt:model.likeCount.intValue - 1];
        }
        [button setTitle:model.likeCount forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        
    }];
}

//点评论
- (void)circleTableViewCell:(AllianceCircleTrendsCell *)cell didClickCommentButtonWithModel:(AllianceCircleTrendsModel *)model
{
    if (![self.isMember isEqualToString:@"1"]) {
        [YGAppTool showToastWithText:@"请先加入联盟哦~"];
        return;
    }
    AllianceCircleTrendsCommentDetailViewController *controller = [[AllianceCircleTrendsCommentDetailViewController alloc]init];
    controller.allianceID = _allianceID;
    controller.headerModel = model;
    [self.navigationController pushViewController:controller animated:YES];
}


//点图片放大
- (void)circleTableViewCell:(AllianceCircleTrendsCell *)cell didClickImageButtonWithIndex:(int)index imageButton:(UIButton *)imageButton imageArray:(NSArray *)imageArray
{
//    NSMutableArray *items = [[NSMutableArray alloc]init];
//    for (int i = 0; i < imageArray.count; i++)
//    {
//        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:(UIImageView *)imageButton imageUrl:[NSURL URLWithString:imageArray[i]]];
//        [items addObject:item];
//    }
//    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
//    browser.noSingleTap = YES;
//    browser.noSingleTap = NO;
//    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
//    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
//    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
//    [browser showFromViewController:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;//偏移的y值
    [self.allianceCircleTrendsViewControllerDelegate scrollViewDidScrollWithHeight:yOffset];
}

//- (void)publishTrendsAction
//{
// 
//    
//}
@end
