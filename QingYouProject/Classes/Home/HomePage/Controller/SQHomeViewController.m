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

/** 装修板块  */
#import "SQDecorationServeVC.h"

/** 定位相关  */
#import "JFLocation.h"
#import "JFAreaDataManager.h"
#import "JFCityViewController.h"

/** 引导页相关  */
#import "YGStartPageView.h"
/** 手势  */
#import "UIView+SQGesture.h"

#import "NSMutableAttributedString+AppendImage.h"
/** 选择园区  */
#import "SQChooseGardenVC.h"

#import "UILabel+SQAttribut.h"

#import "SQHouseRentPushTool.h"

#import "AFNetworking.h"
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
}

- (void)loadLaunches {
    [KNOTI_CENTER addObserver:self selector:@selector(requestData) name:kNOTI_DIDICHOOSEINNER object:nil];
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
    NSMutableAttributedString   *attstr = [[NSMutableAttributedString alloc] initWithString:@"首页"];
    self.attriTitle = attstr;
    self.navigationItem.titleView.userInteractionEnabled = YES;
    
    WeakSelf(sqselfweak);
    [self.navigationItem.titleView sq_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
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
    [SQRequest setApiAddress:KAPI_ADDRESS_TEST_HJK];
    [SQRequest post:KAPI_INDEXPAGE param:nil success:^(id response) {
        self.model = [SQHomeIndexPageModel yy_modelWithDictionary:response[@"data"]];
        self.headerView.model = self.model;
        //获取定制功能数据
        [SQRequest post:KAPI_CUSBANN param:nil  success:^(id response) {
            self.headerView.cusModel = [SQHomeCustomModel yy_modelWithDictionary:response];
            [self.collectionView reloadData];
            [self endRefreshWithScrollView:self.collectionView];
        } failure:nil];
    } failure:^(NSError *error) {
        NSLog(@"ooooo");
    }];
    [SQRequest setApiAddress:nil];
    [self startLoacation];
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
    SQHomeFuncsModel    *funmodel = self.model.funcs[indexPath.row];
    [self tapedFuncsWithModel:funmodel];
}

//点击了功能按钮
- (void)tapedFuncsWithModel:(id)model {
    NSString    *pushType = [NSString string];
    if ([model isKindOfClass:[SQHomeBannerModel class]]) {
        //点击了banner或者功能定制按钮
        SQHomeBannerModel   *sqmodel = model;
        pushType = sqmodel.banner_target;
        
    } else if ([model isKindOfClass:SQHomeHeadsModel.class]) {
        //点击了头部按钮
        SQHomeHeadsModel   *sqmodel = model;
        pushType = sqmodel.funcs_target;
        
    } else if ([model isKindOfClass:SQHomeFuncsModel.class]) {
        //点击collectionView上的按钮
        SQHomeFuncsModel   *sqmodel = model;
        pushType = sqmodel.funcs_target;
    }
    
    [self pushToPageWithPushType:pushType];
}



- (void)pushToPageWithPushType:(NSString    *)pushType {
    if ([pushType isEqualToString:@"1"]) {
        [SQHouseRentPushTool pushToHouseRentWithController:self];
    } else {
        NSString    *plistFile = KPLIST_FILE(@"SQPushTypePlist");
        NSArray     *pushControlArray = [NSArray arrayWithContentsOfFile: plistFile];
        
        for (NSDictionary *dic in pushControlArray) {
            if ([pushType isEqualToString:dic[@"targetTpye"]]) {
                Class controllerClass = NSClassFromString(dic[@"targetController"]);
                UIViewController *viewController = [[controllerClass alloc] init];
                
                bool    needlogin = [dic[@"needLogin"] boolValue];
                if (needlogin) {
                    if ([self loginOrNot]) {
                        [self.navigationController pushViewController:viewController animated:YES];
                    }
                } else {
                    [self.navigationController pushViewController:viewController animated:YES];
                }
            }
        }
    }
    
}


- (void)homePageDataSource:(SQHomeIndexPageModel *)model {
    self.model = model;
    self.headerView.model = self.model;
}


#pragma mark --- JFLocationDelegate
//定位中...
- (void)locating {
    NSLog(@"定位中...");
}

/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
}

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
    [YGAppTool showToastWithText:@"正在获取天气信息..."];
    NSString *apistr = [NSString stringWithFormat:@"https://www.sojson.com/open/api/weather/json.shtml"];
    NSDictionary    *cityParam = @{@"city":name};
    [[AFHTTPSessionManager manager] GET:apistr parameters:cityParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] isEqual:@200]) {
            NSArray *info = [NSArray arrayWithArray:responseObject[@"data"][@"forecast"]];
            NSString    *titlestring = [NSString stringWithFormat:@"%@ %@℃ %@", name, responseObject[@"data"][@"wendu"], info.firstObject[@"type"]];
            NSMutableAttributedString   *attstr = [[NSMutableAttributedString alloc] initWithString:titlestring];
            [attstr appendImage:[UIImage imageNamed:@"home_nav_icon"] withType:SQAppendImageInLeft];
            self.attriTitle = attstr;
        } else {
            [YGAppTool showToastWithText:@"获取天气信息失败!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [YGAppTool showToastWithText:@"获取天气信息失败!"];
    }];
}


#pragma lazyLoad
- (SQBaseCollectionView *)collectionView {
    if (!_collectionView) {
        SQCollectionViewLayout *layout = [SQCollectionViewLayout waterFallLayoutWithColumnCount:2];
        [layout setColumnSpacing:KSCAL(20) rowSpacing:KSCAL(20) sectionInset:UIEdgeInsetsMake(-KSCAL(20), KSCAL(20), KSCAL(30), KSCAL(20))];
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
