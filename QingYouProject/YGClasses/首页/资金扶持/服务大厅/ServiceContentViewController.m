//
//  ServiceContentViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ServiceContentViewController.h"
#import "ServiceContentCollectionViewCell.h"
#import "ServiceResonModel.h"

@interface ServiceContentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView            *_collectionView;   //
    NSMutableArray *_listArray;
}

@end

@implementation ServiceContentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)configAttribute
{
    self.naviTitle = @"我们为您解决什么";
}
- (void)loadData
{
    [YGNetService YGPOST:REQUEST_ServiceHall parameters:@{@"serviceType":@"2"} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        [_listArray addObjectsFromArray:[ServiceResonModel mj_objectArrayWithKeyValuesArray:responseObject[@"list1"]]];
        [_collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)configUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _listArray = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //每个section内置设置的大小
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    flowLayout.itemSize = CGSizeMake((YGScreenWidth-45)/2, 125);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) collectionViewLayout:flowLayOut];
    _collectionView.backgroundColor = colorWithTable;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ServiceContentCollectionViewCell class] forCellWithReuseIdentifier:@"ServiceContentCollectionViewCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];

    [self loadData];
}



#pragma mark ---- UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServiceContentCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.model = _listArray[indexPath.row];
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
    
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((YGScreenWidth-45)/2, 125);
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
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        
        //左线
        UIImageView *caseLeftLineImageView = [[UIImageView alloc]init];
        caseLeftLineImageView.frame = CGRectMake(10,20, 2, 20);
        caseLeftLineImageView.backgroundColor = colorWithMainColor;
        [headerView addSubview:caseLeftLineImageView];
        
        UILabel *caseLeaderLabel = [[UILabel alloc] init];
        caseLeaderLabel.textColor = colorWithBlack;
        caseLeaderLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
        caseLeaderLabel.text = @"商业计划书类型";
        caseLeaderLabel.frame = CGRectMake(18, caseLeftLineImageView.y, YGScreenWidth-20, 25);
        [headerView addSubview:caseLeaderLabel];
        caseLeaderLabel.centery = caseLeftLineImageView.centery;
        
        return headerView;
        
    }
    
    return nil;
    
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(YGScreenWidth, 45);
}


@end
