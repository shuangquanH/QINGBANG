//
//  SearchResultViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/9/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SearchResultViewController.h"
#import "PlayTogetherCell.h"
#import "ActivityListModel.h"
#import "PlayTogetherDetailViewController.h"

#define RecordCount 3      //最多存储3条，自定义
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"SearchHistory"]

// 屏幕当前比例
#define OffWidth [UIScreen mainScreen].bounds.size.width / 375
#define OffHeight [UIScreen mainScreen].bounds.size.height / 667

@interface SearchResultViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView *_tableView;
    UIView *_blackView; //黑色遮罩
    NSMutableArray *_historyListArray;//历史记录array
    UIButton *_backButton;
}
@property(nonatomic,strong)UITableView *searchHistoryTableView; //搜索历史的tableView
@property (nonatomic, strong) NSMutableArray *dataArray;  //数据源
@property(nonatomic,strong)UISearchBar *searchBar;

@end

@implementation SearchResultViewController

-(UITableView *)searchHistoryTableView
{
    if (_searchHistoryTableView == nil) {
        _searchHistoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 200) style:UITableViewStylePlain];
    }
    return _searchHistoryTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    
    [self configUI];
    
    [self configNavi];
    
}

//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"findActivityByKey" parameters:@{@"total":self.totalString,@"count":self.countString,@"key":self.searchString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
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



-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 0.0001;
    _tableView.sectionHeaderHeight = YGScreenWidth * 0.12;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0001)];
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:_tableView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
   
}

-(void)configNavi
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
    
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(15 * OffWidth, 5, YGScreenWidth - 65 * OffWidth, YGNaviBarHeight - 10)];
    self.searchBar.placeholder = @"搜索感兴趣的活动";
    self.searchBar.text = self.searchString;
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
    // 改变UISearchBar内部输入框样式
    UIView *searchTextFieldView = nil;
    searchTextFieldView = [[[self.searchBar.subviews firstObject] subviews] lastObject];
    // 改变输入框背景色
    searchTextFieldView.subviews[0].superview.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    searchTextFieldView.layer.cornerRadius = 3.0;
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
        if (self.dataArray.count) {
            cell.model = self.dataArray[indexPath.row];
        }
        
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchHistoryTableView)
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
        self.searchString = _historyListArray[indexPath.row];
        self.searchBar.text = self.searchString;
        [self addSearchRecord:_historyListArray[indexPath.row]];
        [_blackView removeFromSuperview];
        
        [self createRefreshWithScrollView:_tableView containFooter:YES];
        [_tableView.mj_header beginRefreshing];
    }else
    {
        PlayTogetherDetailViewController * detail = [[PlayTogetherDetailViewController alloc]init];
        detail.official = [self.dataArray[indexPath.row] valueForKey:@"official"];
        detail.activityID = [self.dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:detail animated:YES];
    }
}


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
    searchBar.frame = CGRectMake(15 * OffWidth, 5, YGScreenWidth - 65 * OffWidth, YGNaviBarHeight - 10);
    _backButton.hidden = NO;
}

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
    [self addSearchRecord:searchBar.text];
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [_blackView removeFromSuperview];
    
    self.searchString = searchBar.text;
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
}
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

- (NSArray *)getAllSearchHistory
{
    return SEARCH_HISTORY;
}

- (void)clearAllSearchHistory
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc]init] forKey:@"SearchHistory"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
