//
//  MeetingAreaChooseViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingAreaChooseViewController.h"
#import "AreaChooseCollectionCell.h"
#import "MeetingBookViewController.h"
#import "MeetingAreaModel.h"
#import "MeetingOrderViewController.h"

@interface MeetingAreaChooseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_mainCollectionView;
    NSMutableArray *_dataArray;
}

@end

@implementation MeetingAreaChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"区域选择";
    
    _dataArray = [NSMutableArray array];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    //设置headerView的尺寸大小
//    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake((YGScreenWidth - 30) / 2, 130);
    
    //2.初始化collectionView
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_mainCollectionView];
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
//    [mainCollectionView registerClass:[AreaChooseCollectionCell class] forCellWithReuseIdentifier:@"AreaChooseCollectionCell"];
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"AreaChooseCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"AreaChooseCollectionCell"];

    //4.设置代理
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    
    [self createRefreshWithScrollView:_mainCollectionView containFooter:YES];
    [_mainCollectionView.mj_header beginRefreshing];
}

//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:REQUEST_getArea parameters:@{@"total":self.totalString,@"count":self.countString} showLoadingView:NO scrollView:_mainCollectionView success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        if (((NSArray *)responseObject[@"aList"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_mainCollectionView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[MeetingAreaModel mj_objectArrayWithKeyValuesArray:responseObject[@"aList"]]];
    
        [self addNoDataImageViewWithArray:_dataArray shouldAddToView:_mainCollectionView headerAction:YES];
        [_mainCollectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//   return 6;
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AreaChooseCollectionCell *cell = (AreaChooseCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AreaChooseCollectionCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.item];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((YGScreenWidth - 30)/ 2, 130);
}

//设/Users/zhaoao/Desktop/git/qingyou/QingYouProject.xcodeproj置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    AreaChooseCollectionCell *cell = (AreaChooseCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    MeetingBookViewController *mbVC = [[MeetingBookViewController alloc]init];
    mbVC.idString = [_dataArray[indexPath.item] valueForKey:@"ID"];
    [self.navigationController pushViewController:mbVC animated:YES];
    
//    MeetingOrderViewController *vc = [[MeetingOrderViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
