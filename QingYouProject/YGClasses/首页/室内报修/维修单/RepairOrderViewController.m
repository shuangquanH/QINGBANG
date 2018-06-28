//
//  RepairOrderViewController.m
//  QingYouProject
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RepairOrderViewController.h"
#import "YGSegmentView.h"

@interface RepairOrderViewController ()<YGSegmentViewDelegate,UIScrollViewDelegate>
{
    YGSegmentView *_segmentView;
    UIScrollView *_scrollView;
    NSMutableArray *_controllersArray;
}
@end

@implementation RepairOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}


- (void)configAttribute
{
    self.naviTitle = @"维修单";
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"待服务",@"处理中",@"已结单"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [self.view  addSubview: _segmentView];
    

    self.navigationItem.rightBarButtonItem =     [self createBarbuttonWithNormalImageName:@"decorate_nav_icon" selectedImageName:@"service_green" selector:@selector(rightBarButtonClick:)];
    
}
#pragma mark - 导航栏右侧按钮点击
- (void)rightBarButtonClick:(UIButton *)rightBarButton{
    
    [self contactWithCustomerServerWithType:ContactServerPropertyRepair button:rightBarButton];

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
    
    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"WaitToDealRepairOrderViewController",@"DeailIngRepairOrderViewController",@"DeailedRepairOrderViewController"]];
    
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




