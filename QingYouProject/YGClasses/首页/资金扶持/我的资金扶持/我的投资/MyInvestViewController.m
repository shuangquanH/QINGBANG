//
//  MyInvestViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyInvestViewController.h"
#import "YGSegmentView.h"
#import "MyInvestSubViewController.h"

@interface MyInvestViewController ()<UIScrollViewDelegate>
{
    
    UIView *_baseView;
}


@end

@implementation MyInvestViewController
{
    SDCycleScrollView *_adScrollview; //广告轮播
    MyInvestSubViewController *_myInvestSubWaitPayViewController;
    MyInvestSubViewController *_myInvestSubWaitCheckViewController;
    MyInvestSubViewController *_myInvestSubWaitFInishViewController;

    YGSegmentView *_segmentView;
    UIScrollView * _scrollView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configAttribute
{
    self.naviTitle = @"我的投资";
}
- (void)configUI
{
    self.view.backgroundColor = colorWithTable;
    //选择页面按钮
    YGSegmentView *segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"待付款",@"待审核",@"已完成"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithTable;
    [self.view addSubview:segmentView];
    
    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, YGScreenWidth, YGScreenHeight -_segmentView.height-YGStatusBarHeight-YGNaviBarHeight)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * 3, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
//    _scrollView.delegate = self;
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
        if (_myInvestSubWaitPayViewController == nil) {
            _myInvestSubWaitPayViewController = [[MyInvestSubViewController alloc]init];
            _myInvestSubWaitPayViewController.subscribeType = @"1";
            _myInvestSubWaitPayViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myInvestSubWaitPayViewController];
            [_scrollView addSubview:_myInvestSubWaitPayViewController.view];
            
        }
    }
    else if (index == 1)
    {
        if (_myInvestSubWaitCheckViewController == nil) {
            _myInvestSubWaitCheckViewController = [[MyInvestSubViewController alloc]init];
            _myInvestSubWaitCheckViewController.subscribeType = @"3";
            _myInvestSubWaitCheckViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myInvestSubWaitCheckViewController];
            [_scrollView addSubview:_myInvestSubWaitCheckViewController.view];
            
        }

        
    }else
    {
        if (_myInvestSubWaitFInishViewController == nil) {
            
            _myInvestSubWaitFInishViewController = [[MyInvestSubViewController alloc]init];
            _myInvestSubWaitFInishViewController.subscribeType = @"4";
            _myInvestSubWaitFInishViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myInvestSubWaitFInishViewController];
            [_scrollView addSubview:_myInvestSubWaitFInishViewController.view];
            
        }

    }
}


@end
