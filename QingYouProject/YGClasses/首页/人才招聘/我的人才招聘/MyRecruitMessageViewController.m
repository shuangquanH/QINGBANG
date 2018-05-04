//
//  MyRecruitMessageViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyRecruitMessageViewController.h"
#import "MyRecruitBeInviteInterviewViewController.h"
#import "MyRecruitBeCheckedViewController.h"
#import "YGSegmentView.h"

@interface MyRecruitMessageViewController ()<UIScrollViewDelegate>
{
    
    UIView *_baseView;
}


@end

@implementation MyRecruitMessageViewController
{
    SDCycleScrollView *_adScrollview; //广告轮播
    MyRecruitBeInviteInterviewViewController *_myRecruitBeInviteInterviewViewController;
    MyRecruitBeCheckedViewController *_myRecruitBeCheckedViewController;
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
    self.naviTitle = @"我的消息";
}
- (void)configUI
{
    self.view.backgroundColor = colorWithTable;
    //选择页面按钮
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"被查看",@"邀面试"] lineColor:colorWithMainColor delegate:self];
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
        if (_myRecruitBeCheckedViewController == nil) {
            _myRecruitBeCheckedViewController = [[MyRecruitBeCheckedViewController alloc]init];
            _myRecruitBeCheckedViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myRecruitBeCheckedViewController];
            [_scrollView addSubview:_myRecruitBeCheckedViewController.view];
            
        }
    }
    else if (index == 1)
    {
   
        if (_myRecruitBeInviteInterviewViewController == nil) {
            _myRecruitBeInviteInterviewViewController = [[MyRecruitBeInviteInterviewViewController alloc]init];
            _myRecruitBeInviteInterviewViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myRecruitBeInviteInterviewViewController];
            [_scrollView addSubview:_myRecruitBeInviteInterviewViewController.view];
            
        }
    }
}


@end
