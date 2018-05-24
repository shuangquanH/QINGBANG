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

@end

@implementation SQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"首页";
    [self.view addSubview:self.collectionView];
    self.collectionView.headerView = self.headerView;
    self.headerView.delegate = self;
    self.headerView.scrollViewData = @[@"ahc", @"hahah"];
    [self createRefreshWithScrollView:self.collectionView containFooter:NO];
    self.collectionView.mj_header.ignoredScrollViewContentInsetTop=self.headerView.height;
    
    [self requestData];
}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction {
    [self.collectionView.mj_header endRefreshing];
}

- (void)requestData {
    [SQRequest post:@"getIndexPage" param:@{@"type":@"waitForPay"} success:^(id response) {
        NSLog(@"dd");
    } failure:^(NSError *error) {
        NSLog(@"dd");
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SQHomeCollectionViewCell *cell = [SQHomeCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    return cell;
}
- (CGSize)waterfallLayout:(SQCollectionViewLayout *)waterfallLayout atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%3==0) {
        return CGSizeMake(168, 210);
    } else if (indexPath.row%7==0) {
        return CGSizeMake(168, 210);
    } else {
        return CGSizeMake(168, 100);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString    *string = [NSString stringWithFormat:@"点击了第%ld个按钮", indexPath.row];
    [self tapedFuncsWithModel:string];
}
- (void)tapedFuncsWithModel:(NSString *)model {
    [self.navigationController pushViewController:[SQDecorationServeVC new] animated:YES];
    [YGAlertView showAlertWithTitle:model buttonTitlesArray:@[@"YES", @"NO"] buttonColorsArray:@[[UIColor blueColor], [UIColor redColor]] handler:nil];
}




#pragma lazyLoad
- (SQBaseCollectionView *)collectionView {
    if (!_collectionView) {
        SQCollectionViewLayout *layout = [SQCollectionViewLayout waterFallLayoutWithColumnCount:2];
        [layout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(0, 15, 10, 15)];
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
        CGRect headerFrame = CGRectMake(0, 0, YGScreenWidth, 570);
        _headerView = [[SQHomeCollectionHeader alloc] initWithFrame:headerFrame];
    }
    return _headerView;
}











@end
