//
//  SQHomeViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeViewController.h"
#import "SQCollectionViewLayout.h"
#import "SQHomeCollectionHeader.h"
#import "SQHomeCollectionViewCell.h"

/** 定位相关  */
#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "JFCityViewController.h"

/** 引导页相关  */
#import "YGStartPageView.h"
/** 手势  */
#import "UIView+SQGesture.h"
#import "UILabel+SQAttribut.h"
/** 选择园区  */
#import "SQChooseGardenVC.h"
/** 跳转工具  */
#import "SQHouseRentPushTool.h"
/** 天气工具  */
#import "SQGetWeatherTool.h"


#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

@interface SQHomeViewController () <SQCollectionViewLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SQHomeCollectionHeaderDeleage, JFLocationDelegate, JFCityViewControllerDelegate>

@property (nonatomic, strong) SQBaseCollectionView        *collectionView;
@property (nonatomic, strong) SQHomeCollectionHeader       *headerView;
@property (nonatomic, strong) SQHomeIndexPageModel       *model;

/** 城市定位管理器*/
@property (nonatomic, strong) JFLocation *locationManager;
/** 城市数据管理器*/
@property (nonatomic, strong) JFAreaDataManager *manager;

@end

@implementation SQHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLaunches];
    [self requestData];
    [self startLoacation];
}

- (void)loadLaunches {
    [KNOTI_CENTER addObserver:self selector:@selector(requestData)name:kNOTI_DIDICHOOSEINNER object:nil];
    if (![YGUserDefaults objectForKey:USERDEF_FIRSTOPENAPP]) {
        NSMutableArray *imageNameArray = [NSMutableArray array];
        for (int i = 0; i<4; i++) {
            [imageNameArray addObject:[NSString stringWithFormat:@"guide_bg%d", i+1]];
        }
        [YGStartPageView showWithLocalPhotoNamesArray:imageNameArray];
        [self isLoginWithParam:[SQChooseGardenVC new]];
    }
}

- (void)configAttribute {
    self.naviTitleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"首页"];
    self.navigationItem.titleView.userInteractionEnabled = YES;
    
    WeakSelf(sqselfweak);
    [self.navigationItem.titleView sq_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [sqselfweak.navigationItem.titleView showWaveAnimation];
        JFCityViewController *cityViewController = [[JFCityViewController alloc] init];
        cityViewController.delegate = sqselfweak;
        cityViewController.title = @"选择城市";
        [sqselfweak.navigationController pushViewController:cityViewController animated:YES];
    }];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.headerView = self.headerView;
    self.headerView.delegate = self;
    [self createRefreshWithScrollView:self.collectionView containFooter:NO];
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop=self.headerView.height;
    self.collectionView.contentOffset=CGPointMake(0, -self.headerView.height);
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    [self requestData];
}

- (void)requestData {
    //获取首页收据
    [SQRequest post:KAPI_INDEXPAGE param:nil success:^(id response) {
        self.model = [SQHomeIndexPageModel yy_modelWithDictionary:response[@"data"]];
        self.headerView.model = self.model;
        [self.collectionView reloadData];
        [self endRefreshWithScrollView:self.collectionView];
    } failure:^(NSError *error) {
        [self endRefreshWithScrollView:self.collectionView];
    } showLoadingView:NO];
    
}

/** 开始定位  */
- (void)startLoacation {
    self.locationManager = [[JFLocation alloc] init];
    self.locationManager.delegate = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.funcs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SQHomeCollectionViewCell *cell = [SQHomeCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.model = self.model.funcs[indexPath.row];
    return cell;
}
- (CGSize)waterfallLayout:(SQCollectionViewLayout *)waterfallLayout atIndexPath:(NSIndexPath *)indexPath {
    SQHomeFuncsModel    *funmodel = self.model.funcs[indexPath.row];
    return funmodel.funcsSize;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell showWaveAnimation];
    SQHomeFuncsModel    *funmodel = self.model.funcs[indexPath.row];
    [self tapedFuncsWithModel:funmodel];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array =  collectionView.indexPathsForVisibleItems;
    if (array.count ==0)return;
    NSIndexPath *firstIndexPath = array[0];
    if (firstIndexPath.row < indexPath.row) {
        [cell showExcursionAnimation];
    }
}

//点击了功能按钮
- (void)tapedFuncsWithModel:(id)model {
    NSString    *pushType = [NSString string];
    NSString    *param = [NSString string];
    if ([model isKindOfClass:[SQHomeBannerModel class]]) {
        //点击了banner或者功能定制按钮
        SQHomeBannerModel   *sqmodel = model;
        pushType = sqmodel.banner_target;
        param = sqmodel.banner_target_params;
        
    } else if ([model isKindOfClass:SQHomeHeadsModel.class]) {
        //点击了头部按钮
        SQHomeHeadsModel   *sqmodel = model;
        pushType = sqmodel.funcs_target;
        param = sqmodel.funcs_target_params;
        
    } else if ([model isKindOfClass:SQHomeFuncsModel.class]) {
        //点击collectionView上的按钮
        SQHomeFuncsModel   *sqmodel = model;
        pushType = sqmodel.funcs_target;
        param = sqmodel.funcs_target_params;
    }
    [SQHouseRentPushTool pushControllerWithType:pushType param:param controller:self];
}


#pragma mark --- JFLocationDelegate
//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSString *city = [locationDictionary valueForKey:@"City"];
    [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
    [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"currentCity"];
    [self.manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
        [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
    }];
    [self cityName:city];
}

#pragma mark - JFCityViewControllerDelegate  选中城市
- (void)cityName:(NSString *)name {//获取城市天气
    [SQGetWeatherTool getTemAndWeatherWithCity:name success:^(NSString *tem, NSString *weather) {
        NSString    *titlestring = [NSString stringWithFormat:@"%@ %@℃ %@", name, tem, weather];
        NSMutableAttributedString   *attstr = [[NSMutableAttributedString alloc] initWithString:titlestring];
        [attstr appendImage:[UIImage imageNamed:@"home_nav_icon"] withType:SQAppendImageInLeft];
        self.naviTitleLabel.attributedText = attstr;
    }];
}


#pragma lazyLoad
- (SQBaseCollectionView *)collectionView {
    if (!_collectionView) {
        SQCollectionViewLayout *layout = [SQCollectionViewLayout waterFallLayoutWithColumnCount:2];
        [layout setColumnSpacing:0 rowSpacing:0 sectionInset:UIEdgeInsetsMake(0, 0, KSCAL(30), 0)];
        CGRect collectFrame = CGRectMake(0, 0, YGScreenWidth, KAPP_HEIGHT-KNAV_HEIGHT-KTAB_HEIGHT);
        _collectionView = [[SQBaseCollectionView alloc] initWithFrame:collectFrame collectionViewLayout:layout];
        _collectionView.backgroundColor = self.view.backgroundColor;;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        layout.delegate = self;
    }
    return _collectionView;
}
- (SQHomeCollectionHeader *)headerView {
    if (!_headerView) {
        CGRect headerFrame = CGRectMake(0, 0, YGScreenWidth, KSCAL(900));
        _headerView = [[SQHomeCollectionHeader alloc] initWithFrame:headerFrame];
    }
    return _headerView;
}
- (JFAreaDataManager *)manager {
    if (!_manager) {
        _manager = [JFAreaDataManager shareInstance];
        [_manager areaSqliteDBData];
    }
    return _manager;
}










@end
