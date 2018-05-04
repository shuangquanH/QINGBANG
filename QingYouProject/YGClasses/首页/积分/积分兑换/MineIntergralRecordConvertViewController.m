//
//  MineIntergralRecordConvertViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralRecordConvertViewController.h"
#import "LXScollTitleView.h"
#import "LXScrollContentView.h"
#import "CrowdFundingAddProjectChooseTypeModel.h"
#import "MineIntergralRecordConvertSubViewController.h"
#import "IntegralClassifiModel.h"

@interface MineIntergralRecordConvertViewController ()
@property (nonatomic, strong) NSMutableArray          *dataSource;  //数据源
@property (nonatomic, strong) LXScollTitleView *titleView;

@property (nonatomic, strong) LXScrollContentView *contentView;
@property (nonatomic, strong) UIView *titleMenuView;

@end

@implementation MineIntergralRecordConvertViewController
{
    NSMutableArray                      *_typeArr;          //类型数组
    NSMutableArray                      *_titleArr;          //类型数组
    UIView                              *_condationBaseView;
    NSMutableArray *_vcs;
    UIImageView *_titleImageView;
    UILabel *_titleLabel;
    UIButton *_titleButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)configAttribute
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.naviTitle = @"青币兑换";
    
    _dataSource = [[NSMutableArray alloc] init];
    self.view.backgroundColor = colorWithYGWhite;
    _typeArr = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];
   
    
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
    [YGNetService YGPOST:@"IntegralClassifi" parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        _typeArr = [IntegralClassifiModel mj_objectArrayWithKeyValuesArray:responseObject[@"list1"]];
        IntegralClassifiModel *allModel = [[IntegralClassifiModel alloc] init];
        allModel.title = @"全部";
        allModel.ID = @"";
        [_typeArr insertObject:allModel atIndex:0];
        
        for (IntegralClassifiModel *model in _typeArr) {
            model.ID = model.ID;
            [_titleArr addObject:model.title];
        }
        
        [self configUI];
        [self.titleView reloadViewWithTitles:_titleArr];
        
        //创建控制器数组 作为顶部的滚动标题的子控制器
        _vcs = [[NSMutableArray alloc] init];
        for (IntegralClassifiModel *model in _typeArr) {
            MineIntergralRecordConvertSubViewController  *vc = [[MineIntergralRecordConvertSubViewController alloc] init];
            vc.model = model;
            [_vcs addObject:vc];
        }
        [self.contentView reloadViewWithChildVcs:_vcs parentVC:self];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(15, 0, YGScreenWidth-15, 50);
    
    self.contentView.frame = CGRectMake(0, 50, YGScreenWidth, YGScreenHeight-YGNaviBarHeight- 50);
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
    self.titleView.titleWidth = 80.f;
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
    

    
}

- (void)buttonClilckAction:(UIButton *)btn
{
    [self loadData];
}

- (void)titleButtonAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (btn.isSelected)
        {
            self.titleMenuView.y = 0;
        }else
        {
            self.titleMenuView.y = -self.titleMenuView.height;
        }
        
        self.titleMenuView.alpha = btn.isSelected;
    }];
    
}

@end
