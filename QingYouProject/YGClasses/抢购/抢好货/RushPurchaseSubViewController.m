//
//  RushPurchaseSubViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseSubViewController.h"
#import "MyAllianceTableViewCell.h"
#define heraderHeight (YGScreenWidth/2+60)
#import "YGScollTitleView.h"
#import "LXScrollContentView.h"

#import "CrowdFundingAddProjectChooseTypeModel.h"
#import "ProjectApplyModel.h"

#import "RushPurchaseSubTableViewCell.h"

#import "RushPurchaseSubModel.h"

#import "ProgressView.h"

#import "RushPurchaseDetailViewController.h"
#import "RushPurchaseProductModel.h"
//选择类型用到
#import "RushPurchaseClassifyView.h"
#import "AdvertisesForInfoModel.h"
//轮播图
#import "ProjectApplyForWebDetailViewController.h"
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"RushPurchaseSearchHistory"]
#define RecordCount 3      //最多存储3条，自定义

@interface RushPurchaseSubViewController ()<UIScrollViewDelegate,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UISearchBarDelegate,RushPurchaseClassifyViewDelegate,RushPurchaseSubTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray          *dataSource;  //数据源
@property (nonatomic, strong) YGScollTitleView *titleView;
@property (nonatomic, strong) UIView          *topSearchView;  //
//@property (nonatomic, strong) UIButton          *topCancleButton;  //
@property(nonatomic,strong)UISearchBar *bottomSearchBar;//下面的搜索框


@end

@implementation RushPurchaseSubViewController
{
    SDCycleScrollView    *_adScrollview; //广告轮播
    UIView               *_baseView;
    UILabel               *_titleLabel;
    UILabel *_newPriceLabel;
    UILabel  *_oldPriceLabel;
    UIImageView *_posterImageView; //海报
    NSMutableArray  *_typeArr;          //类型数组
    NSMutableArray    *_titleArr;          //类型数组
    NSMutableArray * _controllersArray;//Controller数组
    UIView *_titleBaseView;
    UIImageView  *_noDataImageView;
    NSMutableArray *_dataSource;
    RushPurchaseClassifyView *_popView;
    NSMutableArray *_classifyArray;
    UIView *_searchTextFieldView;
    
    UITableView *_tableView;
    NSMutableArray *_listArray;
    NSMutableArray *_commentArray;
    UIView *_topBaseView;
    NSString *_tableViewTotalString;
    NSString *_tableViewCountString;
    
    int _index;
    NSArray *_imgList;
    
    UITableView *_searchTableView;
    NSMutableArray *_searchListArray;
    UIView *_alphaView;
    UIButton *_backButton;
    UISearchBar *_searchBar;
    NSString   *_keyString;
    NSString   *_classifyIdsString;
    BOOL _isSearching;
    UIButton *_sortButton;
    
    //历史
    UITableView *_historyTableView;
    NSMutableArray *_historyListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configAttribute];
    [self loadData];
}

#pragma mark ---- 重写导航条
- (void)configAttribute
{
    
    _typeArr = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    _searchListArray = [[NSMutableArray alloc] init];
    _listArray = [[NSMutableArray alloc] init];
    _classifyArray = [[NSMutableArray alloc] init];
    _keyString = @"";
    _classifyIdsString = @"";
    self.view.frame = CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight-45);
    
    _backButton = [[UIButton alloc] init];
    _backButton.frame = CGRectMake(0, 0, 30, 40);
    [_backButton setImage:[UIImage imageNamed:@"back_black"]  forState:UIControlStateNormal];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    _backButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
//    [_backButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
//    [_backButton sizeToFit];
    [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    [self createSearch];
    
    //    self.topCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.topCancleButton.frame = CGRectMake(YGScreenWidth - 50, 0, 50, YGNaviBarHeight);
    //    [self.topCancleButton setTitle:@"取消" forState:UIControlStateNormal];
    //    [self.topCancleButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    //    [self.topCancleButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    //    [self.topCancleButton addTarget:self action:@selector(topCancel:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.topSearchView addSubview:self.topCancleButton];
    
    _sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sortButton setImage:[UIImage imageNamed:@"snapup_classify_black"] forState:UIControlStateNormal];
    [_sortButton setTitle:@"" forState:UIControlStateNormal];
    [_sortButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_sortButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_sortButton addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    _sortButton.frame = CGRectMake(20, 0, 30, 50);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_sortButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    _sortButton.selected = NO;
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
}

- (void)loadData
{
    
    [YGNetService YGPOST:REQUEST_falshsaleBanner parameters:@{@"type":@"1"} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        _imgList =[[NSArray alloc] initWithArray:[RushPurchaseSubModel  mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        RushPurchaseSubModel *topImageModel = [[RushPurchaseSubModel alloc] init];
        if (_imgList.count >0) {
            topImageModel = _imgList[0];
        }
        
        [YGNetService YGPOST:REQUEST_falshsaleClassify parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
            _classifyArray = [AdvertisesForInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
            [YGNetService YGPOST:REQUEST_falshsaleRound parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                
                _typeArr = [CrowdFundingAddProjectChooseTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                NSArray *purchaseTypeArray = @[@"",@"抢购中",@"即将开始"];
                for (CrowdFundingAddProjectChooseTypeModel *model in _typeArr) {
                    [_titleArr addObject:[NSString stringWithFormat:@"%@\n%@",model.name,purchaseTypeArray[[model.type intValue]]]];
                }
                _index = 0;
                [self configUI];
                self.titleView.titles = _titleArr;
                [self.titleView reloadViewWithTitles:_titleArr];
                int i = 0;
                for (CrowdFundingAddProjectChooseTypeModel *model in _typeArr) {
                    if ([model.type isEqualToString:@"2"]) {
                        break;
                    }
                    i++;
                }
                if (i == 0) {
                    [self.titleView setSelectedIndex:0];
                }else
                {
                    [self.titleView setSelectedIndex:i-1];
                }

                [_posterImageView sd_setImageWithURL:[NSURL URLWithString:topImageModel.coverUrl] placeholderImage:YGDefaultImgTwo_One];
                
                NSMutableArray *imageArray = [[NSMutableArray alloc] init];
                
                for (RushPurchaseSubModel *model in _imgList) {
                    [imageArray addObject:model.coverUrl];
                }
                _adScrollview.imageURLStringsGroup = imageArray;
            } failure:^(NSError *error) {
                
            }];
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark ---- 配置UI
-(void)configUI
{
    
    /********************** 头视图两个按钮 *****************/
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    _baseView.backgroundColor = colorWithYGWhite;
    
    
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2) delegate:self placeholderImage:YGDefaultImgTwo_One];
    _adScrollview.imageURLStringsGroup = _imgList;
    _adScrollview.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
    _adScrollview.delegate = self;
    [_baseView addSubview:_adScrollview];
    
    
    /********************** 选择器 ********************/
    
    _titleBaseView  = [[UIView alloc] initWithFrame:CGRectMake(0, _baseView.height-60, YGScreenWidth,60)];
    _titleBaseView.backgroundColor = colorWithYGWhite;
    [_baseView addSubview:_titleBaseView];
    
    UIButton *todayHotPurchaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    todayHotPurchaseBtn.frame = CGRectMake(0, 0, 80, 60);
    [todayHotPurchaseBtn addTarget:self action:@selector(todayHotPurchaseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    todayHotPurchaseBtn.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [todayHotPurchaseBtn setTitle:@"已开抢" forState:UIControlStateNormal];
    [todayHotPurchaseBtn setTitleColor:colorWithOrangeColor forState:UIControlStateNormal];
    todayHotPurchaseBtn.backgroundColor = colorWithBlack;
    [_titleBaseView addSubview:todayHotPurchaseBtn];
    todayHotPurchaseBtn.contentMode = UIViewContentModeCenter;
    todayHotPurchaseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    todayHotPurchaseBtn.selected = NO;
    
    self.titleView = [[YGScollTitleView alloc] initWithFrame:CGRectMake(todayHotPurchaseBtn.width, 0, YGScreenWidth-70,60)];
    self.titleView.backgroundColor = colorWithYGWhite;
    self.titleView.titleFont = [UIFont systemFontOfSize:YGFontSizeBigOne];
    __weak typeof(self) weakSelf = self;
    _index = 0;
    self.titleView.selectedBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        [todayHotPurchaseBtn setTitleColor:colorWithOrangeColor forState:UIControlStateNormal];
        todayHotPurchaseBtn.backgroundColor = colorWithBlack;
        _index = (int)index;
        [strongSelf refreshActionWithIsRefreshHeaderAction:YES];
    };
    self.titleView.titleWidth = 110.f;
    self.titleView.normalColor = colorWithBlack;
    self.titleView.selectedColor = colorWithMainColor;
    [self.titleView setSelectedIndex:0];
    [_titleBaseView addSubview:self.titleView];
    
    
    
    //tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerClass:[RushPurchaseSubTableViewCell class] forCellReuseIdentifier:@"RushPurchaseSubTableViewCell"];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _baseView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self createRefreshWithScrollView:_tableView containFooter:YES];
//    [self refreshActionWithIsRefreshHeaderAction:YES];
    [_tableView.mj_header beginRefreshing];
    
    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)];
    _alphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0];
    [self.view addSubview:_alphaView];
    _alphaView.hidden = YES;
    
    //tableview
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _searchTableView.showsVerticalScrollIndicator = NO;
    [_searchTableView registerClass:[RushPurchaseSubTableViewCell class] forCellReuseIdentifier:@"RushPurchaseSubTableViewCell"];
    _searchTableView.backgroundColor = colorWithTable;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _searchTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    [_alphaView addSubview:_searchTableView];
    [self createRefreshWithScrollView:_searchTableView containFooter:YES];
//    [self refreshActionWithIsRefreshHeaderAction:YES];
    _searchTableView.hidden = YES;
    
    
    
    UIView *footerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, YGScreenWidth, 50)];
    footerView.backgroundColor = colorWithYGWhite;
    //清除历史记录
    UIButton *clearHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearHistoryButton.frame = CGRectMake(0, 0, YGScreenWidth, 50);
    clearHistoryButton.backgroundColor = [UIColor whiteColor];
    [clearHistoryButton setTitle:@"清除搜索历史" forState:UIControlStateNormal];
    clearHistoryButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [clearHistoryButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [clearHistoryButton addTarget:self action:@selector(clearHistoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:clearHistoryButton];
    
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    //tableview
    _historyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) style:UITableViewStyleGrouped];
    _historyTableView.showsVerticalScrollIndicator = NO;
    _historyTableView.backgroundColor = [UIColor clearColor];
    _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _historyTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
//    _historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.001)];
    _historyTableView.sectionFooterHeight = 0.001;
    _historyTableView.sectionHeaderHeight = 0.001;
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    _historyTableView.tableFooterView = footerView;

    [_alphaView addSubview:_historyTableView];
    _historyTableView.hidden = YES;
    
 
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(self.titleView.x, self.titleView.y, self.view.frame.size.width-self.titleView.x, self.titleView.height);
    
    //    self.contentView.frame = CGRectMake(0, self.contentView.y, self.view.frame.size.width, self.view.frame.size.height - 50);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (_tableView.contentOffset.y>=_baseView.height-60) {
        _titleBaseView.y = 0;
        [self.view addSubview:_titleBaseView];
//        if (_alphaView.hidden == NO) {
//            [self.view bringSubviewToFront:_alphaView];
//        }
    }
    if (_tableView.contentOffset.y<_baseView.height-60) {
        _titleBaseView.y = _baseView.height-60;
        [_baseView addSubview:_titleBaseView];
    }
    if (_alphaView.hidden == NO) {
        [self.view bringSubviewToFront:_alphaView];
    }
    if (_popView.hidden == NO) {
        [self.view bringSubviewToFront:_popView];
    }
}


- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    NSString *itemID = @"";
    if (![_keyString isEqualToString:@""] || _index == 100) {
        itemID = @"";
    }else
    {
        CrowdFundingAddProjectChooseTypeModel *model = _typeArr[_index];
        itemID = [NSString stringWithFormat:@"%@",model.id];
        
    }
    if (headerAction == YES) {
        self.countString = @"10";
        self.totalString = @"0";
    }
    
    [YGNetService YGPOST:REQUEST_falshsaleByRound parameters:@{@"roundId":itemID,@"key":_keyString,@"classifyIds":_classifyIdsString,@"usmUserId":YGSingletonMarco.user.userId,@"total":self.totalString,@"count":self.countString}  showLoadingView:NO scrollView:_tableView success:^(id responseObject) {
        
        [self endRefreshWithScrollView:_tableView];
        [self endRefreshWithScrollView:_searchTableView];
        
        
        if (_isSearching == NO) {
            if (headerAction == YES) {
                [_listArray removeAllObjects];
            }
            [_listArray addObjectsFromArray:[RushPurchaseProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            
            [_noDataImageView removeFromSuperview];
            if (_listArray.count == 0 ) {
                _noDataImageView = [[UIImageView alloc] init];
                _noDataImageView.image = [UIImage imageNamed:@"nocommodity"];
                [_tableView addSubview:_noDataImageView];
                [_noDataImageView sizeToFit];
                _noDataImageView.centerx = YGScreenWidth / 2;
                _noDataImageView.y = heraderHeight+40;
            }
            if ([responseObject[@"list"] count] < 10) {
                [self noMoreDataFormatWithScrollView:_tableView];
            }
            [_tableView reloadData];
        }else
        {
            if (headerAction == YES) {
                [_searchListArray removeAllObjects];
            }
            [_searchListArray addObjectsFromArray:[RushPurchaseProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            
            [self addNoDataImageViewWithArray:_searchListArray shouldAddToView:_searchTableView headerAction:headerAction];
            
            if ([responseObject[@"list"] count] < 10) {
                [self noMoreDataFormatWithScrollView:_searchTableView];
            }
            [_searchTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _historyTableView)
    {
        return 50;
    }
    if (tableView == _tableView) {
        return [tableView fd_heightForCellWithIdentifier:@"RushPurchaseSubTableViewCell" cacheByIndexPath:indexPath configuration:^(RushPurchaseSubTableViewCell *cell) {
            cell.delegate = self;
            [cell setModel:_listArray[indexPath.section] withIndexPath:indexPath];
            
        }];
    }
    if (tableView == _searchTableView) {
        return [tableView fd_heightForCellWithIdentifier:@"RushPurchaseSubTableViewCell" cacheByIndexPath:indexPath configuration:^(RushPurchaseSubTableViewCell *cell) {
            cell.delegate = self;
            [cell setModel:_searchListArray[indexPath.section] withIndexPath:indexPath];
            
        }];
        
    }
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return _listArray.count;
        
    }
    if (tableView == _searchTableView) {
        return _searchListArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _historyTableView)
    {
        if (_historyListArray.count == 0)
        {
            _historyTableView.hidden = YES; // 没有历史数据时隐藏
        }
        else
        {
            _historyTableView.tableFooterView.hidden = NO; // 有历史数据时显示
        }
        return _historyListArray.count;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _historyTableView)
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
        cell.backgroundColor = colorWithYGWhite;
        cell.textLabel.text = _historyListArray[indexPath.row];
        return cell;
    }else
    {
        RushPurchaseSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RushPurchaseSubTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor = colorWithYGWhite;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        if (tableView == _tableView) {
            [cell setModel:_listArray[indexPath.section] withIndexPath:indexPath];
            
        }
        if (tableView == _searchTableView) {
            [cell setModel:_searchListArray[indexPath.section] withIndexPath:indexPath];
            
        }
        return cell;
    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _historyTableView) {
        _keyString = _historyListArray[indexPath.row];
        [self addSearchRecord:_historyListArray[indexPath.row]];
        _historyTableView.hidden = YES;
        _searchTableView.hidden = NO;
        [self refreshActionWithIsRefreshHeaderAction:YES];
    }else if (tableView == _searchTableView)
    {
        _searchTableView.hidden = YES;
        _alphaView.hidden = YES;
        RushPurchaseProductModel *model = _searchListArray[indexPath.row];
        RushPurchaseDetailViewController *vc = [[RushPurchaseDetailViewController alloc] init];
        vc.itemId = model.commodityId;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        _searchTableView.hidden = YES;
        _alphaView.hidden = YES;
        RushPurchaseProductModel *model = _listArray[indexPath.section];
        RushPurchaseDetailViewController *vc = [[RushPurchaseDetailViewController alloc] init];
        vc.itemId = model.commodityId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _historyTableView) {
        return 0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _historyTableView) {
        return nil;
    }
    UIView *progressBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 10)];
    progressBaseView.backgroundColor = colorWithTable;
    
    return progressBaseView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (tableView == _historyTableView ) {
        return 0;
    }
    if (_listArray.count>0) {
        RushPurchaseProductModel *model = _listArray[section];
        if ([model.type isEqualToString:@"0"])
        {
            return 0;
            
        }
    }
    
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_listArray.count>0) {
        RushPurchaseProductModel *model = _listArray[section];
        if ([model.type isEqualToString:@"0"])
        {
            return nil;
            
        }
    }
    if (tableView == _historyTableView ) {
        return nil;
    }
    /********************** 进度条 众筹 ********************/
    
    RushPurchaseProductModel *model;
    if (tableView == _searchTableView) {
        model = _searchListArray[section];
    }
    if (tableView == _tableView) {
        model = _listArray[section];
    }

    UIView *progressBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 60)];
    progressBaseView.backgroundColor = colorWithYGWhite;
    
    UIView *progressBase = [[UIView alloc] initWithFrame:CGRectMake(10, 0, YGScreenWidth, 25)];
    [progressBaseView addSubview:progressBase];
    
    ProgressView *progressView = [[ProgressView alloc] initWithHeight:25 andWidth:YGScreenWidth-20];
    [progressBase addSubview:progressView];
    
    [progressView setProgress:[model.percentage floatValue] andTotal:100];
    
    //热门推荐label
    UILabel *contenttionLabel = [[UILabel alloc]init];
    contenttionLabel.frame = CGRectMake(10,25, YGScreenWidth-20, 30);
    contenttionLabel.textColor = colorWithDeepGray;
    contenttionLabel.text = [NSString stringWithFormat:@"已抢%@件",model.falshSaleSizesSales];
    contenttionLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [progressBaseView addSubview:contenttionLabel];
    
    return progressBaseView;
}

- (void)posterImageViewTapAction
{
    ProjectApplyModel *topImageModel = _imgList[0];
}

#pragma 轮播代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    RushPurchaseSubModel *topImageModel = _imgList[index];
    if (![topImageModel.commodityId isEqualToString:@""])
    {
        RushPurchaseDetailViewController *vc = [[RushPurchaseDetailViewController alloc] init];
        vc.itemId = topImageModel.commodityId;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        ProjectApplyForWebDetailViewController *vc = [[ProjectApplyForWebDetailViewController alloc] init];
        vc.contentUrl = topImageModel.content;
        vc.naviTitleString = topImageModel.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma searchBar
#pragma mark - searchBar的一些设置
//搜索
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
- (void)createSearch
{
    
    self.topSearchView = [[UIView alloc]initWithFrame:CGRectMake(40, YGStatusBarHeight, YGScreenWidth-100, YGNaviBarHeight)];
    self.topSearchView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.topSearchView;
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 5, YGScreenWidth-100 , YGNaviBarHeight - 10)];
    _searchBar.placeholder = @"搜索感兴趣的物品";
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.inputAccessoryView = [[UIView alloc]init];
    _searchBar.showsCancelButton = NO;
    // 改变UISearchBar内部输入框样式
    _searchTextFieldView = nil;
    _searchTextFieldView = [[[_searchBar.subviews firstObject] subviews] lastObject];
    // 改变输入框背景色
    _searchTextFieldView.subviews[0].superview.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    _searchTextFieldView.layer.cornerRadius = 5.0;
    [_searchTextFieldView setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    UITextField *searchTextField = [_searchBar valueForKey:@"_searchField"];
    searchTextField.layer.cornerRadius = 5;
    searchTextField.clipsToBounds = YES;
    if([searchTextField isKindOfClass:UITextField.class])
    {
        searchTextField.font = [UIFont systemFontOfSize:14.0];
    }
    [self.topSearchView addSubview:_searchBar];
    
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (_popView) {
        [_popView dismiss];
    }
    [_sortButton setTitle:@"取消" forState:UIControlStateNormal];
    [_sortButton setImage:[UIImage new] forState:UIControlStateNormal];
    _backButton.hidden = YES;
    _alphaView.hidden = NO;
    [self.view bringSubviewToFront:_alphaView];
    _isSearching = YES;
    self.topSearchView.frame = CGRectMake(15, YGStatusBarHeight, YGScreenWidth-75, YGNaviBarHeight);
    [UIView animateWithDuration:0.3 animations:^{
        _alphaView.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.7];
 
    } completion:^(BOOL finished) {
        _historyTableView.hidden = NO;
        _historyListArray = (NSMutableArray *)[self getAllSearchHistory];
        [_historyTableView reloadData];
    }];
    _tableViewCountString = self.countString;
    _tableViewTotalString = self.totalString;
    return YES;
}


//搜索键盘上的搜索按钮点击响应事件 点击搜索 战士搜索结果 界面有searchbar 取消按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    _historyTableView.hidden = YES;
    _searchTableView.hidden = NO;
    [_alphaView setHidden:NO];
    [self addSearchRecord:searchBar.text];
    _index = 100;
    _keyString = searchBar.text;
    [self refreshActionWithIsRefreshHeaderAction:YES];
    [_searchBar resignFirstResponder];
    
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searchBar.text = searchText;
}

//取消按钮点击之后 清空搜索内容 searchbar归为 取消隐藏
-(void)topCancel:(UIButton *)button
{
    _historyTableView.hidden = YES;
    _searchTableView.hidden = YES;
    _backButton.hidden = NO;
    _searchBar.text = nil;
    _bottomSearchBar.text = nil;
    [_searchBar resignFirstResponder];
    [_alphaView setHidden:YES];
    self.totalString = _tableViewTotalString;
    self.countString = _tableViewCountString;
    _keyString = @"";
    _isSearching = NO;
    [_sortButton setTitle:@"" forState:UIControlStateNormal];
    [_sortButton setImage:[UIImage imageNamed:@"snapup_classify_black"] forState:UIControlStateNormal];
    _sortButton.selected = NO;
    self.topSearchView.frame = CGRectMake(40, YGStatusBarHeight, YGScreenWidth-100, YGNaviBarHeight);
    
    //    [UIView animateWithDuration:0.3 animations:^{
    //    }];
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
    [[NSUserDefaults standardUserDefaults] setObject:searchArray forKey:@"RushPurchaseSearchHistory"];
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    [_historyTableView reloadData];
}
//读取所有历史记录
- (NSArray *)getAllSearchHistory
{
    return SEARCH_HISTORY;
}
//删除所有历史记录
- (void)clearAllSearchHistory
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSMutableArray alloc]init] forKey:@"RushPurchaseSearchHistory"];
}
//清除搜索历史
-(void)clearHistoryButtonClick:(UIButton *)button
{
    [self clearAllSearchHistory];
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    [_historyTableView reloadData];
    
}
#pragma dianji
- (void)todayHotPurchaseBtnClick:(UIButton *)btn
{
    if (_index == 100) {
        return;
    }
    _index = 100;
    btn.backgroundColor = colorWithMainColor;
    [btn setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [self.titleView selectDefult];
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

#pragma 分类获取
-(void)sortClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (_isSearching)
    {
        [self topCancel:button];
        
    }else
    {
        
        _searchBar.text = nil;
        [_searchBar resignFirstResponder];
        if (button.selected == YES) {
            [_popView dismiss];
            
            return;
        }
        _popView = [[RushPurchaseClassifyView alloc] init];
        _popView.delegate = self;
        [self.view addSubview:_popView];
        
        for ( AdvertisesForInfoModel *model in _classifyArray) {
            model.isSelect = NO;
            
        }
        for ( AdvertisesForInfoModel *model in _classifyArray) {
            if ([_classifyIdsString isEqualToString:model.id]) {
                model.isSelect = YES;
                break;
            }
        }
//        _index = 100;
        
        [_popView createOrderHouseCheckPopChooseViewWithDataSorce:@[_classifyArray] withTitle: @" 价格（元/月/㎡）"];
    }
}
- (void)rushPurchaseClassifyViewSiftDataWithKeyModelArray:(NSArray *)modelArray
{
    AdvertisesForInfoModel *model = modelArray[0];
    
    //        for (AdvertisesForInfoModel *modelClassify in _classifyArray)
    //        {
    //            modelClassify.isSelect = NO;
    //            if ([model.id isEqualToString:modelClassify.id])
    //            {
    //                modelClassify.isSelect = YES;
    //            }
    //        }
    _classifyIdsString = model.id;

    if (model.isSelect == NO) {
        _classifyIdsString = @"";
        
    }
    
    [self refreshActionWithIsRefreshHeaderAction:YES];
}
#pragma cell代理
- (void)RushPurchaseSubTableViewCellClickNoticeButtonWithModel:(RushPurchaseProductModel *)model andIndexPath:(NSIndexPath *)indexPath andNoticeButton:(UIButton *)btn
{
    [YGNetService YGPOST:REQUEST_falshsaleReminding parameters:@{@"usmUserId":YGSingletonMarco.user.userId,@"commodityId":model.commodityId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
//        btn.selected = !btn.selected;
        btn.backgroundColor = [UIColor clearColor];
        if (btn.selected == NO) {
            [YGAppTool showToastWithText:@"开抢前系统会提醒您哦~"];
            [btn setTitle:@"取消提醒" forState:UIControlStateNormal];
            [btn setTitleColor:colorWithLightGray forState:UIControlStateNormal];
            btn.layer.borderColor = colorWithLightGray.CGColor;
            btn.selected = YES;
            
        }else
        {
            [YGAppTool showToastWithText:@"开抢前系统将不会提醒您了哦~"];
            [btn setTitle:@"提醒我" forState:UIControlStateNormal];
            [btn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
            btn.layer.borderColor = colorWithMainColor.CGColor;
            btn.selected = NO;
        }
    } failure:^(NSError *error) {
        
    }];
    
}
@end
