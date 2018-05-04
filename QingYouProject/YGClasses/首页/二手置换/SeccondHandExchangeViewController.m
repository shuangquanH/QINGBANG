//
//  SeccondHandExchangeViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/1/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SeccondHandExchangeViewController.h"
#import "YGSegmentView.h"
#import "SeccondHandExchangeCell.h"
#import "SeccondModel.h"
#import "LXScollTitleView.h"
#import "EverydayRecoomedCell.h"
#import "SecondMainCell.h"
#import "TaoETaoViewController.h"
#import "BabyDetailsController.h"
#import "BabyImageCell.h"
#import "SeccondHandExchangeChooseTypeViewController.h"
#import "RealNameCertifyViewController.h"
#import "SecondHandSearchViewController.h"
#import "SecondhandReplacementPersonalHomePageViewController.h"
#import "SecondMainRecommendModel.h"
#import "WorthInModel.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>

#import "SeccondCertifyProfileViewController.h"

#define HEADERHEIGHT (YGScreenWidth * 0.77 + 15 + 45)
#define RecordCount 3      //最多存储3条，自定义
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"SecondHandSearchHistory"]
// 屏幕当前比例
#define OffWidth [UIScreen mainScreen].bounds.size.width / 375
#define OffHeight [UIScreen mainScreen].bounds.size.height / 667

@interface SeccondHandExchangeViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,UIScrollViewDelegate,YGSegmentViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    UIView *_blackView; //黑色遮罩
    NSMutableArray *_historyListArray;//历史记录array
    UIView *_headerView;  //整个的headerView
    NSMutableArray *_titlesArry; //滑动菜单数组
    UIButton *_backButton;
    SDCycleScrollView *_adScrollview; //广告轮播
    UIView          *_baseView;
    NSMutableArray * _controllersArray;//Controller数组
    YGSegmentView * _segmentView;//选择器
    YGSegmentView *_tableSegmentView;
    UIScrollView * _scrollView; 
}
@property(nonatomic,strong)UICollectionView * recommendCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;  //数据源
@property (nonatomic, strong) LXScollTitleView *topTitleView; //最上面被隐藏的滑动菜单栏
@property (nonatomic, strong) LXScollTitleView *titleView; //滑动菜单栏
@property(nonatomic,strong)UITableView *searchHistoryTableView; //搜索历史的tableView
@property (nonatomic, strong) NSMutableArray *imageArray; //图片数组
@property (nonatomic, strong) NSString *allianceID;
@property(nonatomic,strong)NSMutableArray *activityTagArray; //活动标签数组带id
@property(nonatomic,strong)NSMutableArray *bannerListArray; //轮播图数组带id
@property(nonatomic,strong)NSString *tid;//标签id
@property(nonatomic,strong)UIView *topSearchView;
@property(nonatomic,strong)UISearchBar *topSearchBar;//上面的搜索框
@property(nonatomic,strong)UISearchBar *bottomSearchBar;//下面的搜索框
@property(nonatomic,strong)UIButton *topCancleButton;
@property(nonatomic,strong)NSString *typeString;//1值得换2附近的3淘一淘
@property (nonatomic, strong) NSMutableArray *recommendArray;  //滑动数组
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)NSString *currentCity;//长春市
@property(nonatomic,strong)NSString *nowLocalAddress;//吉林省长春市
@property(nonatomic,strong)NSString *locateAddress;//传给后台的地址

@end

@implementation SeccondHandExchangeViewController

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
    
    self.bottomSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10 * OffWidth, 5, YGScreenWidth - 40 - 10 * OffWidth - 40 * OffWidth, YGNaviBarHeight - 10)];
    self.bottomSearchBar.placeholder = @"搜索感兴趣的物品";
    self.bottomSearchBar.delegate = self;
    self.bottomSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.bottomSearchBar.tintColor = [UIColor whiteColor];
    self.bottomSearchBar.barTintColor = [UIColor whiteColor];
//    searchBar.inputAccessoryView = [[UIView alloc]init];
    
    // 改变UISearchBar内部输入框样式
    UIView *searchTextFieldView = nil;
    searchTextFieldView = [[[self.bottomSearchBar.subviews firstObject] subviews] lastObject];
    // 改变输入框背景色
    searchTextFieldView.subviews[0].superview.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    searchTextFieldView.layer.cornerRadius = 1.0;
    [searchTextFieldView setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGNaviBarHeight)];
    UITextField *searchTextField = [self.bottomSearchBar valueForKey:@"_searchField"];
    if([searchTextField isKindOfClass:UITextField.class])
    {
        searchTextField.font = [UIFont systemFontOfSize:14.0];
    }
    
    [navView addSubview:self.bottomSearchBar];
    self.navigationItem.titleView = navView;
    
    _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight)];
    _blackView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sortButton setFrame:CGRectMake(10 * OffWidth, 0, 30 * OffWidth, 44)];
    [sortButton setImage:[UIImage imageNamed:@"unused_category"] forState:UIControlStateNormal];
    [sortButton setTitle:@"" forState:UIControlStateNormal];
//    sortButton.backgroundColor = colorWithRedColor;
    [sortButton addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //修改方法
    UIView *sortView = [[UIView alloc] initWithFrame:CGRectMake(10 * OffWidth, 0, 30 * OffWidth, 44)];
    [sortView addSubview:sortButton];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:sortView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.dataArray = [NSMutableArray array];
    self.recommendArray = [NSMutableArray array];
    self.imageArray = [NSMutableArray array];
    
    self.typeString = @"1";
    
    [self locatemap];
    
    self.locateAddress = @"";
    
    [self loadData];
    
    
}
//首页轮播图、每日推荐
-(void)loadData
{
    [YGNetService YGPOST:@"getHomePagePic" parameters:@{} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        self.imageArray = responseObject[@"img"];
        
        [YGNetService YGPOST:@"RecommendedDaily" parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
            
            NSLog(@"%@",responseObject);
            
            self.recommendArray = [SecondMainRecommendModel mj_objectArrayWithKeyValuesArray:responseObject[@"merchandise"]];
            
            [self configUI];
            
            [self configBottomButton];
            
        } failure:^(NSError *error) {
            
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    if (headerAction == YES) {
        self.totalString = @"0";
    }
    if (!self.locateAddress.length) {
        self.locateAddress = @"";
    }
    [YGNetService YGPOST:@"WorthIn" parameters:@{@"type":self.typeString,@"total":self.totalString,@"count":self.countString,@"address":self.locateAddress} showLoadingView:YES scrollView:_tableView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        if (((NSArray *)responseObject[@"merchandise"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_tableView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[WorthInModel mj_objectArrayWithKeyValuesArray:responseObject[@"merchandise"]]];
//        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_tableView headerAction:YES];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)configUI
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight - YGStatusBarHeight - YGNaviBarHeight) style:UITableViewStyleGrouped];
    [_tableView registerClass:[SecondMainCell class] forCellReuseIdentifier:@"SecondMainCell"];
    _tableView.backgroundColor = colorWithTable;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 0.001)];
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.sectionFooterHeight = 10;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_tableView];

    /********************** 头视图两个按钮 *****************/
     _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 1.27 + 10 + 10 + 40)];
    _headerView.backgroundColor = colorWithPlateSpacedColor;
    [self.view addSubview:_baseView];
    
//    self.imageArray = [NSMutableArray array];
//    self.imageArray = @[@"0.jpg",@"5.jpg",@"6.jpg"].mutableCopy;
    NSLog(@"%@",self.imageArray);
   
    //广告滚动
    _adScrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth/2) delegate:self placeholderImage:YGDefaultImgTwo_One];
    _adScrollview.imageURLStringsGroup = self.imageArray;
    _adScrollview.autoScroll = YES;
    _adScrollview.infiniteLoop = YES;
//    _adScrollview.localizationImageNamesGroup = self.imageArray;
    [_headerView addSubview:_adScrollview];
    
    
    UIView *activityView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenWidth / 2, YGScreenWidth, YGScreenWidth * 0.28)];
    [_headerView addSubview:activityView];
    
    UIButton *weekendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weekendButton.frame = CGRectMake(0, 0, YGScreenWidth / 3, YGScreenWidth * 0.28);
    [weekendButton setTitle:@"我要换" forState:UIControlStateNormal];
    [weekendButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [weekendButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [weekendButton setImage:[UIImage imageNamed:@"unused_changed"] forState:UIControlStateNormal];
    weekendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [weekendButton setTitleEdgeInsets:UIEdgeInsetsMake(weekendButton.imageView.frame.size.height + 10,-weekendButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [weekendButton setImageEdgeInsets:UIEdgeInsetsMake(-weekendButton.titleLabel.bounds.size.height, 0.0,0.0, -weekendButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [activityView addSubview:weekendButton];
    [weekendButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    weekendButton.backgroundColor = [UIColor whiteColor];
    
    UIButton *unionlapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unionlapButton.frame = CGRectMake(YGScreenWidth / 3, 0, YGScreenWidth / 3, YGScreenWidth * 0.28);
    [unionlapButton setTitle:@"淘一淘" forState:UIControlStateNormal];
    [unionlapButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [unionlapButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [unionlapButton setImage:[UIImage imageNamed:@"unused_all"] forState:UIControlStateNormal];
    unionlapButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [unionlapButton setTitleEdgeInsets:UIEdgeInsetsMake(unionlapButton.imageView.frame.size.height + 10,-unionlapButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [unionlapButton setImageEdgeInsets:UIEdgeInsetsMake(-unionlapButton.titleLabel.bounds.size.height, 0.0,0.0, -unionlapButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [unionlapButton addTarget:self action:@selector(taoyitao:) forControlEvents:UIControlEventTouchUpInside];
    [activityView addSubview:unionlapButton];
    unionlapButton.backgroundColor = [UIColor whiteColor];
    
    UIButton *unionerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    unionerButton.frame = CGRectMake(YGScreenWidth / 3 * 2, 0, YGScreenWidth / 3, YGScreenWidth * 0.28);
    [unionerButton setTitle:@"我的置换" forState:UIControlStateNormal];
    [unionerButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [unionerButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [unionerButton setImage:[UIImage imageNamed:@"unused_mine"] forState:UIControlStateNormal];
    unionerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [unionerButton setTitleEdgeInsets:UIEdgeInsetsMake(unionerButton.imageView.frame.size.height + 10,-unionerButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [unionerButton setImageEdgeInsets:UIEdgeInsetsMake(-unionerButton.titleLabel.bounds.size.height, 0.0,0.0, -unionerButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [activityView addSubview:unionerButton];
    [unionerButton addTarget:self action:@selector(displace:) forControlEvents:UIControlEventTouchUpInside];
    unionerButton.backgroundColor = [UIColor whiteColor];
    
    
    UIView *recommendView = [[UIView alloc]init];
    recommendView.frame = CGRectMake(0, YGScreenWidth * 0.78 + 10, YGScreenWidth, YGScreenWidth * 0.49);
    recommendView.backgroundColor = [UIColor whiteColor];
    
    UILabel *recommendLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, YGScreenWidth - 10, YGScreenWidth * 0.11)];
    recommendLabel.textAlignment = NSTextAlignmentLeft;
    recommendLabel.text = @"每日推荐";
    recommendLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [recommendView addSubview:recommendLabel];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((YGScreenWidth - 33) / 3, YGScreenWidth * 0.38)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 0, 8, 0);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    
    self.recommendCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 0.11, YGScreenWidth, YGScreenWidth * 0.38) collectionViewLayout:flowLayout];
    UINib *nib = [UINib nibWithNibName:@"EverydayRecoomedCell"
                                bundle: [NSBundle mainBundle]];
    [self.recommendCollectionView registerNib:nib forCellWithReuseIdentifier:@"EverydayRecoomedCell"];
    self.recommendCollectionView.showsHorizontalScrollIndicator = NO;
    self.recommendCollectionView.delegate = self;
    self.recommendCollectionView.dataSource = self;
    //    self.recommendCollectionView.backgroundColor = RGB(235, 235, 235);
    self.recommendCollectionView.backgroundColor = [UIColor whiteColor];

    [recommendView addSubview:self.recommendCollectionView];
    
    [_headerView addSubview:recommendView];
    
    [self createRefreshWithScrollView:_tableView containFooter:YES];
    [_tableView.mj_header beginRefreshing];
    
    [self configSegement];
    
}

-(void)configSegement
{
    /********************** 选择器 ********************/;
    //选择页面按钮
    _tableSegmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 1.27 + 20, YGScreenWidth, 40) titlesArray:@[@"值得换",@"附近的"] lineColor:colorWithMainColor delegate:self];
    _tableSegmentView.backgroundColor = colorWithYGWhite;
    _tableSegmentView.lineColor = colorWithMainColor;
    [_headerView addSubview:_tableSegmentView];
    
    //默认第0页
    [self segmentButtonClickWithIndex:0];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, YGScreenWidth * 1.27 + 59, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithLine;
    [_headerView addSubview:lineView];
    
    _tableView.tableHeaderView = _headerView;
    
    //选择页面按钮
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"值得换",@"附近的"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithTable;
    [self.view addSubview:_segmentView];
    _segmentView.hidden = YES;
}

-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [_segmentView selectButtonWithIndex:buttonIndex];
    [_tableSegmentView selectButtonWithIndex:buttonIndex];
    if (buttonIndex == 0) {
        self.typeString = @"1";
        self.locateAddress = @"";
        [self refreshActionWithIsRefreshHeaderAction:YES];
        
    }else
    {
        self.typeString = @"2";
        self.locateAddress = self.nowLocalAddress;
        [self refreshActionWithIsRefreshHeaderAction:YES];
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondMainCell" forIndexPath:indexPath];
    if(self.dataArray.count)
    {
        cell.model = self.dataArray[indexPath.section];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (YGScreenWidth - 30) / 3 + 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView == self.searchHistoryTableView)
//    {
//        [self addSearchRecord:_historyListArray[indexPath.row]];
//        [_blackView removeFromSuperview];
//
//        BabyDetailsController *vc = [[BabyDetailsController alloc]init];
//        vc.idString = [_dataArray[indexPath.section] valueForKey:@"ID"];
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }else
//    {
        BabyDetailsController *vc = [[BabyDetailsController alloc]init];
        vc.idString = [_dataArray[indexPath.section] valueForKey:@"ID"];
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark ---- DiscoverySubViewController上拉滑动更新位置代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = scrollView.contentOffset;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGFloat height = _headerView.height;//偏移量
        if (translation.y > height - _segmentView.height)//向下拉是负值，向上是正
        {
            _segmentView.hidden = NO;
        }
        else if(translation.y < height)
        {
            _segmentView.hidden = YES;
        }
    
    } completion:nil];
}


#pragma -mark CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.recommendArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EverydayRecoomedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EverydayRecoomedCell" forIndexPath:indexPath];
    if(self.recommendArray.count)
    {
        cell.model = self.recommendArray[indexPath.item];
    }
    cell.contentView.clipsToBounds = YES;
    return cell;
}

//推荐滑动列表collectionview的选中方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BabyDetailsController *vc = [[BabyDetailsController alloc]init];
    vc.idString = [self.recommendArray[indexPath.item] valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

//SDCycleView的delegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
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

//分类
-(void)sortClick:(UIButton *)button
{
    SeccondHandExchangeChooseTypeViewController *vc = [[SeccondHandExchangeChooseTypeViewController alloc] init];
    vc.pageType  = @"SeccondHandExchangeMainSearch";
    [self.navigationController pushViewController:vc animated:YES];
}

////我要换
//-(void)wantChange:(UIButton *)button
//{
//}

//淘一淘
-(void)taoyitao:(UIButton *)button
{
    TaoETaoViewController *vc = [[TaoETaoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//我的置换
-(void)displace:(UIButton *)button
{
    SecondhandReplacementPersonalHomePageViewController * persinalHomePage = [[SecondhandReplacementPersonalHomePageViewController alloc]init];
    [self.navigationController pushViewController:persinalHomePage animated:YES];
}

//悬浮按钮点击事件&&我要换
-(void)addButtonClick:(UIButton *)button
{
    button.userInteractionEnabled = NO;
    
    [YGNetService YGPOST:REQUEST_userInformation parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        button.userInteractionEnabled = YES;
        
        YGSingletonMarco.user.isUploadBaseInfoForSeccondHand =[responseObject[@"user"] boolValue];
        //没填过信息
        if (YGSingletonMarco.user.isUploadBaseInfoForSeccondHand == FALSE )
        {
            // 查询是否认证过
            [YGNetService YGPOST:REQUEST_authentication parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                button.userInteractionEnabled = YES;
                
                YGSingletonMarco.user.isCertified =[responseObject[@"zhiMaXinYong"] boolValue];
                //没认证过
                if (YGSingletonMarco.user.isCertified == NO) {
                    
                    [YGAlertView showAlertWithTitle:@"发布二手置换需要进行身份认证，\n是否现在进行认证？" buttonTitlesArray:@[@"取消",@"确定"] buttonColorsArray:@[colorWithPlaceholder,colorWithMainColor] handler:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            RealNameCertifyViewController *controller = [[RealNameCertifyViewController alloc]init];
                            controller.pageType  = @"SeccondHandExchangeMain";
                            [self.navigationController pushViewController:controller animated:YES];
                            return ;
                        }
                    }];
                }else
                {
                    //认证过 没填过信息
                    SeccondCertifyProfileViewController *vc = [[SeccondCertifyProfileViewController alloc] init];
                    vc.pageType  = @"SeccondHandExchangeMain";
                    [self.navigationController pushViewController:vc animated:YES];
                    return ;
                    
                }
                
            } failure:^(NSError *error) {
                button.userInteractionEnabled = YES;
                
            }];
            
            
        }else
        {
            //天国信息直接选择分类
            button.userInteractionEnabled = YES;
            SeccondHandExchangeChooseTypeViewController *vc = [[SeccondHandExchangeChooseTypeViewController alloc] init];
            vc.pageType  = @"SeccondHandExchangeMain";
            [self.navigationController pushViewController:vc animated:YES];
        }

        
    } failure:^(NSError *error) {
        button.userInteractionEnabled = YES;
        
    }];
    
    
}


//搜索
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    SecondHandSearchViewController *vc = [[SecondHandSearchViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    if (searchBar == self.topSearchBar)
    {
        return;
    }
    [self.view addSubview:_blackView];
    self.topSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, YGStatusBarHeight, YGScreenWidth, YGNaviBarHeight)];
    self.topSearchView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:self.topSearchView];
    
//    [self configSearchHistoryTableView];
    
    self.topSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(15, 5, YGScreenWidth - 15 - 50 , YGNaviBarHeight - 10)];
    self.topSearchBar.placeholder = @"搜索感兴趣的物品";
    self.topSearchBar.delegate = self;
    self.topSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.topSearchBar.tintColor = [UIColor whiteColor];
    self.topSearchBar.barTintColor = [UIColor whiteColor];
//    self.topSearchBar.inputAccessoryView = [[UIView alloc]init];
    self.topSearchBar.text = searchBar.text;
    
    // 改变UISearchBar内部输入框样式
    UIView *searchTextFieldView = nil;
    searchTextFieldView = [[[self.topSearchBar.subviews firstObject] subviews] lastObject];
    // 改变输入框背景色
    searchTextFieldView.subviews[0].superview.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    searchTextFieldView.layer.cornerRadius = 2.0;
    [searchTextFieldView setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGNaviBarHeight)];
    UITextField *searchTextField = [self.topSearchBar valueForKey:@"_searchField"];
    if([searchTextField isKindOfClass:UITextField.class])
    {
        searchTextField.font = [UIFont systemFontOfSize:14.0];
    }
    [navView addSubview:self.topSearchBar];
    [self.topSearchView addSubview:navView];
    
    self.topCancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.topCancleButton.frame = CGRectMake(YGScreenWidth - 50, 0, 50, YGNaviBarHeight);
    [self.topCancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.topCancleButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.topCancleButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [self.topCancleButton addTarget:self action:@selector(topCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.topSearchView addSubview:self.topCancleButton];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.bottomSearchBar.text = searchText;
    self.topSearchBar.text = searchText;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.topSearchBar resignFirstResponder];
    [self.bottomSearchBar resignFirstResponder];
    [self.topSearchView removeFromSuperview];
    [_blackView removeFromSuperview];
}

//取消
-(void)topCancel:(UIButton *)button
{
    [self.bottomSearchBar resignFirstResponder];
    [self.topSearchBar resignFirstResponder];
    [self.topSearchView removeFromSuperview];
    [_blackView removeFromSuperview];
    
}
//搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self addSearchRecord:searchBar.text];
    
    [self.topSearchBar resignFirstResponder];
    [self.bottomSearchBar resignFirstResponder];
    [self.topSearchView removeFromSuperview];
    [_blackView removeFromSuperview];
   SecondHandSearchViewController *vc = [[SecondHandSearchViewController alloc]init];
   vc.searchString = searchBar.text;
   [self.navigationController pushViewController:vc animated:YES];
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

//清除搜索历史
-(void)clearHistoryButtonClick:(UIButton *)button
{
    [self clearAllSearchHistory];
    _historyListArray = [self getAllSearchHistory].mutableCopy;
    [self.searchHistoryTableView reloadData];
    
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


- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
//        [_locationManager requestAlwaysAuthorization];
        _currentCity = [[NSString alloc]init];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    
    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
            //            if (!_currentCity) {
            //                _currentCity = @"无法定位当前城市";
            //            }
            //看需求定义一个全局变量来接收赋值
            
            if (!_currentCity) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                self.nowLocalAddress = placeMark.administrativeArea;
            }else
            {
                //                self.nowLocalAddress = [NSString stringWithFormat:@"%@,%@",placeMark.administrativeArea,_currentCity];
                self.nowLocalAddress = _currentCity;
            }
            
            //            [self.tableView reloadData];
            
        }else if (error == nil && placemarks.count){
            
            NSLog(@"NO location and error return");
        }else if (error){
            
            NSLog(@"loction error:%@",error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{ //此方法为定位失败的时候调用。并且由于会在失败以后重新定位，所以必须在末尾停止更新
    
    if(error.code == kCLErrorLocationUnknown)
    {
        NSLog(@"Currently unable to retrieve location.");
    }
    else if(error.code == kCLErrorNetwork)
    {
        NSLog(@"Network used to retrieve location is unavailable.");
    }
    else if(error.code == kCLErrorDenied)
    {
        NSLog(@"Permission to retrieve location is denied.");
        [manager stopUpdatingLocation];
    }
}

@end
