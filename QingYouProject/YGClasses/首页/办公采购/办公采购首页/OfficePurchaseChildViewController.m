//
//  OfficePurchaseChildViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OfficePurchaseChildViewController.h"//子控制器 = 全部,电脑,桌椅...
#import "OfficePurchaseCollectionViewCell.h"//cell
#import "OfficePurchaseModel.h"//模型
#import "OfficePurchaseDetailViewController.h"//办公商品详情页

@interface OfficePurchaseChildViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
/** UICollectionView  */
@property (nonatomic,strong) UICollectionView * collectionView;
/** 数据源  */
@property (nonatomic,strong) NSMutableArray * dataArray;
/** 数据源  */
@property (nonatomic,strong) OfficePurchaseModel * model;
@end

@implementation OfficePurchaseChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = colorWithTable;
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - 网络请求
- (void)setDataType:(NSString *)dataType{
    _dataType = dataType;
}


#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OfficePurchaseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:LDOfficePurchaseCollectionViewCellId forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    
    return  cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    OfficePurchaseDetailViewController * detailVC = [[OfficePurchaseDetailViewController alloc] init];
    detailVC.commodityID = ((OfficePurchaseModel *)self.dataArray[indexPath.row]).commodityID;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}

static NSString * const LDManagerHeaderCellId = @"LDManagerHeaderCellId";


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
static NSString * const LDOfficePurchaseCollectionViewCellId = @"LDOfficePurchaseCollectionViewCellId";

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
//        layOut.minimumLineSpacing = LDHPadding;
//        layOut.minimumInteritemSpacing = LDHPadding;
        
//        CGFloat W = (kScreenW - 3 * LDHPadding) / 2;
        layOut.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);

//        layOut.itemSize = CGSizeMake(W, W + 5 * LDVPadding);
        layOut.itemSize = CGSizeMake((YGScreenWidth-45)/2,  (YGScreenWidth-45)/2+50);
        layOut.minimumLineSpacing = 15;
        layOut.minimumInteritemSpacing = 15;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight - YGNaviBarHeight - floorf(kScreenW / Banner_W_H_Scale)) collectionViewLayout:layOut];
//        _collectionView.contentInset = UIEdgeInsetsMake(2, LDHPadding,2 * LDVPadding, LDVPadding);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [self createRefreshWithScrollView:_collectionView containFooter:YES];
//        [self refreshActionWithIsRefreshHeaderAction:YES];
        [self.collectionView.mj_header beginRefreshing];
        
        _collectionView.backgroundColor = kWhiteColor;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"OfficePurchaseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:LDOfficePurchaseCollectionViewCellId];
        
    }
    return _collectionView;
    
}

//刷新
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    NSDictionary *parameters = @{
                                 @"categoryID":self.dataType,
                                 @"count":self.countString,
                                 @"total":self.totalString
                                 };
    NSString *url = @"ProcurementAllCommodity";
    
//    //如果不是加载过缓存
//    if (!self.isAlreadyLoadCache)
//    {
//        //加载缓存数据
//        NSDictionary *cacheDic = [YGNetService loadCacheWithURLString:url parameter:parameters];
//        [self.dataArray addObjectsFromArray:[OfficePurchaseModel mj_objectArrayWithKeyValuesArray:cacheDic[@"commodityList"]]];
//        [self.collectionView reloadData];
//        self.isAlreadyLoadCache = YES;
//    }
    
    [YGNetService YGPOST:url
              parameters:parameters
         showLoadingView:NO
              scrollView:self.collectionView
                 success:^( id responseObject) {
                     
                     //如果是刷新
                     if (headerAction)
                     {
                         //先移除数据源所有数据
                         [self.dataArray removeAllObjects];
                     }
                     //如果是加载
                     else
                     {
                         //判断服务器返回的数组是不是没数据了，如果没数据
                         if ([responseObject[@"commodityList"] count] == 0)
                         {
                             //调用一下没数据的方法，告诉用户没有更多
                             [self noMoreDataFormatWithScrollView:self.collectionView];
                             return;
                         }
                     }
                     //将字典数组转化为模型数组，再加入到数据源
                     [self.dataArray addObjectsFromArray:[OfficePurchaseModel mj_objectArrayWithKeyValuesArray:responseObject[@"commodityList"]]];
                     //调用加载无数据图的方法
                     [self addNoDataImageViewWithArray:self.dataArray shouldAddToView:self.collectionView headerAction:headerAction];
                     [self.collectionView reloadData];
                 } failure:^(NSError *error)
     {
         [self addNoNetRetryButtonWithFrame:self.collectionView.frame listArray:self.dataArray];
     }];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
