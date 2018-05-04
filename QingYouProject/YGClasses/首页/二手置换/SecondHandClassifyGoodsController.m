//
//  SecondHandClassifyGoodsController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondHandClassifyGoodsController.h"
#import "SecondClassifyGoodsCell.h"
#import "SecondClassfilyGoodsModel.h"
#import "BabyDetailsController.h"

@interface SecondHandClassifyGoodsController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_mainCollectionView;
    NSMutableArray *_dataArray;
    NSString *_headerImageString;
}

@end

@implementation SecondHandClassifyGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = self.titleString;
    
    _dataArray = [NSMutableArray array];
    
    [self loadHeaderData];
    
}

-(void)loadHeaderData
{
    [YGNetService YGPOST:@"getClassifyPic" parameters:@{} showLoadingView:YES scrollView:_mainCollectionView success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        _headerImageString = responseObject[@"img"];
        
        [self configUI];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)configUI
{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
//    layout.headerReferenceSize = CGSizeMake(YGScreenWidth, YGScreenWidth * 0.5);
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake((YGScreenWidth - 30) / 2, (YGScreenWidth - 30) / 2 * 1.32);
    
    //2.初始化collectionView
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_mainCollectionView];
    _mainCollectionView.backgroundColor = [UIColor clearColor];

    //3.注册collectionViewCell
    //    [mainCollectionView registerClass:[AreaChooseCollectionCell class] forCellWithReuseIdentifier:@"AreaChooseCollectionCell"];
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"SecondClassifyGoodsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SecondClassifyGoodsCell"];
    
    //头视图
    UIImageView *headerImageView = [[UIImageView alloc]init];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:_headerImageString] placeholderImage:YGDefaultImgTwo_One];
    _mainCollectionView.contentInset = UIEdgeInsetsMake(YGScreenWidth * 0.5, 0, 0, 0);
    headerImageView.frame = CGRectMake(0, -YGScreenWidth * 0.5, YGScreenWidth, YGScreenWidth * 0.5);
    [_mainCollectionView addSubview:headerImageView];
    
    //4.设置代理
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    [self.view addSubview:_mainCollectionView];
    
    [self createRefreshWithScrollView:_mainCollectionView containFooter:YES];
    [_mainCollectionView.mj_header beginRefreshing];
}


//加载数据
-(void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    [YGNetService YGPOST:@"HotCommodity" parameters:@{@"classificationId":self.classficationIdString,@"total":self.totalString,@"count":self.countString} showLoadingView:YES scrollView:_mainCollectionView success:^(id responseObject) {
        NSLog(@"%@",responseObject);

        if (((NSArray *)responseObject[@"merchandise"]).count < [YGPageSize integerValue]) {
            [self noMoreDataFormatWithScrollView:_mainCollectionView];
        }
        if (headerAction == YES) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[SecondClassfilyGoodsModel mj_objectArrayWithKeyValuesArray:responseObject[@"merchandise"]]];

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
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SecondClassifyGoodsCell *cell = (SecondClassifyGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SecondClassifyGoodsCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.item];
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((YGScreenWidth - 30)/ 2, (YGScreenWidth - 30) / 2 * 1.32);
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
    BabyDetailsController *vc = [[BabyDetailsController alloc]init];
    vc.idString = [_dataArray[indexPath.item] valueForKey:@"ID"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
