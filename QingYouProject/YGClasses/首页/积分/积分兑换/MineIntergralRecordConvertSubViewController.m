//
//  MineIntergralRecordConvertSubViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralRecordConvertSubViewController.h"
#import "MineIntergralRecordConvertSubCollectionViewCell.h"
#import "MineIntergralRecordConvertModel.h"
#import "MineIntergralRecordConvertDetailViewController.h"

@interface MineIntergralRecordConvertSubViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView            *_collectionView;   //
    NSMutableArray *_listArray;
}

@end

@implementation MineIntergralRecordConvertSubViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.frame = self.controllerFrame;
    _listArray = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //每个section内置设置的大小
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    flowLayout.itemSize = CGSizeMake((YGScreenWidth -  4 * 15)/3, (YGScreenWidth -  4 * 15)/3+50);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 1, YGScreenWidth, YGScreenHeight-64-40) collectionViewLayout:flowLayOut];
    _collectionView.backgroundColor = colorWithYGWhite;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[MineIntergralRecordConvertSubCollectionViewCell class] forCellWithReuseIdentifier:@"MineIntergralRecordConvertSubCollectionViewCell"];
    
    
    
    [self createRefreshWithScrollView:_collectionView containFooter:YES];
    [_collectionView.mj_header beginRefreshing];
    

}

- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"IntegralMerchandise" parameters:@{@"classifiId":_model.ID,@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_collectionView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if (headerAction == YES) {
            [_listArray removeAllObjects];
        }
        if ([responseObject[@"list1"] count] < [YGPageSize intValue]) {
            [self noMoreDataFormatWithScrollView:_collectionView];
        }
        [_listArray addObjectsFromArray:[MineIntergralRecordConvertModel mj_objectArrayWithKeyValuesArray:responseObject[@"list1"]]];
        [self addNoDataImageViewWithArray:_listArray shouldAddToView:_collectionView headerAction:headerAction];
        [_collectionView reloadData];

    } failure:^(NSError *error) {

    }];


}

#pragma mark ---- UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineIntergralRecordConvertSubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineIntergralRecordConvertSubCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    MineIntergralRecordConvertModel *model = _listArray[indexPath.row];
    cell.model = model;
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MineIntergralRecordConvertModel *model = _listArray[indexPath.row];
    MineIntergralRecordConvertDetailViewController *vc = [[MineIntergralRecordConvertDetailViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
    vc.idString = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((YGScreenWidth-45)/2, (YGScreenWidth-45)/2+50);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //左右的又兼具
    return UIEdgeInsetsMake(15,15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //上下距离
    return 15;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //给5 相等了
    
    return 15;
    
}

@end
