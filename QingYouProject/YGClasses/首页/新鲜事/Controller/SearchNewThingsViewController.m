//
//  SearchNewThingsViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SearchNewThingsViewController.h"
#import "NewThingsModel.h"
#import "TextOnlyCell.h"
#import "PictureLeftTextRightCell.h"
#import "TextTopPictureBottomCell.h"
#import "NewThingsDetailController.h"

#define RecordCount 3      //最多存储3条，自定义
#define NEWS_SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"NewsSearchHistory"]

@interface SearchNewThingsViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *_blackView; //黑色遮罩
    NSMutableArray *_historyListArray;//历史记录array
    UIButton *_backButton;
    NSMutableArray    *_typeArr;          //类型数组
    NSMutableArray    *_titleArr;          //类型数组
}
@property(nonatomic,strong)NSMutableArray *dataArray;//搜索结果数组
@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)UITableView *searchHistoryTableView; //搜索历史的tableView
@property(nonatomic,strong)UISearchBar *searchBar; //导航栏上面的搜索条

@end

@implementation SearchNewThingsViewController


-(UITableView *)searchHistoryTableView
{
    if (_searchHistoryTableView == nil) {
        _searchHistoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStylePlain];
    }
    return _searchHistoryTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData];
    
}

- (void)configAttribute
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configSearchBar];
    [self configMainTableView];
    self.view.backgroundColor = colorWithYGWhite;
    _typeArr = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];
    
}


//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    _dataArray = [NSMutableArray array];
    if(!self.searchBar.text.length)
    {
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:self.tabView headerAction:YES];
        [self endRefreshWithScrollView:_tabView];
        [self.tabView reloadData];
        return;
    }
    [YGNetService YGPOST:@"QueryFreshNewsList" parameters:@{@"total":self.totalString,@"count":self.countString,@"searchValue":self.searchBar.text} showLoadingView:NO scrollView:self.tabView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (((NSArray *)responseObject[@"list"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:self.tabView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[NewThingsModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:self.tabView headerAction:YES];
        [self.tabView reloadData];
    } failure:^(NSError *error) {
        
    }];
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
//    _historyListArray = [self getAllSearchHistory].mutableCopy;
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
//列表tableView
-(void)configMainTableView
{
    _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight) style:UITableViewStyleGrouped];
    _tabView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tabView.sectionHeaderHeight = 0.001;
    _tabView.sectionFooterHeight = 0.001;
    _tabView.delegate = self;
    _tabView.dataSource = self;
    
    [self.tabView registerNib:[UINib nibWithNibName:@"TextTopPictureBottomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TextTopPictureBottomCell"];
    [self.tabView registerNib:[UINib nibWithNibName:@"TextOnlyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TextOnlyCell"];
    [self.tabView registerNib:[UINib nibWithNibName:@"PictureLeftTextRightCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PictureLeftTextRightCell"];
    
    [self.view addSubview:_tabView];
    
    [self createRefreshWithScrollView:self.tabView containFooter:YES];
    [self.tabView.mj_header beginRefreshing];
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
    [self addSearchRecord:searchBar.text];
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    [self.searchHistoryTableView removeFromSuperview];
    [_blackView removeFromSuperview];
    [self createRefreshWithScrollView:self.tabView containFooter:YES];
    [self.tabView.mj_header beginRefreshing];
    
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

#pragma mark - tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchHistoryTableView) {
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
    else{
        if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"0"])
        {
            TextOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextOnlyCell" forIndexPath:indexPath];
            cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.dataArray[indexPath.row] valueForKey:@"source"],[self.dataArray[indexPath.row] valueForKey:@"time"]];
            return cell;
        }
        if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"1"])
        {
            PictureLeftTextRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureLeftTextRightCell" forIndexPath:indexPath];
            cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.dataArray[indexPath.row] valueForKey:@"source"],[self.dataArray[indexPath.row] valueForKey:@"time"]];
            NSString *imgString = [self.dataArray[indexPath.row] valueForKey:@"imgs"];
            NSArray * imgsArray = [imgString componentsSeparatedByString:@","];
            [cell.leftimageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[0]] placeholderImage:YGDefaultImgFour_Three];
            return cell;
        }
        if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"2"])
        {
            TextTopPictureBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextTopPictureBottomCell" forIndexPath:indexPath];
            cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[self.dataArray[indexPath.row] valueForKey:@"source"],[self.dataArray[indexPath.row] valueForKey:@"time"]];
            NSString *imgString = [self.dataArray[indexPath.row] valueForKey:@"imgs"];
            NSArray * imgsArray = [imgString componentsSeparatedByString:@","];
            [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[0]] placeholderImage:YGDefaultImgFour_Three];
            [cell.middleImageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[1]] placeholderImage:YGDefaultImgFour_Three];
//            if (imgsArray.count >= 3) {
                [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:imgsArray[2]] placeholderImage:YGDefaultImgFour_Three];
//            }
            return cell;
        }
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchHistoryTableView) {
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
    if (tableView == self.searchHistoryTableView) {
        return 50;
    }else
    {
        if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"0"]){
            //        return YGScreenWidth * 0.17;
            return [tableView fd_heightForCellWithIdentifier:@"TextOnlyCell" configuration:^(TextOnlyCell *cell) {
                cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
            }];
        }
        if ([[self.dataArray[indexPath.row] valueForKey:@"type"] isEqualToString:@"1"]) {
            return YGScreenWidth * 0.30;
        }
        return [tableView fd_heightForCellWithIdentifier:@"TextTopPictureBottomCell" configuration:^(TextTopPictureBottomCell *cell) {
            cell.nameLabel.text = [self.dataArray[indexPath.row] valueForKey:@"name"];
        }];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((tableView == self.searchHistoryTableView) && _historyListArray.count) {
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
    if ((tableView == self.searchHistoryTableView) && _historyListArray.count) {
            return 50;
    }
    return 0.0001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchHistoryTableView) {
        self.searchBar.text = _historyListArray[indexPath.row];
        [self addSearchRecord:self.searchBar.text];
        self.searchBar.showsCancelButton = NO;
        [self.searchBar resignFirstResponder];
        [self.searchHistoryTableView removeFromSuperview];
        [_blackView removeFromSuperview];
        [self createRefreshWithScrollView:self.tabView containFooter:YES];
        [self.tabView.mj_header beginRefreshing];
    }
    else
    {
        NewThingsDetailController *vc = [[NewThingsDetailController alloc] init];
        vc.idString = [self.dataArray[indexPath.row] valueForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
