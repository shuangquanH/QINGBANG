//
//  AllGoodsViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllGoodsViewController.h"
#import "SeccondHandExchangeCell.h"
#import "SeccondModel.h"

@interface AllGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView            *_collectionView;   //
    NSMutableArray *_listArray;
}

@end

@implementation AllGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self loadDataFromServer];
}

- (void)configUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _listArray = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //每个section内置设置的大小
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    flowLayout.itemSize = CGSizeMake((YGScreenWidth -  4 * 15)/3, (YGScreenWidth -  4 * 15)/3);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64-60) collectionViewLayout:flowLayOut];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[SeccondHandExchangeCell class] forCellWithReuseIdentifier:@"CaseCollectionViewCell"];
    
}

- (void)loadDataFromServer
{
    NSArray *resp = @[
                      @{
                          @"img":@"http://p3.pstatp.com/large/7da00044500ae0789b3?123.jpg",
                          @"title":@"66号公路"
                          },
                      @{
                          @"img":@"http://p3.pstatp.com/large/7da00044500ae0789b3?123.jpg",
                          @"title":@"66号公路"
                          },
                      @{
                          @"img":@"http://p3.pstatp.com/large/7da00044500ae0789b3?123.jpg",
                          @"title":@"66号公路"
                          },
                      @{
                          @"img":@"http://p3.pstatp.com/large/7da00044500ae0789b3?123.jpg",
                          @"title":@"66号公路"
                          },
                      @{
                          @"img":@"http://p3.pstatp.com/large/7da00044500ae0789b3?123.jpg",
                          @"title":@"66号公路"
                          },
                      @{
                          @"img":@"http://p3.pstatp.com/large/7da00044500ae0789b3?123.jpg",
                          @"title":@"66号公路"
                          },
                      @{
                          @"img":@"http://p3.pstatp.com/large/7da00044500ae0789b3?123.jpg",
                          @"title":@"66号公路"
                          },
                      @{
                          @"img":@"http://p3.pstatp.com/large/7da00044500ae0789b3?123.jpg",
                          @"title":@"66号公路"
                          },
                      @{
                          @"img":@"http://p3.pstatp.com/large/7da00044500ae0789b3?123.jpg",
                          @"title":@"66号公路"
                          }
                      ];
        [_listArray addObjectsFromArray:[SeccondModel mj_objectArrayWithKeyValuesArray:resp]];
    [_collectionView reloadData];
    
}


#pragma mark ---- UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeccondHandExchangeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CaseCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    SeccondModel *model = _listArray[indexPath.row];
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
    
}
#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake((YGScreenWidth-45)/2, (YGScreenWidth-45)/2*1.04);
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
