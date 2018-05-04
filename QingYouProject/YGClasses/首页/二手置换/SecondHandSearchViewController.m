//
//  SecondHandSearchViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondHandSearchViewController.h"
#import "SecondMainCell.h"
#import "BabyDetailsController.h"

#define RecordCount 3      //最多存储3条，自定义
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"SecondHandSearchHistory"]

// 屏幕当前比例
#define OffWidth [UIScreen mainScreen].bounds.size.width / 375
#define OffHeight [UIScreen mainScreen].bounds.size.height / 667

@interface SecondHandSearchViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIView *_blackView; //黑色遮罩
    NSMutableArray *_historyListArray;//历史记录array
    UIButton *_backButton;
}
@property(nonatomic,strong)UITableView *searchHistoryTableView; //搜索历史的tableView
@property(nonatomic,strong)UISearchBar *searchBar;


@end

@implementation SecondHandSearchViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray = [NSMutableArray array];
    
    [self configUI];
    
    [self configNavi];

    
}

//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"WorthIn" parameters:@{@"type":@"4",@"total":self.totalString,@"count":self.countString,@"title":self.searchString} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if (((NSArray *)responseObject[@"merchandise"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[WorthInModel mj_objectArrayWithKeyValuesArray:responseObject[@"merchandise"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    [_tableView registerClass:[SecondMainCell class] forCellReuseIdentifier:@"SecondMainCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = colorWithTable;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 0.001;
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
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.layer.borderWidth = 0;
    [self.searchBar setBackgroundImage:[UIImage new]];
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
        SecondMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondMainCell" forIndexPath:indexPath];
        if (_dataArray.count) {
            cell.model = _dataArray[indexPath.section];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchHistoryTableView)
    {
        return 1;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searchHistoryTableView)
    {
        return 50;
    }
    return (YGScreenWidth - 30) / 3 + 130;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view;
    view.backgroundColor = colorWithPlateSpacedColor;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.searchHistoryTableView)
    {
        return 0.00001;
    }
    return 10;
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

        [_tableView.mj_header beginRefreshing];
        
    }else
    {
        BabyDetailsController *vc = [[BabyDetailsController alloc]init];
        vc.idString = [_dataArray[indexPath.section] valueForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
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
    [[NSUserDefaults standardUserDefaults] setObject:searchArray forKey:@"SecondHandSearchHistory"];
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    [self.searchHistoryTableView reloadData];
}

- (NSArray *)getAllSearchHistory
{
    return SEARCH_HISTORY;
}

- (void)clearAllSearchHistory
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc]init] forKey:@"SecondHandSearchHistory"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
