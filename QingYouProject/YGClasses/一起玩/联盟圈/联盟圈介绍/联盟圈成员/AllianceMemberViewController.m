//
//  AllianceMemberViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceMemberViewController.h"
#import "AllianceMemberTableViewCell.h"
#import "AllianceMemberModel.h"

@interface AllianceMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray                 *_dataArray; //数据源
    NSMutableArray                 *_searchListArray; //数据源
    UITableView             *_tabelView;
    UITableView             *_searchTabelView;
    UITextField *_searchTextFieldView;
    UIView *_alphaView;
}

@end

@implementation AllianceMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)configAttribute
{
    self.view.backgroundColor = colorWithTable;
    self.naviTitle = @"盟成员（0）";
    _dataArray = [[NSMutableArray alloc] init];
    _searchListArray = [[NSMutableArray alloc] init];
    [self configUI];
    [self loadData];
}

- (void)loadData
{

    [YGNetService YGPOST:REQUEST_allianceMemberList parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId}  showLoadingView:NO scrollView:_tabelView success:^(id responseObject) {
        AllianceMemberModel *model = [[AllianceMemberModel alloc] init];
        [model setValuesForKeysWithDictionary:responseObject[@"manager"]];
        NSArray *dataArr = @[model];
        NSArray *dataArr1 = [[NSArray alloc]initWithArray:[AllianceMemberModel mj_objectArrayWithKeyValuesArray:responseObject[@"memberList"]]];
        
        [_dataArray addObject:dataArr];
        [_dataArray addObject:dataArr1];
        self.naviTitle =[NSString stringWithFormat:@"盟成员（%ld）",dataArr1.count];

        [_tabelView reloadData];
    } failure:^(NSError *error) {
        
    }];
  
}
#pragma mark --------- tabeleView 相关
-(void)configUI
{
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 5, YGScreenWidth - 40, 40)];
    searchBar.placeholder = @"搜索成员";
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.tintColor = [UIColor whiteColor];
    searchBar.barTintColor = [UIColor whiteColor];
    // 改变UISearchBar内部输入框样式
    UIView *searchTextFieldView = nil;
    searchTextFieldView = [[[searchBar.subviews firstObject] subviews] lastObject];
    // 改变输入框背景色
    searchTextFieldView.subviews[0].superview.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    searchTextFieldView.layer.cornerRadius = 5.0;
    [searchTextFieldView setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    _searchTextFieldView = [searchBar valueForKey:@"_searchField"];
    
    
    if([_searchTextFieldView isKindOfClass:UITextField.class])
    {
        _searchTextFieldView.inputAccessoryView = [UIView new];
        _searchTextFieldView.font = [UIFont systemFontOfSize:14.0];
    }
    
    [self.view addSubview: searchBar];

    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,45, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    [_tabelView registerClass:[AllianceMemberTableViewCell class] forCellReuseIdentifier:@"AllianceMemberTableViewCell"];
    _tabelView.backgroundColor = [UIColor clearColor];
    _tabelView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    
    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45)];
    _alphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
    [self.view addSubview:_alphaView];
    _alphaView.hidden = YES;
    
    _searchTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45) style:UITableViewStyleGrouped];
    _searchTabelView.delegate = self;
    _searchTabelView.dataSource = self;
    [_searchTabelView registerClass:[AllianceMemberTableViewCell class] forCellReuseIdentifier:@"AllianceMemberTableViewCell"];
    [_alphaView addSubview:_searchTabelView];
    _searchTabelView.backgroundColor = [UIColor clearColor];
    _searchTabelView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tabelView) {
        return _dataArray.count;

    }else
    {
        return 1;

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tabelView)
    {
        
        return [(NSArray *)_dataArray[section] count];
    }else
    {
        return _searchListArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"AllianceMemberTableViewCell";
    AllianceMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (tableView == _tabelView)
    {
        AllianceMemberModel *model = _dataArray[indexPath.section][indexPath.row];
        cell.model = model;
    }else
    {
        AllianceMemberModel *model = _searchListArray[indexPath.row];
        cell.model = model;
    }
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [tableView fd_heightForCellWithIdentifier:@"AllianceMemberTableViewCell" cacheByIndexPath:indexPath configuration:^(AllianceMemberTableViewCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        AllianceMemberModel *model = _dataArray[indexPath.section][indexPath.row];
        cell.model = model;
        [cell showFadeAnimate];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发现详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tabelView)
    {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    headerView.backgroundColor = colorWithYGWhite;
    
    //热门推荐label
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithDeepGray;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.text = @"群主、管理员";
    if (section == 1) {
        titleLabel.text = @"盟成员";
    }
    titleLabel.frame = CGRectMake(10, 10,YGScreenWidth-100-15, 20);
    [headerView addSubview:titleLabel];
    
    return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tabelView)
    {
        return 40;

    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _tabelView)
    {
        return 10;

    }
    return 0;
}


#pragma searchBar
#pragma mark - searchBar的一些设置
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(20, 5, YGScreenWidth - 40, YGNaviBarHeight - 10);
    //    [self configSearchHistoryTableView];
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
    [UIView animateWithDuration:0.3 animations:^{
        _alphaView.hidden = NO;
        
    }];
    [_searchListArray removeAllObjects];
    [_searchTabelView reloadData];

    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(30, 5, YGScreenWidth - 40 - 15, YGNaviBarHeight - 10);
    
}

//searchbar的取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _alphaView.hidden = YES;
        
    }];

}

//搜索键盘上的搜索按钮点击响应事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [self searchActionWithSearchString:_searchTextFieldView.text];
    [searchBar resignFirstResponder];
    
    
}

- (void)searchActionWithSearchString:(NSString *)searchString
{
    
    NSString *searchText=searchString;
    if (searchText.length>0) {
        [_searchListArray removeAllObjects];
        for (AllianceMemberModel *model in _dataArray[1]) {
            NSRange titleResult=[model.userName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [_searchListArray addObject:model];
            }
        }
        [_searchTabelView reloadData];
        
    }
}

@end
