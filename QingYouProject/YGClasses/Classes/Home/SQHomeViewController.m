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

@interface SQHomeViewController () <SQCollectionViewLayoutDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SQBaseCollectionView        *collectionView;

@end

@implementation SQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"首页";
    [self.view addSubview:self.collectionView];
    CGRect headerFrame = CGRectMake(0, 0, YGScreenWidth, 570);
    SQHomeCollectionHeader *headerView = [[SQHomeCollectionHeader alloc] initWithFrame:headerFrame];
    self.collectionView.headerView = headerView;
    headerView.scrollViewData = @[@"ahc", @"hahah"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SQBaseCollectionViewCell *cell = [SQBaseCollectionViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    [cell addSubview:label];
    cell.backgroundColor = colorWithMainColor;
    return cell;
}
- (CGSize)waterfallLayout:(SQCollectionViewLayout *)waterfallLayout atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%3==0) {
        return CGSizeMake(100, 100);
    } else if (indexPath.row%7==0) {
        return CGSizeMake(100, 50);
    } else {
        return CGSizeMake(100, 200);
    }
}





#pragma lazyLoad
- (SQBaseCollectionView *)collectionView {
    if (!_collectionView) {
        SQCollectionViewLayout *layout = [SQCollectionViewLayout waterFallLayoutWithColumnCount:2];
        [layout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        _collectionView = [[SQBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = kWhiteColor;
        _collectionView.dataSource = self;
        layout.delegate = self;
    }
    return _collectionView;
}











@end
