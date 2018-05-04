//
//  MyTabPlayTogetherViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyTabPlayTogetherViewController.h"
#import "YGSegmentView.h"//点击切换视图View
#import "MyPlayTogetherCollectionController.h"

@interface MyTabPlayTogetherViewController ()<UIScrollViewDelegate>
{
    UIView *_baseView;
}

@end

@implementation MyTabPlayTogetherViewController

{
    SDCycleScrollView *_adScrollview; //广告轮播
    MyPlayTogetherCollectionController *_playTogetherViewController;
    YGSegmentView *_segmentView;
    UIScrollView * _scrollView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_playTogetherViewController.tableView.mj_header beginRefreshing];
}

- (void)configAttribute
{
    self.naviTitle = @"一起玩";
    
}
- (void)configUI
{
    self.view.backgroundColor = colorWithTable;
    
    //选择页面按钮
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"活动",@"联盟"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_segmentView];
    
    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, YGScreenWidth, YGScreenHeight -_segmentView.height)];
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
    _playTogetherViewController = [[MyPlayTogetherCollectionController alloc]init];
    _playTogetherViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
    _playTogetherViewController.pageType = [NSString stringWithFormat:@"%d",index];
    [self addChildViewController:_playTogetherViewController];
    [_scrollView addSubview:_playTogetherViewController.view];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
