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
#import "YGAlertView.h"
/** 装修板块  */
#import "SQDecorationServeVC.h"




@interface SQHomeViewController () <SQCollectionViewLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SQHomeCollectionHeaderDeleage>

@property (nonatomic, strong) SQBaseCollectionView        *collectionView;
@property (nonatomic, strong) SQHomeCollectionHeader       *headerView;
@property (nonatomic, strong) SQHomeIndexPageModel       *model;

@end

@implementation SQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"首页";
    [self.view addSubview:self.collectionView];
    self.collectionView.headerView = self.headerView;
    self.headerView.delegate = self;
    [self createRefreshWithScrollView:self.collectionView containFooter:NO];
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop=self.headerView.height;
    self.collectionView.contentOffset=CGPointMake(0, -self.headerView.height);
    [self requestData];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    [self requestData];
}

- (void)requestData {
    //获取首页收据
    [SQRequest post:KAPI_INDEXPAGE param:@{@"isInner":@"yes"} success:^(id response) {
        self.model = [SQHomeIndexPageModel yy_modelWithDictionary:response];
    } failure:^(NSError *error) {
        [self endRefreshWithScrollView:self.collectionView];
    }];
    //获取定制功能数据
    [SQRequest post:KAPI_CUSBANN param:@{@"userid":@"1"} success:^(id response) {
        self.headerView.cusModel = [SQHomeCustomModel yy_modelWithDictionary:response];
    } failure:nil];
}

- (void)setModel:(SQHomeIndexPageModel *)model {
    _model = model;
    self.headerView.model = model;
    [self.collectionView reloadData];
    [self endRefreshWithScrollView:self.collectionView];
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
    NSString    *string = [NSString stringWithFormat:@"点击了第%ld个按钮", indexPath.row];
    [self tapedFuncsWithModel:string];
}

//点击了功能按钮
- (void)tapedFuncsWithModel:(id)model {
    if ([model isKindOfClass:[SQHomeBannerModel class]]) {
        //点击了banner或者功能定制按钮
        SQHomeBannerModel   *sqmodel = model;
        [YGAlertView showAlertWithTitle:sqmodel.banner_image_url
                      buttonTitlesArray:@[@"YES", @"NO"]
                      buttonColorsArray:@[[UIColor blueColor],
                                          [UIColor redColor]] handler:nil];
        
    } else if ([model isKindOfClass:SQHomeHeadsModel.class]) {
        //点击了头部按钮
        SQHomeHeadsModel   *sqmodel = model;
        [YGAlertView showAlertWithTitle:sqmodel.funcs_image_url
                      buttonTitlesArray:@[@"YES", @"NO"]
                      buttonColorsArray:@[[UIColor blueColor],
                                          [UIColor redColor]] handler:nil];
        
    } else if ([model isKindOfClass:SQHomeFuncsModel.class]) {
        //点击collectionView上的按钮
        SQHomeFuncsModel   *sqmodel = model;
        [YGAlertView showAlertWithTitle:sqmodel.funcs_image_url
                      buttonTitlesArray:@[@"YES", @"NO"]
                      buttonColorsArray:@[[UIColor blueColor],
                                          [UIColor redColor]] handler:nil];
    }
    [self.navigationController pushViewController:[SQDecorationServeVC new] animated:YES];
}




#pragma lazyLoad
- (SQBaseCollectionView *)collectionView {
    if (!_collectionView) {
        SQCollectionViewLayout *layout = [SQCollectionViewLayout waterFallLayoutWithColumnCount:2];
        [layout setColumnSpacing:0 rowSpacing:0 sectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        CGRect collectFrame = CGRectMake(0, 0, YGScreenWidth, KAPP_HEIGHT-KNAV_HEIGHT-KTAB_HEIGHT);
        _collectionView = [[SQBaseCollectionView alloc] initWithFrame:collectFrame collectionViewLayout:layout];
        _collectionView.backgroundColor = self.view.backgroundColor;
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











@end
