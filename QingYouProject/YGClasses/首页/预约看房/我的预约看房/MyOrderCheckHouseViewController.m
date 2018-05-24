//
//  MyOrderCheckHouseViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyOrderCheckHouseViewController.h"
#import "MyOrderCheckOrderViewController.h"

#import "YGSegmentView.h"

@interface MyOrderCheckHouseViewController ()<YGSegmentViewDelegate,UIScrollViewDelegate>

@end

@implementation MyOrderCheckHouseViewController
{
    YGSegmentView * _segmentView;//选择器
    UIScrollView * _scrollView;
    MyOrderCheckOrderViewController * _myOrderCheckOrderViewController;
    MyOrderCheckOrderViewController * _myOrderFinishOrderViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configUI
{
    self.naviTitle = @"预约单";
    UIView *segementBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    segementBaseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:segementBaseView];
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(30, 0, YGScreenWidth-60, 40) titlesArray:@[@"预约单",@"已完成"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
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
        if (_myOrderCheckOrderViewController == nil) {
            _myOrderCheckOrderViewController = [[MyOrderCheckOrderViewController alloc]init];
            _myOrderCheckOrderViewController.type = @"0";
            _myOrderCheckOrderViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myOrderCheckOrderViewController];
            [_scrollView addSubview:_myOrderCheckOrderViewController.view];
            
        }
    }
    else if (index == 1)
    {
        if (_myOrderFinishOrderViewController == nil) {
            _myOrderFinishOrderViewController = [[MyOrderCheckOrderViewController alloc]init];
            _myOrderFinishOrderViewController.type = @"1";
            _myOrderFinishOrderViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myOrderFinishOrderViewController];
            [_scrollView addSubview:_myOrderFinishOrderViewController.view];
            
        }
    }
 
}
@end
