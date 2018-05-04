//
//  SeccondHandExchangeChooseTypeViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SeccondHandExchangeChooseTypeViewController.h"
#import "SeccondHandExchangeChooseTypeCell.h"
#import "SeccondHandExchangeTypeModel.h"

#import "SeccondHandExchangePublishViewController.h"

#import "SeccondHandExchangeViewController.h"
#import "BabyDetailsController.h"
#import "SecondHandClassifyGoodsController.h"

@interface SeccondHandExchangeChooseTypeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation SeccondHandExchangeChooseTypeViewController
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataSource;
    BOOL  didAddSperateVerticalLine;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    [self loadDataFromServer];

    // Do any additional setup after loading the view.
}
- (void)configAttribute
{
    self.fd_interactivePopDisabled = YES;
    if ([self.pageType isEqualToString:@"SeccondHandExchangeMainSearch"]) {
        self.naviTitle = @"热门分类";

    }else
    {
        self.naviTitle = @"选择分类";
        if ([self.pageType isEqualToString:@"SeccondHandExchangePublish"]) {
          UIBarButtonItem *buttonItem = [self createBarbuttonWithNormalTitleString:@"确定" selectedTitleString:@"确定" selector:@selector(selectModelsArrayBack)];
            self.navigationItem.rightBarButtonItem = buttonItem;
        }
    }
    _dataSource = [[NSMutableArray alloc] init];
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (![self.pageType isEqualToString:@"SeccondHandExchangePublish"])
//    {
//        [self loadDataFromServer];
//    }
}
- (void)back
{
    
    if ([self.pageType isEqualToString:@"SeccondHandExchangeMain"] || [self.pageType isEqualToString:@"SeccondHandExchangeCertify"] || [self.pageType isEqualToString:@"SeccondHandExchangeMainSearch"])
    {
        //返回首页
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[SeccondHandExchangeViewController class]]) {
                break;
            }
        }
        [navc setViewControllers:viewControllers];
    }
    
    if ([self.pageType isEqualToString:@"addSeccondHandExchange"]) {
        //返回首页
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[BabyDetailsController class]]) {
                break;
            }
        }
        [navc setViewControllers:viewControllers];
    }
    if ([self.pageType isEqualToString:@"SeccondHandExchangePublish"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)loadDataFromServer
{
    [YGNetService YGPOST:REQUEST_MerchandiseClassification parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        [_dataSource removeAllObjects];
        [_dataSource addObjectsFromArray:[SeccondHandExchangeTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"classifications"]]];
        for (SeccondHandExchangeTypeModel *model in _dataSource) {
            model.isSelect = NO;
        }
//        _collectionView.frame = CGRectMake(0, 0, YGScreenWidth, (_dataSource.count+1)/3* (YGScreenWidth - 2 * 4 - 18) / 3 - 4+40);
        _collectionView.contentSize = CGSizeMake(YGScreenWidth,(_dataSource.count+1)/3* (YGScreenWidth - 2 * 4 - 18) / 3 - 4+40);
        [_collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)setModelArray:(NSArray *)modelArray
{
    for (SeccondHandExchangeTypeModel *modelSelect in modelArray) {
        for (SeccondHandExchangeTypeModel *model in _dataSource) {
            if ([model.id isEqualToString:modelSelect.id]) {
                model.isSelect = YES;
            }
        }
    }
    [_collectionView reloadData];

}
- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake( (YGScreenWidth - 2 * 4 - 18) / 3 - 4,  (YGScreenWidth - 2 * 4 - 18) / 3 - 4);
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
//    _collectionView.pagingEnabled = YES;
//    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
//    _collectionView.contentSize = CGSizeMake(self.models.count * (YGScreenWidth + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[SeccondHandExchangeChooseTypeCell class] forCellWithReuseIdentifier:@"SeccondHandExchangeChooseTypeCell"];
    
//    for (int i = 0; i<(_dataSource.count+1)/3; i++) {
//      UIView *lineView = [UIView alloc] initWithFrame:cgre
//    }
}
#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SeccondHandExchangeChooseTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SeccondHandExchangeChooseTypeCell" forIndexPath:indexPath];
    CGSize contentSize = _collectionView.contentSize;
    if(didAddSperateVerticalLine == NO) {
        
        UIView *verticalLineLeft = [[UIView alloc]initWithFrame:CGRectMake((YGScreenWidth - 2 * 4 - 18) / 3 - 4+8, 0, 1, contentSize.height - 8)];
        verticalLineLeft.backgroundColor = colorWithLine;
        verticalLineLeft.alpha = 0.35;
        [_collectionView addSubview:verticalLineLeft];
        
        UIView *verticalLineRight = [[UIView alloc]initWithFrame:CGRectMake(((YGScreenWidth - 2 * 4 - 18) / 3)*2 - 4+16, 0, 1, contentSize.height - 8)];
        verticalLineRight.backgroundColor = colorWithLine;
        verticalLineRight.alpha = 0.35;
        [_collectionView addSubview:verticalLineRight];
        
        didAddSperateVerticalLine = YES;
    }
    if (indexPath.row <= (_dataSource.count+3)/3) {
        UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(10, ((YGScreenWidth - 2 * 4 - 18) / 3 - 4+2) * indexPath.row , contentSize.width-20, 1)];//每一个cell的framee是 17.00, 10.00, 160.00, 160.00  ,
        horizontalLine.backgroundColor = colorWithLine;
        horizontalLine.alpha = 0.35;
        [_collectionView addSubview:horizontalLine];
    }

    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.pageType isEqualToString:@"SeccondHandExchangeMainSearch"])
    {
        for (SeccondHandExchangeTypeModel *model in _dataSource) {
            model.isSelect = NO;
        }
        SeccondHandExchangeTypeModel *cellModel = _dataSource[indexPath.row];
        cellModel.isSelect = !cellModel.isSelect;
        SecondHandClassifyGoodsController *vc = [[SecondHandClassifyGoodsController alloc] init];
        vc.classficationIdString = cellModel.id;
        vc.titleString = cellModel.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.pageType isEqualToString:@"SeccondHandExchangeCertify"] ||[self.pageType isEqualToString:@"SeccondHandExchangeMain"] || [self.pageType isEqualToString:@"addSeccondHandExchange"])
    {
        for (SeccondHandExchangeTypeModel *model in _dataSource) {
            model.isSelect = NO;
        }
        
        SeccondHandExchangeTypeModel *cellModel = _dataSource[indexPath.row];
        cellModel.isSelect = !cellModel.isSelect;
        SeccondHandExchangePublishViewController *vc = [[SeccondHandExchangePublishViewController alloc] init];
        vc.tyepId = cellModel.id;
        vc.pageType = self.pageType;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        SeccondHandExchangeTypeModel *model = _dataSource[indexPath.row];
      
        int i = 0;
        for (SeccondHandExchangeTypeModel *model in _dataSource) {
            if (model.isSelect == YES) {
                if (i +1 == 3) {
                    [YGAppTool showToastWithText:@"可最多选择3个分类~"];
                    return;
                }
                i++;
            }
      
         
        }
          model.isSelect = !model.isSelect;
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}
- (void)selectModelsArrayBack
{
    NSMutableArray *selectModelsArray = [[NSMutableArray alloc] init];
    
    for (SeccondHandExchangeTypeModel *model in _dataSource) {
        if (model.isSelect == YES) {
            [selectModelsArray addObject:model];
        }
    }
    if (selectModelsArray.count == 0) {
        [YGAppTool showToastWithText:@"您没有选择任何分类！"];
        return;
    }
    [self.delegate chooseTypeWithModelsArray:selectModelsArray];
    [self back];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
@end
