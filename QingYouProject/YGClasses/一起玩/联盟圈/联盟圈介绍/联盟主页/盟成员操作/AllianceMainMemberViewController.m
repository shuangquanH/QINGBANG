//
//  AllianceMainMemberViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceMainMemberViewController.h"
#import "AllianceMemberModel.h"
#import "AllianceMainMemberCell.h"

@interface AllianceMainMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AllianceMainMemberCellDelegate>
{
    NSMutableArray                 *_dataArray; //数据源
    NSMutableArray                 *_searchListArray; //数据源
    UITableView             *_tabelView;
    UITextField *_searchTextFieldView;
    UISearchBar *_searchBar;
    UIImageView *_noDataImageView;

}

@end

@implementation AllianceMainMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)configAttribute
{
    self.view.backgroundColor = colorWithTable;
    self.naviTitle = @"盟成员（5）";
    _dataArray = [[NSMutableArray alloc] init];
    _searchListArray = [[NSMutableArray alloc] init];
    [self configUI];
    [self loadData];
}

- (void)loadData
{
    
    [YGNetService YGPOST:REQUEST_allianceMemberList parameters:@{@"allianceID":_allianceID,@"userID":YGSingletonMarco.user.userId}  showLoadingView:NO scrollView:_tabelView success:^(id responseObject) {
        [_dataArray removeAllObjects];
        [_searchListArray removeAllObjects];
        [_dataArray addObjectsFromArray:[AllianceMemberModel mj_objectArrayWithKeyValuesArray:responseObject[@"memberList"]]];
        [_searchListArray addObjectsFromArray:_dataArray];
        [_noDataImageView removeFromSuperview];
        if (_dataArray.count == 0) {
            _searchBar.hidden = YES;
            _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodata"]];
            [_noDataImageView sizeToFit];
            _noDataImageView.centerx = YGScreenWidth / 2;
            _noDataImageView.y = 150;
            [_tabelView addSubview:_noDataImageView];
        }
        self.naviTitle = [NSString stringWithFormat:@"盟成员（%ld）",_dataArray.count];

        [_tabelView reloadData];
    } failure:^(NSError *error) {
        
    }];

}
#pragma mark --------- tabeleView 相关
-(void)configUI
{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 5, YGScreenWidth - 20, 40)];
    _searchBar.placeholder = @"搜索成员";
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
    
    _searchTextFieldView = [_searchBar valueForKey:@"_searchField"];
    
    
    if([_searchTextFieldView isKindOfClass:UITextField.class])
    {
        _searchTextFieldView.inputAccessoryView = [UIView new];
        _searchTextFieldView.font = [UIFont systemFontOfSize:14.0];
    }
    
    [self.view addSubview: _searchBar];
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,45, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [_tabelView registerClass:[AllianceMainMemberCell class] forCellReuseIdentifier:@"AllianceMainMemberCell"];
    _tabelView.sectionFooterHeight = 0.001;
    [self.view addSubview:_tabelView];
    _tabelView.backgroundColor = [UIColor clearColor];
    _tabelView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tabelView.estimatedRowHeight = 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return _searchListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"AllianceMainMemberCell";
    AllianceMainMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    AllianceMemberModel *model = _searchListArray[indexPath.row];
    cell.model = model;
   
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [tableView fd_heightForCellWithIdentifier:@"AllianceMainMemberCell" cacheByIndexPath:indexPath configuration:^(AllianceMainMemberCell *cell) {
        cell.fd_enforceFrameLayout = YES;
        cell.delegate = self;
        AllianceMemberModel *model = _searchListArray[indexPath.row];
        cell.model = model;
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发现详情
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma searchBar
#pragma mark - searchBar的一些设置
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(10, 5, YGScreenWidth - 20, YGNaviBarHeight - 10);
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
    
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(10, 5, YGScreenWidth - 20, YGNaviBarHeight - 10);
    
    
}

//searchbar的取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [_searchListArray removeAllObjects];
    [_searchListArray addObjectsFromArray:_dataArray];
    [_tabelView reloadData];
    
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
//    [_searchListArray removeAllObjects];
//    for (AllianceMemberModel *model in _dataArray) {
//        if ([model.name containsString:searchString]) {
//            [_searchListArray addObject:model];
//            break;
//        }
//    }
    NSString *searchText=searchString;
    if (searchText.length>0) {
        [_searchListArray removeAllObjects];
        for (AllianceMemberModel *model in _dataArray) {
            NSRange titleResult=[model.userName rangeOfString:searchText options:NSCaseInsensitiveSearch];
             if (titleResult.length>0) {
                [_searchListArray addObject:model];
            }
        }
        [_tabelView reloadData];

    }
    
}
- (void)removeMemberWithModel:(AllianceMemberModel *)model
{
    if (![self loginOrNot])
    {
        return;
    }
    [YGAlertView showAlertWithTitle:@"确定要移出该成员吗？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithBlack,colorWithMainColor] handler:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }
        // 移除盟成员
        [YGNetService YGPOST:REQUEST_operateAllianceMember parameters:@{@"allianceID":_allianceID,@"userID":model.userID} showLoadingView:NO scrollView:nil success:^(id responseObject) {
//            [_dataArray removeObject:model];
//            [_tabelView reloadData];
            [YGAppTool showToastWithText:@"移出成功"];
            [self loadData];
        } failure:^(NSError *error) {
            
        }];
            
        }];
   
}

@end
