//
//  CrowdFundingHallViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "CrowdFundingHallViewController.h"
#import "LXScollTitleView.h"
#import "LXScrollContentView.h"
#import "CrowdFundingHallAllViewController.h"
#import "CrowdFundingAddProjectViewController.h"
#import "CrowdFundingAddProjectChooseTypeModel.h"

@interface CrowdFundingHallViewController ()
@property (nonatomic, strong) NSMutableArray          *dataSource;  //数据源
@property (nonatomic, strong) LXScollTitleView *titleView;

@property (nonatomic, strong) LXScrollContentView *contentView;
@property (nonatomic, strong) UIView *titleMenuView;

@end

@implementation CrowdFundingHallViewController
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
    
    //标题切募集中和已完成
    UIView *titleButtonView  = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/4+10,YGNaviBarHeight-30,YGScreenWidth/2,30)];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, titleButtonView.width, titleButtonView.height)];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigThree];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.text = @"众筹大厅";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel sizeToFit];
    [titleButtonView addSubview:_titleLabel];
    
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.width+10, _titleLabel.y, 17, 17)];
    _titleImageView.image = [UIImage imageNamed:@"steward_talents_unfold_gray"];
    [_titleImageView sizeToFit];
    _titleImageView.contentMode = UIViewContentModeCenter;
    [titleButtonView addSubview: _titleImageView];
    _titleImageView.centery = _titleLabel.centery;

    titleButtonView.frame =CGRectMake(YGScreenWidth/2-(_titleLabel.width+20)/2, titleButtonView.y, _titleLabel.width+25, titleButtonView.height);
    
    _titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,YGScreenWidth/3,40)];
    [_titleButton addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleButtonView addSubview:_titleButton];
    _titleButton.selected = NO;
    self.navigationItem.titleView = titleButtonView;

    
    _dataSource = [[NSMutableArray alloc] init];
    self.view.backgroundColor = colorWithYGWhite;
    _typeArr = [[NSMutableArray alloc] init];
    _titleArr = [[NSMutableArray alloc] init];
//    UIBarButtonItem *item  =[self createBarbuttonWithNormalTitleString:@"搜索" selectedTitleString:@"搜索" selector:@selector(searchAction:)];
//    self.navigationItem.rightBarButtonItem = item;
    
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
    [YGNetService YGPOST:REQUEST_getProType parameters:@{} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        _typeArr = [CrowdFundingAddProjectChooseTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"plist"]];
        CrowdFundingAddProjectChooseTypeModel *allModel = [[CrowdFundingAddProjectChooseTypeModel alloc] init];
        allModel.type = @"全部";
        allModel.typeId = @"";
        allModel.id = @"";
        [_typeArr insertObject:allModel atIndex:0];
        
        for (CrowdFundingAddProjectChooseTypeModel *model in _typeArr) {
            model.id = model.id;
            [_titleArr addObject:model.type];
        }
        
        [self configUI];
        [self.titleView reloadViewWithTitles:_titleArr];
        
        //创建控制器数组 作为顶部的滚动标题的子控制器
        _vcs = [[NSMutableArray alloc] init];
        for (CrowdFundingAddProjectChooseTypeModel *model in _typeArr) {
            CrowdFundingHallAllViewController  *vc = [[CrowdFundingHallAllViewController alloc] init];
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
    
    UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,YGScreenHeight-150-YGBottomMargin,60, 60)];
    [coverButton addTarget:self action:@selector(addProjectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setImage:[UIImage imageNamed:@"home_yiqiwan_add"] forState:UIControlStateNormal];
    coverButton.layer.cornerRadius = 25;
    coverButton.clipsToBounds = YES;
    [self.view addSubview:coverButton];
    [self createTitleMenuView];
    
}

- (void)buttonClilckAction:(UIButton *)btn
{
    [self loadData];
}

- (void)addProjectBtnAction:(UIButton *)btn
{
    [YGNetService YGPOST:REQUEST_authentication parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        YGSingletonMarco.user.isCertified =[responseObject[@"zhiMaXinYong"] boolValue];
        
        if (YGSingletonMarco.user.isCertified == NO) {
            [YGAppTool showToastWithText:@"您还没有进行身份认证，请到个人中心进行身份认证~"];
            return;
        }else
        {
            CrowdFundingAddProjectViewController *crowdFundingAddProjectViewController = [[CrowdFundingAddProjectViewController alloc] init];
            [self.navigationController pushViewController:crowdFundingAddProjectViewController animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];

 
}

- (void)createTitleMenuView
{
    _titleMenuView = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/2-60, -80, 120, 80)];
    //阴影
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_titleMenuView.bounds];
    _titleMenuView.layer.masksToBounds = NO;
    _titleMenuView.layer.shadowColor = [UIColor blackColor].CGColor;
    _titleMenuView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    _titleMenuView.layer.shadowOpacity = 0.4f;
    _titleMenuView.layer.shadowRadius = 8;
    _titleMenuView.layer.shadowPath = shadowPath.CGPath;
    
    NSArray *array = @[@"筹集中",@"已完成"];
    for (int i = 0; i<2; i++) {
        UIButton *coverButton = [[UIButton alloc]initWithFrame:CGRectMake(0,40*i,120,40)];
        coverButton.tag = 1000+i;
        [coverButton addTarget:self action:@selector(changeStatesBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [coverButton setTitleColor:colorWithMainColor forState:UIControlStateSelected];
        [coverButton setTitle:array[i] forState:UIControlStateNormal];
        [_titleMenuView addSubview:coverButton];
    }
    _titleMenuView.backgroundColor = colorWithYGWhite;
    self.titleMenuView.alpha = _titleButton.isSelected;
    [self.view addSubview:_titleMenuView];
    UIButton *coverButton = [_titleMenuView viewWithTag:1000];
    coverButton.selected = YES;
    
}

- (void)searchAction:(UIButton *)btn
{
    [UIView animateWithDuration:0.5 animations:^{
        self.titleMenuView.frame = CGRectMake(_titleMenuView.x, _titleMenuView.y, _titleMenuView.width, 0);
    }];
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
- (void)changeStatesBtnAction:(UIButton *)btn
{
    for (int i = 0; i<2; i++)
    {
        UIButton *button = [_titleMenuView viewWithTag:1000+i];
        button.selected = NO;
    }
    btn.selected = YES;
    CrowdFundingHallAllViewController  *vc = _vcs[self.contentView.currentIndex];
    [vc reloadDataWithState:[NSString stringWithFormat:@"%ld",(btn.tag-1000+1)*2]];
    [self titleButtonAction:_titleButton];
    
}
@end

