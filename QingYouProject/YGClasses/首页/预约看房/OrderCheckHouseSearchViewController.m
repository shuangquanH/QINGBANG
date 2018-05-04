//
//  OrderCheckHouseSearchViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderCheckHouseSearchViewController.h"
#import "OrderCheckHouseTableViewCell.h"
#import "OrderCheckHouseModel.h"

#import "OrderCheckHouseDetailViewController.h"


#define QUESTION_KEY   @"questionhistory"
#define HISTORY_MAX_COUNT 10

@interface OrderCheckHouseSearchViewController ()
<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@end

@implementation OrderCheckHouseSearchViewController
{
    UITextField *_searchTextFieldView;
    UIButton *_backButton;
    
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSString *_valueString;
    
    
    //历史记录tableview
    UITableView *_historyTableView;
    //历史记录array
    NSMutableArray *_historyListArray;
    UISearchBar *_searchBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [_searchTextFieldView becomeFirstResponder];
    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    _valueString = @"";
    _backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake(0, 0, 20, 20);
    [_backButton setImage:[UIImage imageNamed:@"back_black"]  forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [_backButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [_backButton sizeToFit];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 5, YGScreenWidth - 40 - 15, YGNaviBarHeight - 10)];
    _searchBar.placeholder = @"搜索感兴趣的房源信息";
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.barTintColor = [UIColor whiteColor];
    // 改变UISearchBar内部输入框样式
    UIView *searchTextFieldView = nil;
    searchTextFieldView = [[[_searchBar.subviews firstObject] subviews] lastObject];
    // 改变输入框背景色
    searchTextFieldView.subviews[0].superview.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    searchTextFieldView.layer.cornerRadius = 5.0;
    [searchTextFieldView setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGNaviBarHeight)];
    _searchTextFieldView = [_searchBar valueForKey:@"_searchField"];
    _listArray = [[NSMutableArray alloc] init];
    
    if([_searchTextFieldView isKindOfClass:UITextField.class])
    {
        _searchTextFieldView.inputAccessoryView = [UIView new];
        _searchTextFieldView.font = [UIFont systemFontOfSize:14.0];
    }
    
    [navView addSubview:_searchBar];
    self.navigationItem.titleView = navView;
    
    

    //历史记录数组
    _historyListArray = [[NSMutableArray alloc]init];
    
    if ([YGUserDefaults objectForKey:QUESTION_KEY]!= nil)
    {
        [_historyListArray addObjectsFromArray:[YGUserDefaults objectForKey:QUESTION_KEY]];
    }
    
    
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_OtNameSelectList parameters:@{@"value":_valueString,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        
        [_listArray addObjectsFromArray:[OrderCheckHouseModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_tableView headerAction:headerAction];
        if ([responseObject[@"list"] count] == 0) {
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
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[OrderCheckHouseTableViewCell class] forCellReuseIdentifier:@"OrderCheckHouseTableViewCell"];
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
//    [_tableView.mj_header beginRefreshing];
    
    
    
//    //历史记录头
//    UIView *historyTableViewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 30)];
//    historyTableViewHeader.backgroundColor = colorWithTable;
//
//    //历史记录文字
//    UILabel *historyTextLabel = [[UILabel alloc]init];
//    historyTextLabel.textColor = colorWithBlack;
//    historyTextLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
//    historyTextLabel.text = @"历史记录";
//    [historyTextLabel sizeToFitHorizontal];
//    historyTextLabel.x = 10;
//    historyTextLabel.centery = historyTableViewHeader.height/2;
//    [historyTableViewHeader addSubview:historyTextLabel];
    
    //历史记录头
    UIView *historyTableViewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    historyTableViewFooter.backgroundColor = colorWithYGWhite;
    
    //清除历史记录
    UIButton *clearHistoryButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 45)];
    [clearHistoryButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    [clearHistoryButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    clearHistoryButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    clearHistoryButton.contentMode = UIViewContentModeCenter;
    [clearHistoryButton addTarget:self action:@selector(clearHistoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [historyTableViewFooter addSubview:clearHistoryButton];
    
    
    //历史记录tableview
    _historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight) style:UITableViewStyleGrouped];
    _historyTableView.showsVerticalScrollIndicator = NO;
    _historyTableView.sectionHeaderHeight = 0.001;
    _historyTableView.sectionFooterHeight = 0.001;
    _historyTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _historyTableView.tableFooterView = historyTableViewFooter;
    _historyTableView.rowHeight = 43;
    _historyTableView.backgroundColor = colorWithTable;
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    [self.view addSubview:_historyTableView];
    _historyTableView.hidden = YES;


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _tableView)
    {
        return _listArray.count;
    }
    if (tableView == _historyTableView)
    {
        return _historyListArray.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        OrderCheckHouseTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCheckHouseTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        OrderCheckHouseModel *model = _listArray[indexPath.row];
        [cell setModel:model];
        return cell;
    }

    
    //历史记录
    if (tableView == _historyTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bb"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bb"];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = colorWithYGWhite;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = colorWithBlack;
            cell.textLabel.x = 10;
            cell.textLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
            cell.preservesSuperviewLayoutMargins = NO;
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        cell.textLabel.text = _historyListArray[indexPath.row];
        return cell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _historyTableView)
    {
        return 45 ;
    }
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //点击历史
    if (tableView == _historyTableView)
    {
        _searchTextFieldView.text = _historyListArray[indexPath.row];
        [self searchBarSearchButtonClicked:_searchBar];
    }
    if (tableView == _tableView)
    {
        OrderCheckHouseModel *model = _listArray[indexPath.row];
        OrderCheckHouseDetailViewController *vc = [[OrderCheckHouseDetailViewController alloc] init];
        vc.sourceId = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//清除历史记录
-(void)clearHistoryButtonClick
{
    [_historyListArray removeAllObjects];
    
    
    [YGUserDefaults setObject:@[] forKey:QUESTION_KEY];
    
    
    
    [_historyTableView reloadData];
}
#pragma searchBar
#pragma mark - searchBar的一些设置
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(- 20, 5, YGScreenWidth - 20, YGNaviBarHeight - 10);
    _backButton.hidden = YES;
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
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //都显示出来
    if ([_searchTextFieldView.text isEqualToString:@""])
    {
        _historyTableView.hidden = NO;
    }
    else
    {
        _historyTableView.hidden = YES;
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_listArray removeAllObjects];
    if ([_searchTextFieldView.text isEqualToString:@""])
    {
        _historyTableView.hidden = NO;
        [_tableView reloadData];
    }
    else
    {
        _historyTableView.hidden = YES;
        
        [_tableView reloadData];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(0, 5, YGScreenWidth - 40 - 15, YGNaviBarHeight - 10);
    _backButton.hidden = NO;
    
    
}

//searchbar的取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _backButton.hidden = NO;
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    _historyTableView.hidden = YES;
    [searchBar resignFirstResponder];
//    [self refreshActionWithIsRefreshHeaderAction:YES];
    
}

//搜索键盘上的搜索按钮点击响应事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _historyTableView.hidden = YES;
    if ([[_searchTextFieldView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
    {
        return ;
    }
    
    for (int i = 0; i<_historyListArray.count; i++)
    {
        //如果之前有就先移除
        if ([_historyListArray[i] isEqualToString:_searchTextFieldView.text])
        {
            [_historyListArray removeObjectAtIndex:i];
            break;
        }
    }
    
    [_historyListArray insertObject:_searchTextFieldView.text atIndex:0];
    if (_historyListArray.count > HISTORY_MAX_COUNT)
    {
        [_historyListArray removeObjectAtIndex:_historyListArray.count - 1];
    }
    
    [YGUserDefaults setObject:[NSArray arrayWithArray:_historyListArray] forKey:QUESTION_KEY];
    [_historyTableView reloadData];
    _valueString = _searchTextFieldView.text;
    searchBar.showsCancelButton = NO;
    [self refreshActionWithIsRefreshHeaderAction:YES];
    [searchBar resignFirstResponder];
    
    
}
@end
