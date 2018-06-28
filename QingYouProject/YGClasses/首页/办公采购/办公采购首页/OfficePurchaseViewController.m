//
//  OfficePurchaseViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OfficePurchaseViewController.h"
#import "YGSegmentView.h"//点击切换视图View
#import "OfficePurchaseChildViewController.h"//子控制器
#import "OfficePurchaseDetailViewController.h"







@interface OfficePurchaseViewController ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,YGSegmentViewDelegate>
/** 轮播图  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/** 父控制器 上 加scrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 点击切换 子控制器 视图  */
@property (nonatomic,strong) YGSegmentView * titleView;
/** 子控制器数组  */
@property (nonatomic,strong) NSMutableArray * childArray;
/** 子控制对应的标题数组  */
@property (nonatomic,strong) NSMutableArray * titleArray;
@property (nonatomic,strong) NSMutableArray * procurementIDArray;


@property (nonatomic,strong) NSArray * categoryList;


@end

@implementation OfficePurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //网络请求
    [self sendRequest];
    //设置导航栏
    self.naviTitle = @"办公采购";
}

#pragma mark - 网络请求数据
- (void)sendRequest{
    
    [YGNetService YGPOST:@"ProcurementIndex" parameters:@{} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        self.categoryList = [responseObject valueForKey:@"categoryList"];
        
        self.childArray = [NSMutableArray array];
        self.titleArray = [NSMutableArray array];
        
        for (int i = 0; i < self.categoryList.count ; i++) {
          
          NSDictionary * dict = self.categoryList[i];
          [self.titleArray addObject:[dict objectForKey:@"categoryName"]];

          //子控制器数组
          [self.childArray addObject:@"OfficePurchaseChildViewController"];
        }
        
        //设置UI
        [self setupUI];
        
        self.procurementIDArray = [NSMutableArray array];
        NSMutableArray * imgArry = [NSMutableArray array];

        NSMutableArray * imgList = [responseObject valueForKey:@"imgList"];

        for (int i = 0; i < imgList.count ; i++) {
            
            NSDictionary * dict = imgList[i];
            [imgArry addObject:[dict objectForKey:@"img"]];

            [self.procurementIDArray addObject:[dict objectForKey:@"procurementID"]];
        }
        
        self.cycleScrollView.imageURLStringsGroup = imgArry;
    
        
    } failure:^(NSError *error) {
        
        
    }];
}
#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    OfficePurchaseDetailViewController * detailVC = [[OfficePurchaseDetailViewController alloc] init];
    detailVC.commodityID = self.procurementIDArray[index];

    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark - 设置UI
- (void)setupUI{
    self.view.backgroundColor = LDEEPaddingColor;
    //轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.width, floorf(kScreenW / Banner_W_H_Scale)) delegate:self placeholderImage:YGDefaultImgTwo_One];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.contentMode = UIViewContentModeScaleAspectFill;
    self.cycleScrollView.clipsToBounds = YES;
    self.cycleScrollView.autoScrollTimeInterval = 3;
    [self.view addSubview:self.cycleScrollView];
    
    //添加子控制器
    [self addChildViewControllers];

    //设置头部视图
    self.titleView = [[YGSegmentView alloc] initWithFrame:CGRectMake(0, floorf(kScreenW / Banner_W_H_Scale) + 1, kScreenW, YGNaviBarHeight) titlesArray:self.titleArray lineColor:LDMainColor delegate:self];
    [self.view addSubview:self.titleView];
    self.titleView.backgroundColor = [UIColor whiteColor];
    
    //添加ScrollowView
    [self.view addSubview:self.backScrollowView];
    
    //默认选中
    if(self.categoryList.count >0)
      [self addChildVcViewIntoScrollView:0];
}

#pragma mark - titleView点击代理方法
-(void)segmentButtonClickWithIndex:(int)buttonIndex{
    
    [self addChildVcViewIntoScrollView:buttonIndex];
    
    CGFloat offsetX = self.backScrollowView.width * buttonIndex;
    self.backScrollowView.contentOffset = CGPointMake(offsetX, self.backScrollowView.contentOffset.y);
    
}

#pragma mark - 添加子控制器
- (void)addChildViewControllers{
    
    for (int i = 0; i < self.childArray.count; i++) {
        
         NSDictionary * dict = self.categoryList[i];
        
        Class className = NSClassFromString(self.childArray[i]);
        
        OfficePurchaseChildViewController * vc = (OfficePurchaseChildViewController *)[[className alloc] init];
        vc.dataType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"categoryID"]];
        
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
    CGFloat scrollViewW = self.backScrollowView.width;
    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.backScrollowView.height);
    // 添加子控制器的view到scrollView中
    [self.backScrollowView addSubview:childVcView];
}


#pragma mark - scrollowView设置
- (UIScrollView *)backScrollowView{
    
    if (!_backScrollowView) {
        //获取titleView最大Y值,即为背景sscrollowView的Y值
        CGFloat Y = CGRectGetMaxY(self.titleView.frame);
        //获取scrollowView的高度
        CGFloat H = kScreenH - YGNaviBarHeight - YGStatusBarHeight - self.titleView.height - floorf(kScreenW / Banner_W_H_Scale);
        
        _backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Y, kScreenW, H)];
        _backScrollowView.contentSize = CGSizeMake(YGScreenWidth * self.childArray.count, _backScrollowView.height);
        
        _backScrollowView.showsVerticalScrollIndicator = NO;
        _backScrollowView.showsHorizontalScrollIndicator = NO;
        _backScrollowView.pagingEnabled = YES;
        _backScrollowView.delegate = self;
        _backScrollowView.backgroundColor = kWhiteColor;
    }
    return _backScrollowView;
    
}
@end
