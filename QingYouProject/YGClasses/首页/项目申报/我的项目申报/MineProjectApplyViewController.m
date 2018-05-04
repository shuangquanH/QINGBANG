//
//  MineProjectApplyViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineProjectApplyViewController.h"
#import "MineProjectApplyWaitCheckViewController.h"
#import "MineProjectApplyCheckingViewController.h"
#import "MineProjectApplyFinishCheckViewController.h"
#import "YGSegmentView.h"

@interface MineProjectApplyViewController ()<YGSegmentViewDelegate,UIScrollViewDelegate>

@end

@implementation MineProjectApplyViewController
{
    YGSegmentView * _segmentView;//选择器
    UIScrollView * _scrollView;
    MineProjectApplyWaitCheckViewController * _mineProjectApplyWaitCheckViewController;
    MineProjectApplyCheckingViewController * _mineProjectApplyCheckingViewController;
    MineProjectApplyFinishCheckViewController * _mineProjectApplyFinishCheckViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)configUI
{
    self.naviTitle = @"项目申报";
    UIView *segementBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    segementBaseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:segementBaseView];
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(30, 0, YGScreenWidth-60, 40) titlesArray:@[@"待审核",@"进行中",@"已完成"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    _segmentView.lineColor = colorWithMainColor;
    [segementBaseView addSubview:_segmentView];
    
    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, YGScreenWidth, YGScreenHeight - 64 - _segmentView.height)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * 3, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //默认第0页
    [self segmentButtonClickWithIndex:0];
    
}

#pragma mark ---- 改变当前Controller
-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [self loadControllerWithIndex:buttonIndex];
    
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _scrollView.contentOffset.y);
    }];
}

#pragma mark ---- 滑动切换Controller
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / YGScreenWidth;
    [self loadControllerWithIndex:index];
    [_segmentView selectButtonWithIndex:index];
}

#pragma mark ---- 加载Controller
-(void)loadControllerWithIndex:(int)index
{
    if (index == 0)
    {
        if (_mineProjectApplyWaitCheckViewController == nil) {
            _mineProjectApplyWaitCheckViewController = [[MineProjectApplyWaitCheckViewController alloc]init];
            _mineProjectApplyWaitCheckViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_mineProjectApplyWaitCheckViewController];
            [_scrollView addSubview:_mineProjectApplyWaitCheckViewController.view];
            
        }
    }
    else if (index == 1)
    {
        if (_mineProjectApplyCheckingViewController == nil) {
            _mineProjectApplyCheckingViewController = [[MineProjectApplyCheckingViewController alloc]init];
            _mineProjectApplyCheckingViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_mineProjectApplyCheckingViewController];
            [_scrollView addSubview:_mineProjectApplyCheckingViewController.view];
            
        }
        
    }else
    {
        if (_mineProjectApplyFinishCheckViewController == nil) {
            _mineProjectApplyFinishCheckViewController = [[MineProjectApplyFinishCheckViewController alloc]init];
            _mineProjectApplyFinishCheckViewController.controllerFrame = CGRectMake(YGScreenWidth * index,1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_mineProjectApplyFinishCheckViewController];
            [_scrollView addSubview:_mineProjectApplyFinishCheckViewController.view];
            
        }
        
    }
}
@end
