//
//  PlayTogetherViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherViewController.h"
#import "PlayTogetherCell.h"
#import "AllianceCircleViewController.h"
#import "LXScollTitleView.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "SearchResultViewController.h"
#import "WeekendSplendorController.h"
#import "PublishActivityController.h"
#import "PlayTogetherDetailViewController.h"

#import "TobeLeaderOfAllianceViewController.h"
#import "RealNameCertifyViewController.h"
#import "ActivityListModel.h"
#import "AllianceMainViewController.h"
#import "LoginViewController.h"

#define RecordCount 3      //最多存储3条，自定义
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"SearchHistory"]
#define HEADERHEIGHT (YGScreenWidth * 0.75 + 10 + 45)

// 屏幕当前比例
#define OffWidth [UIScreen mainScreen].bounds.size.width / 375
#define OffHeight [UIScreen mainScreen].bounds.size.height / 667


@interface PlayTogetherViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
{
    UITableView *_tableView;
    UIView *_blackView; //黑色遮罩
    UILabel *_greenLabel;//菜单栏列表下面的小绿条
    NSMutableArray *_historyListArray;//历史记录array
    UIView *_headerView;  //整个的headerView
    NSMutableArray *_titlesArry; //滑动菜单数组
    UIButton *_backButton;
    UISearchBar *_searchBar;
}
@property (nonatomic, strong) NSMutableArray *dataArray;  //数据源
@property (nonatomic, strong) LXScollTitleView *topTitleView; //最上面被隐藏的滑动菜单栏
@property (nonatomic, strong) LXScollTitleView *titleView; //滑动菜单栏
@property(nonatomic,strong)UITableView *searchHistoryTableView; //搜索历史的tableView
@property (nonatomic, strong) NSMutableArray *imageArray; //图片数组
//@property (nonatomic, strong) UILabel *indicateLabel; //指示label
@property (nonatomic, strong) NewPagedFlowView *pageFlowView; //轮播图
@property (nonatomic, strong) NSString *allianceID;
@property(nonatomic,strong)NSMutableArray *activityTagArray; //活动标签数组带id
@property(nonatomic,strong)NSMutableArray *bannerListArray; //轮播图数组带id
@property(nonatomic,strong)NSString *tid;//标签id

@end

@implementation PlayTogetherViewController

-(UITableView *)searchHistoryTableView
{
    if (_searchHistoryTableView == nil) {
        _searchHistoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 200) style:UITableViewStylePlain];
    }
    return _searchHistoryTableView;
}

#pragma mark --懒加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake(0, 0, 20, 20);
    [_backButton setImage:[UIImage imageNamed:@"back_black"]  forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_backButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [_backButton sizeToFit];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(15 * OffWidth, 5, YGScreenWidth - 65 * OffWidth, YGNaviBarHeight - 10)];
    _searchBar.placeholder = @"搜索感兴趣的活动";
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.barTintColor = [UIColor whiteColor];
    // 改变UISearchBar内部输入框样式
    UIView *searchTextFieldView = nil;
    searchTextFieldView = [[[_searchBar.subviews firstObject] subviews] lastObject];
    // 改变输入框背景色
    searchTextFieldView.subviews[0].superview.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    searchTextFieldView.layer.cornerRadius = 3.0;
    [searchTextFieldView setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGNaviBarHeight)];
    UITextField *searchTextField = [_searchBar valueForKey:@"_searchField"];
    if([searchTextField isKindOfClass:UITextField.class])
    {
        searchTextField.font = [UIFont systemFontOfSize:14.0];
    }
    
    [navView addSubview:_searchBar];
    self.navigationItem.titleView = navView;
    
    _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    _blackView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    self.dataArray = [NSMutableArray array];
    self.activityTagArray = [NSMutableArray array];
    self.bannerListArray = [NSMutableArray array];
    
    [self loadData];
    
}

//请求一起玩首页数据
- (void)loadData
{
    NSLog(@"%@",YGSingletonMarco.user.userId);
    
     [YGNetService YGPOST:@"PlayIndex" parameters:@{@"userID":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
         
        self.allianceID = [responseObject valueForKey:@"allianceID"];
        
         if (self.allianceID.length) {
             YGSingletonMarco.user.allianceID = self.allianceID;
         }
        
        self.bannerListArray = [responseObject valueForKey:@"bannerList"];
        
         self.activityTagArray = responseObject[@"tagList"];
         
         self.tid = [self.activityTagArray[0] valueForKey:@"id"];
         
         [self configMainTableView];
         [self configBottomButton];
        
    } failure:^(NSError *error) {
        
    }];
}

//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"getActivityByTagId" parameters:@{@"total":self.totalString,@"userID":YGSingletonMarco.user.userId,@"count":self.countString,@"tid":self.tid} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        if (((NSArray *)responseObject[@"aList"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[ActivityListModel mj_objectArrayWithKeyValuesArray:responseObject[@"aList"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.topTitleView.frame = CGRectMake(10, 0, YGScreenWidth, 45);

}


-(void)configMainTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 0.0001;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    [self.view addSubview:_tableView];
    
    //设置内容偏移
    _tableView.contentInset = UIEdgeInsetsMake(YGScreenWidth * 0.75 + 10 + 45, 0, 0, 0);
    //设置滚动条偏移
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(YGScreenWidth * 0.75 + 10 + 45, 0, 0, 0);
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 0.75 + 10 + 45)];
    [self.view addSubview:_headerView];
    
    self.imageArray = [NSMutableArray array];
//    self.imageArray = @[@"0.jpg",@"5.jpg",@"6.jpg"].mutableCopy;
    for (int i = 0; i < self.bannerListArray.count; i++) {
        NSString *imgUrl = [self.bannerListArray[i] valueForKey:@"img"];
        [self.imageArray addObject:imgUrl];
    }
    NSLog(@"%@",self.imageArray);
    [self setScrollerView];

    _headerView.backgroundColor = colorWithTable;
    
    UIView *activityView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenWidth / 2, YGScreenWidth, YGScreenWidth * 0.25)];
    [_headerView addSubview:activityView];
    
    UIButton *weekendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weekendButton.frame = CGRectMake(0, 0, YGScreenWidth / 3, YGScreenWidth * 0.25);
    [weekendButton setTitle:@"周末" forState:UIControlStateNormal];
    [weekendButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    weekendButton.adjustsImageWhenHighlighted=NO;
    [weekendButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [weekendButton setImage:[UIImage imageNamed:@"home_yiqiwan_weekend"] forState:UIControlStateNormal];
    weekendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [weekendButton setTitleEdgeInsets:UIEdgeInsetsMake(weekendButton.imageView.frame.size.height + 10,-weekendButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [weekendButton setImageEdgeInsets:UIEdgeInsetsMake(-weekendButton.titleLabel.bounds.size.height, 0.0,0.0, -weekendButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [activityView addSubview:weekendButton];
    [weekendButton addTarget:self action:@selector(pushWeekendViewController) forControlEvents:UIControlEventTouchUpInside];
    weekendButton.backgroundColor = [UIColor whiteColor];
    
    UIButton *unionlapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unionlapButton.frame = CGRectMake(YGScreenWidth / 3, 0, YGScreenWidth / 3, YGScreenWidth * 0.25);
    [unionlapButton setTitle:@"联盟圈" forState:UIControlStateNormal];
    unionlapButton.adjustsImageWhenHighlighted=NO;
    [unionlapButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [unionlapButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [unionlapButton setImage:[UIImage imageNamed:@"home_yiqiwan_union"] forState:UIControlStateNormal];
    unionlapButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [unionlapButton setTitleEdgeInsets:UIEdgeInsetsMake(unionlapButton.imageView.frame.size.height + 10,-unionlapButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [unionlapButton setImageEdgeInsets:UIEdgeInsetsMake(-unionlapButton.titleLabel.bounds.size.height, 0.0,0.0, -unionlapButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [unionlapButton addTarget:self action:@selector(pushToAllianceCircleViewControllerAction) forControlEvents:UIControlEventTouchUpInside];
    [activityView addSubview:unionlapButton];
    unionlapButton.backgroundColor = [UIColor whiteColor];
    
    UIButton *unionerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unionerButton.frame = CGRectMake(YGScreenWidth / 3 * 2, 0, YGScreenWidth / 3, YGScreenWidth * 0.25);
    if (self.allianceID.length) {
        [unionerButton setTitle:@"联盟中心" forState:UIControlStateNormal];
    }else
    {
        [unionerButton setTitle:@"成为盟主" forState:UIControlStateNormal];
    }
    unionerButton.adjustsImageWhenHighlighted=NO;
    [unionerButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [unionerButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [unionerButton setImage:[UIImage imageNamed:@"home_yiqiwan_leader"] forState:UIControlStateNormal];
    unionerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [unionerButton setTitleEdgeInsets:UIEdgeInsetsMake(unionerButton.imageView.frame.size.height + 10,-unionerButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [unionerButton setImageEdgeInsets:UIEdgeInsetsMake(-unionerButton.titleLabel.bounds.size.height, 0.0,0.0, -unionerButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [activityView addSubview:unionerButton];
    [unionerButton addTarget:self action:@selector(pushToCreateAllianceOrAllianceCenterControllerAction:) forControlEvents:UIControlEventTouchUpInside];
    unionerButton.backgroundColor = [UIColor whiteColor];

    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
    [self configTag];
    
}

-(void)configTag
{
    _titlesArry = [NSMutableArray array];
    //    _titlesArry = @[@"精选",@"潮玩",@"运动",@"旅游",@"更多1",@"更多2"].mutableCopy;
    for (int i = 0; i < self.activityTagArray.count; i++) {
        NSString *titleString = [self.activityTagArray[i] valueForKey:@"tagName"];
        [_titlesArry addObject:titleString];
    }
    NSLog(@"%@",_titlesArry);
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, HEADERHEIGHT - 45, YGScreenWidth, 45)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:whiteView];
    
    self.titleView = [[LXScollTitleView alloc] initWithFrame:CGRectMake(10, HEADERHEIGHT - 45, YGScreenWidth, 45)];
    [_headerView addSubview:self.titleView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, HEADERHEIGHT - 1, YGScreenWidth - 20, 1)];
    lineView.backgroundColor = colorWithLine;
    [_headerView addSubview:lineView];
    
    __weak typeof(self) weakSelf = self;
    __weak UITableView *weaktableView = _tableView;
    self.titleView.selectedIndex = 0;
    self.titleView.selectedBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.topTitleView.selectedIndex = index;
        strongSelf.tid = [strongSelf.activityTagArray[index] valueForKey:@"id"];
        __weak UITableView *strongtableView = weaktableView;
        [strongtableView.mj_header beginRefreshing];
        //        [strongtableView reloadData];
    };
    self.titleView.backgroundColor = [UIColor whiteColor];
//    self.titleView.titleWidth = 80.f;
    self.titleView.normalColor = HEXCOLOR(0x7f8c9d);
    self.titleView.selectedColor = YGUIColorFromRGB(0x2dbe50, 1);
    [self.titleView reloadViewWithTitles:_titlesArry];
    
    self.topTitleView = [[LXScollTitleView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.topTitleView];
    self.topTitleView.selectedIndex = 0;
    self.topTitleView.selectedBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.titleView.selectedIndex = index;
        strongSelf.tid = [strongSelf.activityTagArray[index] valueForKey:@"id"];
        __weak UITableView *strongtableView = weaktableView;
        [strongtableView.mj_header beginRefreshing];
        //        [strongtableView reloadData];
        
    };
    self.topTitleView.backgroundColor = [UIColor whiteColor];
//    self.topTitleView.titleWidth = 80.f;
    self.topTitleView.normalColor = HEXCOLOR(0x7f8c9d);
    self.topTitleView.selectedColor = YGUIColorFromRGB(0x2dbe50, 1);
    [self.topTitleView reloadViewWithTitles:_titlesArry];
    self.topTitleView.hidden = YES;
    //    unionerButton.backgroundColor = [UIColor redColor];
    //    _tableView.tableHeaderView = headerView;
}
//卡片轮播图
- (void)setScrollerView{
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 8, YGScreenWidth, YGScreenWidth * 9 / 16 - 30)];
    pageFlowView.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.orginPageCount = self.imageArray.count;
    pageFlowView.isOpenAutoScroll = YES;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, YGScreenWidth, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    
    [_headerView addSubview:pageFlowView];
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth / 2)];
    [pageFlowView reloadData];
    [bottomScrollView addSubview:pageFlowView];
//    [self.view addSubview:bottomScrollView];
    [_headerView addSubview:bottomScrollView];
    
    self.pageFlowView = pageFlowView;
    //添加到主view上
//    [self.view addSubview:self.indicateLabel];
//    [_headerView addSubview:self.indicateLabel];
    
}

//底部悬浮按钮
-(void)configBottomButton
{
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"home_yiqiwan_add"] forState:UIControlStateNormal];
    addButton.frame = CGRectMake(YGScreenWidth - 15 - 60, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight - 20 - 60, 60, 60);
    UIPanGestureRecognizer *panTouch = [[UIPanGestureRecognizer  alloc]initWithTarget:self action:@selector(handlePan:)];
    [addButton addGestureRecognizer:panTouch];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}

//搜索历史的tableView
-(void)configSearchHistoryTableView
{
    _historyListArray = [NSMutableArray array];
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    
    self.searchHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchHistoryTableView.backgroundColor = [UIColor clearColor];
    self.searchHistoryTableView.scrollEnabled = NO;
    self.searchHistoryTableView.sectionHeaderHeight = 0.001;
    self.searchHistoryTableView.sectionFooterHeight = 0.001;
    self.searchHistoryTableView.delegate = self;
    self.searchHistoryTableView.dataSource = self;
     [_blackView addSubview:_searchHistoryTableView];
    
    //清除历史记录
    UIButton *clearHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearHistoryButton.frame = CGRectMake(0, 150, YGScreenWidth, 50);
    clearHistoryButton.backgroundColor = [UIColor whiteColor];
    [clearHistoryButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    clearHistoryButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [clearHistoryButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [clearHistoryButton addTarget:self action:@selector(clearHistoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.searchHistoryTableView.tableFooterView = clearHistoryButton;
    
}


//判断偏移量是否显示隐藏在最上面的视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //页面没有加载的时候不进行调整
    if (!self.view.window) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //上拉加载更多（头部还没有隐藏），动态移动header
    if (offsetY >= - HEADERHEIGHT & offsetY + self.topTitleView.height <= 0)
    {
        _headerView.frame = CGRectMake(_headerView.x, -offsetY - HEADERHEIGHT, _headerView.width, _headerView.height);
        self.topTitleView.hidden = YES;
    }else if(offsetY + self.topTitleView.height > 0){ //头部隐藏，固定头部位置
        
        _headerView.frame = CGRectMake(_headerView.x,  - HEADERHEIGHT, _headerView.width, _headerView.height);
        //        [UIView animateWithDuration:0.3 animations:^{
        self.topTitleView.hidden = NO;
        //        }];
    }else
    { //下拉刷新
        _headerView.frame = CGRectMake(_headerView.x, 0, _headerView.width, _headerView.height);
        self.topTitleView.hidden = YES;
        
    }
}

#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchHistoryTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            UILabel *linelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5, YGScreenWidth, 0.5)];   // 我的cell高度是90
            linelabel.backgroundColor = colorWithLine;
            [cell.contentView addSubview:linelabel];
        }
        cell.textLabel.text = _historyListArray[indexPath.row];
        return cell;
    }else
    {
        PlayTogetherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayTogetherCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PlayTogetherCell" owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchHistoryTableView)
    {
        if (_historyListArray.count == 0)
        {
            self.searchHistoryTableView.hidden = YES; // 没有历史数据时隐藏
        }
        else
        {
            self.searchHistoryTableView.tableFooterView.hidden = NO; // 有历史数据时显示
        }
        return _historyListArray.count;
    }
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchHistoryTableView)
    {
        return 50;
    }
    return YGScreenWidth * 0.84;
}

//tableView点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchHistoryTableView)
    {
        SearchResultViewController *vc = [[SearchResultViewController alloc] init];
        vc.searchString = _historyListArray[indexPath.row];
        [self addSearchRecord:_historyListArray[indexPath.row]];
        _backButton.hidden = NO;
        _searchBar.showsCancelButton = NO;
        _searchBar.text = nil;
        [_searchBar resignFirstResponder];
        [_blackView removeFromSuperview];
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        PlayTogetherDetailViewController * detail = [[PlayTogetherDetailViewController alloc]init];
        detail.official = [self.dataArray[indexPath.row] valueForKey:@"official"];
        detail.activityID = [self.dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma mark - searchBar的一些设置
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(- 20, 5, YGScreenWidth - 20, YGNaviBarHeight - 10);
    _backButton.hidden = YES;
    [self configSearchHistoryTableView];
    searchBar.showsCancelButton = YES;       //显示“取消”按钮
    for(id cc in [searchBar subviews])
    {
        for (UIView *view in [cc subviews]) {
            if ([NSStringFromClass(view.class) isEqualToString:@"UINavigationButton"])
            {
                UIButton *btn = (UIButton *)view;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
                [btn setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
            }
        }
    }
    [self.view addSubview:_blackView];
    [self.searchHistoryTableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _backButton.hidden = NO;
    searchBar.frame = CGRectMake(15 * OffWidth, 5, YGScreenWidth - 65 * OffWidth, YGNaviBarHeight - 10);
}

//searchbar的取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _backButton.hidden = NO;
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [_blackView removeFromSuperview];
}

//清除搜索历史
-(void)clearHistoryButtonClick:(UIButton *)button
{
    [self clearAllSearchHistory];
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    [self.searchHistoryTableView reloadData];
    
}
//搜索键盘上的搜索按钮点击响应事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    SearchResultViewController *vc = [[SearchResultViewController alloc] init];
    vc.searchString = searchBar.text;
    [self addSearchRecord:searchBar.text];
    _backButton.hidden = NO;
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [_blackView removeFromSuperview];
   
    [self.navigationController pushViewController:vc animated:YES];
    
}
//增加搜索记录
- (void)addSearchRecord:(NSString *)searchStr
{
    NSMutableArray *searchArray = [[NSMutableArray alloc]initWithArray:SEARCH_HISTORY];
    if (searchArray == nil) {
        searchArray = [[NSMutableArray alloc]init];
    } else if ([searchArray containsObject:searchStr]) {
        [searchArray removeObject:searchStr];
    } else if ([searchArray count] >= RecordCount) {
        [searchArray removeObjectsInRange:NSMakeRange(RecordCount - 1, [searchArray count] - RecordCount + 1)];
    }
    [searchArray insertObject:searchStr atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:searchArray forKey:@"SearchHistory"];
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    [self.searchHistoryTableView reloadData];
}
//读取所有历史记录
- (NSArray *)getAllSearchHistory
{
    return SEARCH_HISTORY;
}
//删除所有历史记录
- (void)clearAllSearchHistory
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc]init] forKey:@"SearchHistory"];
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView
{
    return CGSizeMake(YGScreenWidth - 40, (YGScreenWidth - 40) * 9 / 16 - 30);
}
//点击了第几个cell
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
//    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)subIndex + 1];
    
    PlayTogetherDetailViewController * detail = [[PlayTogetherDetailViewController alloc]init];
    detail.official = [self.bannerListArray[subIndex] valueForKey:@"official"];
    detail.activityID = [self.bannerListArray[subIndex] valueForKey:@"activityID"];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark NewPagedFlowView Datasource
//返回显示view的个数
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
}

//给某一列设置属性
- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 9 / 16 - 30)];
    }
    
    //在这里下载网络图片
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[index]] placeholderImage:YGDefaultImgTwo_One];
//    bannerView.mainImageView.image = [UIImage imageNamed:self.imageArray[index]];
    bannerView.layer.cornerRadius = 6;
    bannerView.layer.masksToBounds = YES;
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"TestViewController 滚动到了第%ld页",pageNumber);
}
- (void)dealloc {
    
    /****************************
     在dealloc或者返回按钮里停止定时器
     ****************************/
    
    [self.pageFlowView stopTimer];
}


//进入联盟圈界面
- (void)pushToAllianceCircleViewControllerAction
{
    AllianceCircleViewController *allianceCircleViewController = [[AllianceCircleViewController alloc] init];
    [self.navigationController pushViewController:allianceCircleViewController animated:YES];
}
//进入周末精彩界面
-(void)pushWeekendViewController
{
    WeekendSplendorController *wsVC = [[WeekendSplendorController alloc] init];
    [self.navigationController pushViewController:wsVC animated:YES];
}
//悬浮按钮拖动手指移动
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //视图前置操作
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    
    CGPoint center = recognizer.view.center;
    CGFloat cornerRadius = recognizer.view.frame.size.width / 2;
    CGPoint translation = [recognizer translationInView:self.view];
    //NSLog(@"%@", NSStringFromCGPoint(translation));
    recognizer.view.center = CGPointMake(center.x + translation.x, center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        //计算速度向量的长度，当他小于200时，滑行会很短
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        //NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult); //e.g. 397.973175, slideMult: 1.989866
        
        //基于速度和速度因素计算一个终点
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(center.x + (velocity.x * slideFactor),
                                         center.y + (velocity.y * slideFactor));
        //限制最小［cornerRadius］和最大边界值［self.view.bounds.size.width - cornerRadius］，以免拖动出屏幕界限
        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
                           self.view.bounds.size.width - cornerRadius);
        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
                           self.view.bounds.size.height - cornerRadius);
        
        //使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration:slideFactor*2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             recognizer.view.center = finalPoint;
                         }
                         completion:nil];
    }
}

//发布活动
-(void)addButtonClick:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    [YGNetService YGPOST:REQUEST_isManager parameters:@{@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        button.userInteractionEnabled = YES;
        if ([responseObject[@"isManager"] isEqualToString:@"1"]) {
            [YGAlertView showAlertWithTitle:@"对不起,您还没有权限发布活动,请先成为盟主!" buttonTitlesArray:@[@"成为盟主"] buttonColorsArray:@[colorWithMainColor] handler:^(NSInteger buttonIndex) {
                [YGNetService YGPOST:REQUEST_authentication parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                    YGSingletonMarco.user.isCertified =[responseObject[@"zhiMaXinYong"] boolValue];
                    if (YGSingletonMarco.user.isCertified == NO) {
                        RealNameCertifyViewController *controller = [[RealNameCertifyViewController alloc]init];
                        controller.createFieldsType = @"createAllaince";
                        controller.pageType = @"createAllaince";
                        [self.navigationController pushViewController:controller animated:YES];
                    }else
                    {
#pragma 认证状态提取完再从服务请求是否已填写联盟申请
                        TobeLeaderOfAllianceViewController *controller = [[TobeLeaderOfAllianceViewController alloc]init];
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                    
                } failure:^(NSError *error) {
                }];
                
            }];
        }else if([responseObject[@"isManager"] isEqualToString:@"0"])
        {
            PublishActivityController *vc = [[PublishActivityController alloc]init];
            vc.allianceID = responseObject[@"allianceID"];
            [self.navigationController pushViewController:vc animated:YES];

        }else
        {
            [YGAppTool showToastWithText:@"您的联盟圈申请在审核中。。请耐心等待！"];
        }
        
        
    } failure:^(NSError *error) {
        button.userInteractionEnabled = YES;
    }];
}

- (void)pushToCreateAllianceOrAllianceCenterControllerAction:(UIButton *)btn
{
    if (![self loginOrNot])
    {
        return;
    }
    btn.userInteractionEnabled = NO;
    [YGNetService YGPOST:REQUEST_isManager parameters:@{@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        btn.userInteractionEnabled = YES;
        if ([responseObject[@"isManager"] isEqualToString:@"1"]) {
            
            [YGAlertView showAlertWithTitle:@"您还不是盟主哦！" buttonTitlesArray:@[@"立即申请",@"先看看"] buttonColorsArray:@[colorWithMainColor,colorWithPlaceholder] handler:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    return ;
                }
                [YGNetService YGPOST:REQUEST_authentication parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                    YGSingletonMarco.user.isCertified =[responseObject[@"zhiMaXinYong"] boolValue];
                    if (YGSingletonMarco.user.isCertified == NO) {
                        RealNameCertifyViewController *controller = [[RealNameCertifyViewController alloc]init];
                        controller.createFieldsType = @"createAllaince";
                        controller.pageType = @"createAllaince";
                        [self.navigationController pushViewController:controller animated:YES];
                    }else
                    {
#pragma 认证状态提取完再从服务请求是否已填写联盟申请
                        TobeLeaderOfAllianceViewController *controller = [[TobeLeaderOfAllianceViewController alloc]init];
                        [self.navigationController pushViewController:controller animated:YES];
                    }

                } failure:^(NSError *error) {
                    btn.userInteractionEnabled = YES;

                }];
                
            }];
        }else if([responseObject[@"isManager"] isEqualToString:@"0"])
        {
            AllianceMainViewController *mainVc = [[AllianceMainViewController alloc] init];
            mainVc.allianceID = responseObject[@"allianceID"];
            [self.navigationController pushViewController:mainVc animated:YES];
        }else
        {
            [YGAppTool showToastWithText:@"您的联盟圈申请在审核中。。请耐心等待！"];
        }

        
    } failure:^(NSError *error) {
        btn.userInteractionEnabled = YES;

    }];
}
@end
