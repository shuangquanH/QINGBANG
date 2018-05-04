//
//  MineIntergralRecordOrderViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralRecordOrderViewController.h"
#import "YGSegmentView.h"
#import "MineIntergralRecordOrderSubViewController.h"

@interface MineIntergralRecordOrderViewController ()<UIScrollViewDelegate>
{
    YGSegmentView *_segmentView;
    UIScrollView *_scrollView;
    NSMutableArray *_controllersArray;
    MineIntergralRecordOrderSubViewController *_intergralRecordOrderSubViewController;
}

@end

@implementation MineIntergralRecordOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_intergralRecordOrderSubViewController.tableView.mj_header beginRefreshing];
}


- (void)configAttribute
{
    self.naviTitle = @"订单列表";
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"全部订单",@"待发货",@"待收货"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [self.view  addSubview: _segmentView];
}

- (void)configUI
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _segmentView.y + _segmentView.height, YGScreenWidth, YGScreenHeight - (YGStatusBarHeight + YGNaviBarHeight) - _segmentView.y - _segmentView.height)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * _segmentView.titlesArray.count, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"MineIntergralRecordOrderSubViewController",@"MineIntergralRecordOrderSubViewController",@"MineIntergralRecordOrderSubViewController"]];
    
    [self segmentButtonClickWithIndex:0];
    
}

-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [self loadControllerWithIndex:buttonIndex];
    
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _scrollView.contentOffset.y);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / YGScreenWidth;
    
    [self loadControllerWithIndex:index];
    [_segmentView selectButtonWithIndex:index];
}

#pragma mark ---- 加载Controller
-(void)loadControllerWithIndex:(int)index
{
    _intergralRecordOrderSubViewController = [[MineIntergralRecordOrderSubViewController alloc]init];
    _intergralRecordOrderSubViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
    _intergralRecordOrderSubViewController.controllerType = [NSString stringWithFormat:@"%d",index];
    [self addChildViewController:_intergralRecordOrderSubViewController];
    [_scrollView addSubview:_intergralRecordOrderSubViewController.view];
    
}

//-(void)loadControllerWithIndex:(int)index
//{
//    if ([_controllersArray[index] isKindOfClass:[NSString class]])
//    {
//        UIViewController *controller = [[NSClassFromString(_controllersArray[index])  alloc]init];
//        _intergralRecordOrderSubViewController.controllerType = [NSString stringWithFormat:@"%d",index];
//        _intergralRecordOrderSubViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 0, _scrollView.width, _scrollView.height);
//        [self addChildViewController:controller];
//        [_scrollView addSubview:controller.view];
//        [_controllersArray replaceObjectAtIndex:index withObject:controller];
//    }
//}
@end
