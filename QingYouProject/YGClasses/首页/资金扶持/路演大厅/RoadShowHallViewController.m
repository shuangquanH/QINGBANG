//
//  RoadShowHallViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RoadShowHallViewController.h"
#import "LXScollTitleView.h"
#import "LXScrollContentView.h"
#import "RoadShowHallAllViewController.h"
#import "RoadShowHallModel.h"
#import "RoadShowHallApplyViewController.h"

#import "CrowdFundingAddProjectChooseTypeModel.h"

@interface RoadShowHallViewController ()
@property (nonatomic, strong) NSMutableArray          *dataSource;  //数据源
@property (nonatomic, strong) LXScollTitleView *titleView;

@property (nonatomic, strong) LXScrollContentView *contentView;
@end

@implementation RoadShowHallViewController
{
    NSMutableArray                      *_typeArr;          //类型数组
    NSMutableArray                      *_titleArr;          //类型数组
    UIView                              *_condationBaseView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
//    [zfpl resetPlayer];

}

- (void)configAttribute
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.naviTitle = @"路演大厅";
    _dataSource = [[NSMutableArray alloc] init];
    self.view.backgroundColor = colorWithYGWhite;
    _typeArr = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];

}

- (void)addNetCondiationView
{
    _condationBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth-40 , YGScreenWidth-64)];
    _condationBaseView.centery = self.view.center.y-64;
    _condationBaseView.centerx = self.view.center.x;
    [self.view addSubview:_condationBaseView];
    
    UIButton *condationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    condationBtn.frame = CGRectMake(0,90, 60, 20);
    [condationBtn setBackgroundImage:[UIImage imageNamed:@"class_nothing.png"] forState:UIControlStateNormal];
    [condationBtn setBackgroundImage:[UIImage imageNamed:@"class_nothing.png"] forState:UIControlStateHighlighted];
    [condationBtn setBackgroundImage:[UIImage imageNamed:@"class_nothing.png"] forState:UIControlStateSelected];
    [condationBtn sizeToFit];
    [condationBtn addTarget:self action:@selector(buttonClilckAction:) forControlEvents:UIControlEventTouchUpInside];
    [_condationBaseView addSubview:condationBtn];
    condationBtn.centery = _condationBaseView.width/2.0f;
    condationBtn.centerx = _condationBaseView.width/2.0f;
}

- (void)removeNetCondationView
{
    [_condationBaseView removeFromSuperview];
}

- (void)loadData
{
    if (_condationBaseView) {
        [self removeNetCondationView];
    }
    [YGNetService YGPOST:REQUEST_getTrade parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        _typeArr = [CrowdFundingAddProjectChooseTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"tradeList"]];
        CrowdFundingAddProjectChooseTypeModel *allModel = [[CrowdFundingAddProjectChooseTypeModel alloc] init];
        allModel.tradeName = @"全部";
        allModel.typeId = @"";
        allModel.id = @"";
        [_typeArr insertObject:allModel atIndex:0];
        
        for (CrowdFundingAddProjectChooseTypeModel *model in _typeArr) {
            model.typeId = model.id;
            [_titleArr addObject:model.tradeName];
        }
    
        [self configUI];
        [self.titleView reloadViewWithTitles:_titleArr];
        
        //创建控制器数组 作为顶部的滚动标题的子控制器
        NSMutableArray *vcs = [[NSMutableArray alloc] init];
        for (CrowdFundingAddProjectChooseTypeModel *model in _typeArr) {
            RoadShowHallAllViewController  *vc = [[RoadShowHallAllViewController alloc] init];
            vc.model = model;
            [vcs addObject:vc];
        }
        [self.contentView reloadViewWithChildVcs:vcs parentVC:self];
        

    } failure:^(NSError *error) {
        
    }];

    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(15, 0, self.view.frame.size.width-15, 50);
    
    self.contentView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
}
//顶部的滚动标题
- (void)configUI
{
    self.titleView = [[LXScollTitleView alloc] initWithFrame:CGRectZero];
    self.titleView.backgroundColor = colorWithYGWhite;
    __weak typeof(self) weakSelf = self;
    self.titleView.selectedBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.contentView.currentIndex = index;
    };
    self.titleView.titleWidth = 110.f;
    self.titleView.normalColor = colorWithBlack;
    self.titleView.selectedColor = colorWithMainColor;
    [self.view addSubview:self.titleView];
    
    self.contentView = [[LXScrollContentView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = colorWithTable;
    self.contentView.scrollBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.titleView.selectedIndex = index;
    };
    [self.view addSubview:self.contentView];

    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight-45-YGBottomMargin,YGScreenWidth,45+YGBottomMargin)];
    coverButton.titleEdgeInsets = UIEdgeInsetsMake(-YGBottomMargin, 0, 0, 0);
    [coverButton addTarget:self action:@selector(applyForRoadShowAction:) forControlEvents:UIControlEventTouchUpInside];
    coverButton.backgroundColor = colorWithMainColor;
    coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    [self.view addSubview:coverButton];
    [coverButton setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    [coverButton setTitle:@"申请路演" forState:UIControlStateNormal];
}

- (void)buttonClilckAction:(UIButton *)btn
{
    [self loadData];
}

- (void)applyForRoadShowAction:(UIButton *)btn
{
    RoadShowHallApplyViewController *vc = [[RoadShowHallApplyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
