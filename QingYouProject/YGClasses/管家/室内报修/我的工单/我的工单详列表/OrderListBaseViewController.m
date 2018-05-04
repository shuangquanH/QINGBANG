//
//  OrderListBaseViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderListBaseViewController.h"
#import "YGSegmentView.h"

@interface OrderListBaseViewController ()<YGSegmentViewDelegate,UIScrollViewDelegate>
{
    YGSegmentView *_segmentView;
    UIScrollView *_scrollView;
    NSMutableArray *_controllersArray;
}
@end

@implementation OrderListBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}


- (void)configAttribute
{
    self.naviTitle = @"我的工单";
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"待处理",@"已处理"] lineColor:colorWithMainColor delegate:self];
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
    
    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"WaitToDealViewController",@"DeailedViewController"]];
    
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

-(void)loadControllerWithIndex:(int)index
{
    if ([_controllersArray[index] isKindOfClass:[NSString class]])
    {
        UIViewController *controller = [[NSClassFromString(_controllersArray[index])  alloc]init];
        [controller performSelector:@selector(setControllFrame:) withObject:NSStringFromCGRect(CGRectMake(YGScreenWidth * index, 0, _scrollView.width, _scrollView.height))];
        
        [self addChildViewController:controller];
        [_scrollView addSubview:controller.view];
        [_controllersArray replaceObjectAtIndex:index withObject:controller];
    }
}

@end



