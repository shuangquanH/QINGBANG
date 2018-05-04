//
//  OfficePurchaseOrderListViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/23.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OfficePurchaseOrderListViewController.h"
#import "YGSegmentView.h"//点击切换视图View

@interface OfficePurchaseOrderListViewController ()<UIScrollViewDelegate,YGSegmentViewDelegate>
/** 父控制器 上 加scrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 点击切换 子控制器 视图  */
@property (nonatomic,strong) YGSegmentView * titleView;
/** 子控制器数组  */
@property (nonatomic,strong) NSArray * childArray;
/** 子控制对应的标题数组  */
@property (nonatomic,strong) NSArray * titleArray;
@end

@implementation OfficePurchaseOrderListViewController


- (instancetype)initWithTitleArray:(NSArray *)titleArray viewControllerClassStringArray:(NSArray *)classArray navgationTitle : (NSString *)title{
    self.naviTitle = title;
    self.childArray = [classArray copy];
    self.titleArray = [titleArray copy];
    //添加子控制器
    [self addChildViewControllers];

    //设置头部视图
    self.titleView = [[YGSegmentView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, YGNaviBarHeight) titlesArray:self.titleArray lineColor:LDMainColor delegate:self];
    [self.view addSubview:self.titleView];
    
    //添加ScrollowView
    [self.view addSubview:self.backScrollowView];
    
    //默认选中
    [self addChildVcViewIntoScrollView:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushViewController:) name:@"OfficePurchaseOrderSurePay" object:nil];

    return self;
}
- (void)pushViewController:(NSNotification *)notif
{
    //默认选中
    [self segmentButtonClickWithIndex:0];
    [self.titleView selectButtonWithIndex:0];

}

#pragma mark - titleView点击代理方法
-(void)segmentButtonClickWithIndex:(int)buttonIndex{
    
    [self addChildVcViewIntoScrollView:buttonIndex];
    
    CGFloat offsetX = self.backScrollowView.ld_width * buttonIndex;
    self.backScrollowView.contentOffset = CGPointMake(offsetX, self.backScrollowView.contentOffset.y);
}

#pragma mark - 添加子控制器
- (void)addChildViewControllers{
    
    for (int i = 0; i < self.childArray.count; i++) {
        
        Class className = NSClassFromString(self.childArray[i]);
        
        UIViewController * vc = [[className alloc] init];
        [self addChildViewController:vc];
        
    }
    
}
#pragma mark - scrollView监听
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = (int)(scrollView.contentOffset.x / kScreenW);
    
    [self segmentButtonClickWithIndex:index];
    
    [self.titleView selectButtonWithIndex:index];
}


/**
 *  添加第index个子控制器的view到scrollView中
 */
- (void)addChildVcViewIntoScrollView:(NSUInteger)index
{
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    // 设置子控制器view的frame
    CGFloat scrollViewW = self.backScrollowView.ld_width;
    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.backScrollowView.ld_height);
    // 添加子控制器的view到scrollView中
    [self.backScrollowView addSubview:childVcView];
}


#pragma mark - scrollowView设置
- (UIScrollView *)backScrollowView{
    
    if (!_backScrollowView) {
        //获取titleView最大Y值,即为背景sscrollowView的Y值
        CGFloat Y = CGRectGetMaxY(self.titleView.frame);
        //获取scrollowView的高度
        CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight - self.titleView.ld_height;
        
        _backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Y, kScreenW, H)];
        
        _backScrollowView.contentSize = CGSizeMake(YGScreenWidth * self.childArray.count, _backScrollowView.ld_height);
        
        _backScrollowView.showsVerticalScrollIndicator = NO;
        _backScrollowView.showsHorizontalScrollIndicator = NO;
        _backScrollowView.pagingEnabled = YES;
        _backScrollowView.delegate = self;
        _backScrollowView.backgroundColor = kWhiteColor;
        
    }
    return _backScrollowView;
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
