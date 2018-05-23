//
//  SQHomeViewController.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/18.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQHomeViewController.h"
#import "SQOvalFuncButtons.h"
#import "SQCardScrollView.h"
#import "SQCollectionViewLayout.h"

@interface SQHomeViewController () <SQOvalFuncButtonDelegate, SQCollectionViewLayoutDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SQBaseCollectionView        *collectionView;

@end

@implementation SQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"首页";
    [self.view addSubview:self.collectionView];
    [self usedOvalView];
    
    
    
}


- (void)usedOvalView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, YGScreenWidth)];
    
    CGRect frame = CGRectMake((YGScreenWidth-260)/2.0, 20, 280, 220);
    SQOvalFuncButtons   *view = [[SQOvalFuncButtons alloc] initWithFrame:frame centBtnSize:CGSizeMake(30, 30) backImage:[UIImage imageNamed:@"ovalimage"]];
    view.delegate = self;
    [headerView addSubview:view];
    
    NSMutableArray  *btnArr = [NSMutableArray array];
    NSArray *btnTitle = @[@"水电缴费", @"会议室预定", @"办公耗材",
                          @"财税代理", @"办公室装修", @"人才招聘",
                          @"工商代办", @"项目申报", @"办公",
                          @"物业服务", @"资金扶持", @"广告位招商"];
    for (NSString *title in btnTitle) {
        UIButton    *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        button.backgroundColor = colorWithMainColor;
        [button setImage:[UIImage imageNamed:@"ovalimage"] forState:UIControlStateNormal];
        [btnArr addObject:button];
        [button addTarget:self action:@selector(btnaction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGRect frame2 = CGRectMake(0, view.sqbottom+20, YGScreenWidth, 100);
    SQCardScrollView    *scrollview = [[SQCardScrollView alloc] initWithFrame:frame2];
    [self.view addSubview:scrollview];
    [scrollview setItemArr:btnArr alongAxis:SQSAxisTypeHorizontal spacing:20 leadSpace:0 tailSpace:0 itemSize:CGSizeMake(200, 100)];

    [headerView addSubview:scrollview];
    
    self.collectionView.headerView = headerView;
}
- (void)didselectWithClicktype:(ClickType)type {
    NSLog(@"%lu", (unsigned long)type);
}


- (void)btnaction {
    NSLog(@"dd");
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
