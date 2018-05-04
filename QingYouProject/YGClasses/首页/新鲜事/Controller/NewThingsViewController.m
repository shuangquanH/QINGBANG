//
//  NewThingsViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "NewThingsViewController.h"
#import "RecommendNewsViewController.h"
#import "LXScollTitleView.h"
#import "LXScrollContentView.h"
#import "LXScollTitleView.h"//点击切换视图View
#import "SearchTitleAndTextCell.h"
#import "NewThingsDetailController.h"
#import "NewThingsModel.h"
#import "SearchNewThingsViewController.h"

#define RecordCount 3      //最多存储3条，自定义
#define NEWS_SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"NewsSearchHistory"]


@interface NewThingsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UIView *_blackView; //黑色遮罩
    NSMutableArray *_historyListArray;//历史记录array
    UIButton *_backButton;
    NSMutableArray    *_typeArr;          //类型数组
    NSMutableArray    *_titleArr;          //类型数组
    UIView      *_condationBaseView;
}
@property (nonatomic, strong) LXScollTitleView *titleView;
@property (nonatomic, strong) LXScrollContentView *contentView;
@property (nonatomic, strong) UIView *titleMenuView;
@property(nonatomic,strong)UITableView *searchHistoryTableView; //搜索历史的tableView
@property(nonatomic,strong)UISearchBar *searchBar; //导航栏上面的搜索条
@property(nonatomic,strong)NSMutableArray *searchMutableArray; //搜索结果数组
@end

@implementation NewThingsViewController

-(UITableView *)searchHistoryTableView
{
    if (_searchHistoryTableView == nil) {
        _searchHistoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStylePlain];
    }
    return _searchHistoryTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)configAttribute
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configSearchBar];
//    _dataSource = [[NSMutableArray alloc] init];
    self.view.backgroundColor = colorWithYGWhite;
    _typeArr = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];
    
}
- (void)addNetCondiationView
{
    _condationBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth-40 , YGScreenWidth-64)];
    _condationBaseView.centery = self.view.center.y-64;
    _condationBaseView.centerx = self.view.center.x;
    [self.view addSubview:_condationBaseView];
    
    UIButton *condationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    condationBtn.frame = CGRectMake(0,90, 60, 20);
    [condationBtn setBackgroundImage:[UIImage imageNamed:@"class_nothing.png"] forState:UIControlStateNormal];
    [condationBtn setBackgroundImage:[UIImage imageNamed:@"class_nothing.png"] forState:UIControlStateHighlighted];
    [condationBtn setBackgroundImage:[UIImage imageNamed:@"class_nothing.png"] forState:UIControlStateSelected];
    [condationBtn sizeToFit];
    [condationBtn addTarget:self action:@selector(buttonClilckAction:) forControlEvents:UIControlEventTouchUpInside];
    [_condationBaseView addSubview:condationBtn];
    condationBtn.centery = _condationBaseView.width/2.0f;
    condationBtn.centerx = _condationBaseView.width/2.0f;
}

- (void)removeNetCondationView
{
    [_condationBaseView removeFromSuperview];
}

- (void)loadData
{
    if (_condationBaseView) {
        [self removeNetCondationView];
    }
    [YGNetService YGPOST:@"ChooseFreshNewsType" parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {

        NSLog(@"%@",responseObject);
        
        NSArray *listArray = [NSArray array];
        listArray = [responseObject valueForKey:@"list"];
        for (int i = 0; i < listArray.count; i++) {
            [_titleArr addObject:[listArray[i] valueForKey:@"label"]];
            [_typeArr addObject:[listArray[i] valueForKey:@"value"]];
        }
        [self configUI];
        [self.titleView reloadViewWithTitles:_titleArr];

        //创建控制器数组 作为顶部的滚动标题的子控制器
        NSMutableArray *vcs = [[NSMutableArray alloc] init];
        for (int i = 0; i < _typeArr.count; i++) {
            RecommendNewsViewController  *vc = [[RecommendNewsViewController alloc] init];
            vc.dict = listArray[i];
            [vcs addObject:vc];
        }
        [self.contentView reloadViewWithChildVcs:vcs parentVC:self];


    } failure:^(NSError *error) {

    }];
    
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(15, 0, self.view.frame.size.width-15, 50);
    
    self.contentView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
}
//顶部的滚动标题
- (void)configUI
{
    self.titleView = [[LXScollTitleView alloc] initWithFrame:CGRectZero];
    self.titleView.backgroundColor = colorWithYGWhite;
    __weak typeof(self) weakSelf = self;
    self.titleView.selectedBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.contentView.currentIndex = index;
    };
    self.titleView.titleWidth = 110.f;
    self.titleView.normalColor = colorWithBlack;
    self.titleView.selectedColor = colorWithMainColor;
    [self.view addSubview:self.titleView];
    
    self.contentView = [[LXScrollContentView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = colorWithTable;
    self.contentView.scrollBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.titleView.selectedIndex = index;
    };
    [self.view addSubview:self.contentView];
    
}

- (void)buttonClilckAction:(UIButton *)btn
{
    [self loadData];
}



-(void)configSearchBar
{
    _backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake(0, 0, 20, 20);
    [_backButton setImage:[UIImage imageNamed:@"back_black"]  forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_backButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [_backButton sizeToFit];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(15, 5, YGScreenWidth - 40 - 15, YGNaviBarHeight - 10)];
    self.searchBar.placeholder = @"搜索感兴趣的新闻";
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
    // 改变UISearchBar内部输入框样式
    UIView *searchTextFieldView = nil;
    searchTextFieldView = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    // 改变输入框背景色
    searchTextFieldView.subviews[0].superview.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    searchTextFieldView.layer.cornerRadius = 5.0;
    [searchTextFieldView setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGNaviBarHeight)];
    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
    if([searchTextField isKindOfClass:UITextField.class])
    {
        searchTextField.font = [UIFont systemFontOfSize:14.0];
    }
    [navView addSubview:self.searchBar];
    self.navigationItem.titleView = navView;
    
    _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    _blackView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
}

//搜索历史的tableView
-(void)configSearchHistoryTableView
{
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    
    self.searchHistoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchHistoryTableView.backgroundColor = [UIColor clearColor];
//    self.searchHistoryTableView.scrollEnabled = NO;
    self.searchHistoryTableView.sectionHeaderHeight = 0.001;
    self.searchHistoryTableView.sectionFooterHeight = 0.001;
    self.searchHistoryTableView.delegate = self;
    self.searchHistoryTableView.dataSource = self;
    [_blackView addSubview:_searchHistoryTableView];
    [self.searchHistoryTableView reloadData];
    
}

#pragma mark - tableView的代理方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_historyListArray.count == 0)
    {
        self.searchHistoryTableView.tableFooterView.hidden = YES; // 没有历史数据时隐藏
    }
    else
    {
        self.searchHistoryTableView.tableFooterView.hidden = NO; // 有历史数据时显示
    }
    return _historyListArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ( _historyListArray.count) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
        //清除历史记录
        UIButton *clearHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearHistoryButton.frame = CGRectMake(0, 0, YGScreenWidth, 50);
        clearHistoryButton.backgroundColor = [UIColor whiteColor];
        [clearHistoryButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
        clearHistoryButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [clearHistoryButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        [clearHistoryButton addTarget:self action:@selector(clearHistoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:clearHistoryButton];
        return footerView;
    }
    else
    {
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ( _historyListArray.count) {
        return 50;
    }
    return 0.0001;
}

//tableView点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchNewThingsViewController *vc = [[SearchNewThingsViewController alloc] init];
    vc.searchString = _historyListArray[indexPath.row];
    [self addSearchRecord:_historyListArray[indexPath.row]];
    [_blackView removeFromSuperview];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - searchBar的一些设置
//点击searchbar的输入区域，就会触发
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
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    [self.searchHistoryTableView reloadData];
}

//searchBar结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _backButton.hidden = NO;
    searchBar.frame = CGRectMake(15, 5, YGScreenWidth - 40 - 15, YGNaviBarHeight - 10);
}

//searchbar的取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _backButton.hidden = NO;
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [self.searchHistoryTableView removeFromSuperview];
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
    SearchNewThingsViewController *vc = [[SearchNewThingsViewController alloc] init];
    vc.searchString = searchBar.text;
    [self addSearchRecord:searchBar.text];
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
//    if (searchBar.text.length) {
//        [self createRefreshWithScrollView:self.searchHistoryTableView containFooter:YES];
//        [self.searchHistoryTableView.mj_header beginRefreshing];
//    }
    [self.searchHistoryTableView removeFromSuperview];
    [_blackView removeFromSuperview];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//增加搜索记录
- (void)addSearchRecord:(NSString *)searchStr
{
    NSMutableArray *searchArray = [[NSMutableArray alloc]initWithArray:NEWS_SEARCH_HISTORY];
    if (searchArray == nil) {
        searchArray = [[NSMutableArray alloc]init];
    } else if ([searchArray containsObject:searchStr]) {
        [searchArray removeObject:searchStr];
    } else if ([searchArray count] >= RecordCount) {
        [searchArray removeObjectsInRange:NSMakeRange(RecordCount - 1, [searchArray count] - RecordCount + 1)];
    }
    [searchArray insertObject:searchStr atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:searchArray forKey:@"NewsSearchHistory"];
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    [self.searchHistoryTableView reloadData];
}
//读取所有历史记录
- (NSArray *)getAllSearchHistory
{
    return NEWS_SEARCH_HISTORY;
}
//删除所有历史记录
- (void)clearAllSearchHistory
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc]init] forKey:@"NewsSearchHistory"];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",self.searchHistoryTableView.contentOffset.y);
    if (self.searchHistoryTableView.contentOffset.y <= 0) {
        self.searchHistoryTableView.bounces = NO;
    }
    else
    {
        self.searchHistoryTableView.bounces = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
