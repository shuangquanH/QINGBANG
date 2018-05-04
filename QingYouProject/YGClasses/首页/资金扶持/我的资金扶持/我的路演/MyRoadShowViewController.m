//
//  MyRoadShowViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyRoadShowViewController.h"
#import "MyRoadShowFinishViewController.h"
#import "YGSegmentView.h"
#import "BussinessPlanViewController.h"

@interface MyRoadShowViewController ()<UIScrollViewDelegate>
{
    
    UIView *_baseView;
}

@end

@implementation MyRoadShowViewController
{
    SDCycleScrollView *_adScrollview; //广告轮播
    MyRoadShowFinishViewController *_myRoadShowFinishViewController;
    BussinessPlanViewController *_myBussinessPlanViewController;
    YGSegmentView *_segmentView;
    UIScrollView * _scrollView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

- (void)configAttribute
{
    self.naviTitle = @"我的服务";
}
- (void)configUI
{
    self.view.backgroundColor = colorWithTable;
    //选择页面按钮
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"我的路演",@"商业计划书"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithTable;
    [self.view addSubview:_segmentView];
    
    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, YGScreenWidth, YGScreenHeight -_segmentView.height - YGNaviBarHeight-YGStatusBarHeight)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * 2, _scrollView.height);
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
        if (_myRoadShowFinishViewController == nil) {
            _myRoadShowFinishViewController = [[MyRoadShowFinishViewController alloc]init];
            _myRoadShowFinishViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myRoadShowFinishViewController];
            [_scrollView addSubview:_myRoadShowFinishViewController.view];
            
        }
    }
    else if (index == 1)
    {
        if (_myBussinessPlanViewController == nil) {
            _myBussinessPlanViewController = [[BussinessPlanViewController alloc]init];
            _myBussinessPlanViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myBussinessPlanViewController];
            [_scrollView addSubview:_myBussinessPlanViewController.view];
            
        }
                
    }
}


@end
