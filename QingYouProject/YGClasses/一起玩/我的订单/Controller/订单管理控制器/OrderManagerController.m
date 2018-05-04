//
//  OrderManagerController.m
//  FrienDo
//
//  Created by wangzhongliang on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderManagerController.h"
#import "YGSegmentView.h"
#import "AllOrderController.h"
#import "AwaitingPayMentController.h"
#import "AwaitingParticipationController.h"
#import "OveredOrderController.h"
#import "RefundsOrderController.h"

@interface OrderManagerController ()<UIScrollViewDelegate,YGSegmentViewDelegate>

@end

@implementation OrderManagerController
{
    YGSegmentView * _segmentView;//滑动的选择视图
    NSMutableArray * _controllers;//所有的子控制器
    UIScrollView * _baseScrollView;//底层的滑动视图
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configAttribute
{
    self.naviTitle = @"我的订单";
    _controllers = [NSMutableArray arrayWithArray:@[@"AllOrderController",@"AwaitingPayMentController",@"AwaitingParticipationController",@"OveredOrderController",@"RefundsOrderController"]];
}

- (void)configUI
{
    [self configSegmentView];
    
    _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentView.frame) + 1, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - _segmentView.height - 1)];
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.contentSize = CGSizeMake(YGScreenWidth * 5, _baseScrollView.height);
    _baseScrollView.pagingEnabled = YES;
    _baseScrollView.delegate = self;
    [self.view addSubview:_baseScrollView];
    [self segmentButtonClickWithIndex:self.orderType];
    [_segmentView selectButtonWithIndex:self.orderType];
}

- (void)configSegmentView
{
    
    _segmentView = [[YGSegmentView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"全部",@"待付款",@"待参与",@"已完成",@"退款"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_segmentView];
}

-(void)loadControllerWithIndex:(int)index
{
    if([_controllers[index] isKindOfClass:[NSString class]])
    {
        switch (index) {
            case 0:
            {
                AllOrderController *controller = [[AllOrderController alloc]init];
                controller.controllerFrame = CGRectMake(YGScreenWidth * index, 0, _baseScrollView.width, _baseScrollView.height);
                [self addChildViewController:controller];
                [_baseScrollView addSubview:controller.view];
                [_controllers replaceObjectAtIndex:index withObject:controller];
            }
                break;
            case 1:
            {
                AwaitingPayMentController * controller = [[AwaitingPayMentController alloc] init];
                controller.controllerFrame = CGRectMake(YGScreenWidth * index, 0, _baseScrollView.width, _baseScrollView.height);
                [self addChildViewController:controller];
                [_baseScrollView addSubview:controller.view];
                [_controllers replaceObjectAtIndex:index withObject:controller];
            }
                break;
            case 2:
            {
                AwaitingParticipationController * controller = [[AwaitingParticipationController alloc] init];
                controller.controllerFrame = CGRectMake(YGScreenWidth * index, 0, _baseScrollView.width, _baseScrollView.height);
                [self addChildViewController:controller];
                [_baseScrollView addSubview:controller.view];
                [_controllers replaceObjectAtIndex:index withObject:controller];
            }
                break;
            case 3:
            {
                OveredOrderController * controller = [[OveredOrderController alloc] init];
                controller.controllerFrame = CGRectMake(YGScreenWidth * index, 0, _baseScrollView.width, _baseScrollView.height);
                [self addChildViewController:controller];
                [_baseScrollView addSubview:controller.view];
                [_controllers replaceObjectAtIndex:index withObject:controller];
            }
                break;
            case 4:
            {
                RefundsOrderController * controller = [[RefundsOrderController alloc] init];
                controller.controllerFrame = CGRectMake(YGScreenWidth * index, 0, _baseScrollView.width, _baseScrollView.height);
                [self addChildViewController:controller];
                [_baseScrollView addSubview:controller.view];
                [_controllers replaceObjectAtIndex:index withObject:controller];
            }
                break;
        }
    }
}

#pragma mark - YGSegmentViewDelegate
- (void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [self loadControllerWithIndex:buttonIndex];
    [UIView animateWithDuration:0.25 animations:^{
        _baseScrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _baseScrollView.contentOffset.y);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / YGScreenWidth;
    
    [self loadControllerWithIndex:index];
    [_segmentView selectButtonWithIndex:index];
}
@end
