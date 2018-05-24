//
//  JobOutsourceTradeRecoredViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "JobOutsourceTradeRecoredViewController.h"
#import "JobOutsourceTradeRecoredWaitViewController.h"
#import "JobOutsourceTradeRecoredDealingViewController.h"
#import "JobOutsourceTradeRecoredFinishViewController.h"
#import "YGSegmentView.h"

@interface JobOutsourceTradeRecoredViewController ()<YGSegmentViewDelegate,UIScrollViewDelegate>

@end

@implementation JobOutsourceTradeRecoredViewController
{
    YGSegmentView * _segmentView;//选择器
    UIScrollView * _scrollView;
    JobOutsourceTradeRecoredWaitViewController * _jobOutsourceTradeRecoredWaitViewController;
    JobOutsourceTradeRecoredDealingViewController * _jobOutsourceTradeRecoredDealingViewController;
    JobOutsourceTradeRecoredFinishViewController * _obOutsourceTradeRecoredFinishViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}
- (void)configUI
{
    self.naviTitle = @"交易记录";
    UIView *segementBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40)];
    segementBaseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:segementBaseView];
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(30, 0, YGScreenWidth-60, 40) titlesArray:@[@"待处理",@"处理中",@"已处理"] lineColor:colorWithMainColor delegate:self];
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
        if (_jobOutsourceTradeRecoredWaitViewController == nil) {
            _jobOutsourceTradeRecoredWaitViewController = [[JobOutsourceTradeRecoredWaitViewController alloc]init];
            _jobOutsourceTradeRecoredWaitViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_jobOutsourceTradeRecoredWaitViewController];
            [_scrollView addSubview:_jobOutsourceTradeRecoredWaitViewController.view];
            
        }
    }
    else if (index == 1)
    {
        if (_jobOutsourceTradeRecoredDealingViewController == nil) {
            _jobOutsourceTradeRecoredDealingViewController = [[JobOutsourceTradeRecoredDealingViewController alloc]init];
            _jobOutsourceTradeRecoredDealingViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_jobOutsourceTradeRecoredDealingViewController];
            [_scrollView addSubview:_jobOutsourceTradeRecoredDealingViewController.view];
            
        }
        
    }else
    {
        if (_obOutsourceTradeRecoredFinishViewController == nil) {
            _obOutsourceTradeRecoredFinishViewController = [[JobOutsourceTradeRecoredFinishViewController alloc]init];
            _obOutsourceTradeRecoredFinishViewController.controllerFrame = CGRectMake(YGScreenWidth * index,1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_obOutsourceTradeRecoredFinishViewController];
            [_scrollView addSubview:_obOutsourceTradeRecoredFinishViewController.view];
            
        }
        
    }
}

@end
