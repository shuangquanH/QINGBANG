//
//  TakePicturesStatusController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TakePicturesStatusController.h"
#import "YGSegmentView.h"//点击切换视图View
#import "TakePicturesOrderListController.h"


@interface TakePicturesStatusController ()<UIScrollViewDelegate,YGSegmentViewDelegate>
/** 父控制器 上 加scrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 点击切换 子控制器 视图  */
@property (nonatomic,strong) YGSegmentView * titleView;
/** 子控制器数组  */
@property (nonatomic,strong) NSArray * childArray;
/** 子控制对应的标题数组  */
@property (nonatomic,strong) NSArray * titleArray;
@end

@implementation TakePicturesStatusController

- (instancetype)initWithTitleArray:(NSArray *)titleArray viewControllerClassStringArray:(NSArray *)classArray navgationTitle : (NSString *)title{
    self.navigationItem.title = title;
    
    UIButton *navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navRightButton.frame = CGRectMake(0, 0, 30, 30);
    [navRightButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [navRightButton setTitle:@"" forState:UIControlStateNormal];
    [navRightButton setImage:[UIImage imageNamed:@"service_green"] forState:UIControlStateNormal];
    [navRightButton addTarget:self action:@selector(contactClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.childArray = [classArray copy];
    self.titleArray = [titleArray copy];
    //添加子控制器
    [self addChildViewControllers];
    //设置头部视图
    self.titleView = [[YGSegmentView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, YGNaviBarHeight) titlesArray:self.titleArray lineColor:LDMainColor delegate:self];
    self.titleView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:self.titleView];
    
    //添加ScrollowView
    [self.view addSubview:self.backScrollowView];
    
    //默认选中
    [self addChildVcViewIntoScrollView:0];
    
    return self;
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
        TakePicturesOrderListController * vc = [[className alloc] init];
        vc.pageType = i;
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

//拨打客服电话
-(void)contactClick:(UIButton *)btn
{
    [self contactWithCustomerServerWithType:ContactServerTakePicturesEasy button:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
