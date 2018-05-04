//
//  MeetingDetailsViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MeetingDetailsViewController.h"
#import "YGSegmentView.h"

#import "LXScollTitleView.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"

#import "MeetingChildBookingViewController.h"
#import "MeetingChildDetailsController.h"
#import "MeetingChildIndructionController.h"

#import "MeetingBookingModel.h"

#define heraderHeight  YGScreenWidth * 0.6
@interface MeetingDetailsViewController () <UIScrollViewDelegate,SDCycleScrollViewDelegate,YGSegmentViewDelegate,MeetingChildBookingViewControllerDelegate,MeetingChildDetailsControllerDelegate,MeetingChildIndructionControllerDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
{
    NSMutableArray * _controllersArray;//Controller数组
    YGSegmentView * _segmentView;//选择器
    UIScrollView * _scrollView;
    MeetingChildBookingViewController * _bookingViewController;
    MeetingChildDetailsController * _detailsViewController;
    MeetingChildIndructionController * _indructionViewController;
    NSDictionary *_dataDic;
}
@property (nonatomic, strong) NSMutableArray *imageArray; //图片数组
@property (nonatomic, strong) NewPagedFlowView *pageFlowView; //轮播图
@end

@implementation MeetingDetailsViewController
{
    SDCycleScrollView *_adScrollview; //广告轮播
    UIView          *_baseView;
    UILabel *_titleLabel;
    UILabel *_newPriceLabel;
    UILabel  *_oldPriceLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArray = [NSMutableArray array];
    [self loadData];
    
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactButton.frame = CGRectMake(0, 0, 30, 30);
    [contactButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [contactButton setTitle:@"" forState:normal];
    [contactButton setImage:[UIImage imageNamed:@"service_green"] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:contactButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

//    self.imageArray = @[@"0.jpg",@"5.jpg",@"6.jpg"].mutableCopy;

    [self configUI];
    
}

//联系电话
-(void)contact:(UIButton *)button
{
    [self contactWithCustomerServerWithType:ContactServerOrderMeetingRoom button:button];
}

//加载数据
-(void)loadData
{
    [YGNetService YGPOST:REQUEST_getBoardRoom parameters:@{@"id":self.idString} showLoadingView:YES scrollView:nil success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        self.imageArray = [responseObject valueForKey:@"imgList"];
        
        _dataDic = [responseObject valueForKey:@"boardRoom"];
        _bookingViewController.unitPriceString = [_dataDic valueForKey:@"expense"];
        NSLog(@"%@",_dataDic);
        
       [_pageFlowView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark ---- 配置UI
-(void)configUI
{
    self.naviTitle = @"会议室详情";
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, heraderHeight)];
    _baseView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_baseView];
    
    [self setScrollerView];
    
    /********************** 分割线 ********************/
//    UIView *seperateView = [[UIView alloc] initWithFrame:CGRectMake(0, YGScreenWidth/2 + 10, YGScreenWidth, 10)];
//    seperateView.backgroundColor = colorWithTable;
//    [_baseView addSubview:seperateView];
    
    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"预定",@"详情",@"须知"]];
    
    /********************** 选择器 ********************/
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(30, _baseView.height-40, YGScreenWidth-60, 40) titlesArray:_controllersArray lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    _segmentView.lineColor = colorWithMainColor;
    [_baseView addSubview:_segmentView];
    
    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _baseView.height, YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - _segmentView.height)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * _controllersArray.count, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //默认第0页
    [self segmentButtonClickWithIndex:0];
}
//卡片轮播图
- (void)setScrollerView{
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 9 / 16 - 30)];
    pageFlowView.backgroundColor = YGUIColorFromRGB(0xefeff4, 1);
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.orginPageCount = self.imageArray.count;
    pageFlowView.isOpenAutoScroll = YES;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, YGScreenWidth, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    
    [_baseView addSubview:pageFlowView];
    
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth / 2)];
    [pageFlowView reloadData];
    [bottomScrollView addSubview:pageFlowView];
    //    [self.view addSubview:bottomScrollView];
    [_baseView addSubview:bottomScrollView];
    
    self.pageFlowView = pageFlowView;
    //添加到主view上
    //    [self.view addSubview:self.indicateLabel];
    //    [_headerView addSubview:self.indicateLabel];
    
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView
{
    return CGSizeMake(YGScreenWidth - 40, (YGScreenWidth - 40) * 9 / 16 - 30);
}
//点击了第几个cell
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    //    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)subIndex + 1];
}

#pragma mark NewPagedFlowView Datasource
//返回显示view的个数
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.imageArray.count;
}

//给某一列设置属性
- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenWidth * 9 / 16 - 30)];
    }
    
    //在这里下载网络图片
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[index]] placeholderImage:YGDefaultImgTwo_One];
    
//    bannerView.mainImageView.image = [UIImage imageNamed:self.imageArray[index]];
    bannerView.layer.cornerRadius = 6;
    bannerView.layer.masksToBounds = YES;
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"TestViewController 滚动到了第%ld页",pageNumber);
}
- (void)dealloc {
    
    /****************************
     在dealloc或者返回按钮里停止定时器
     ****************************/
    
    [self.pageFlowView stopTimer];
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
        if (_bookingViewController == nil) {
            _bookingViewController = [[MeetingChildBookingViewController alloc]init];
            _bookingViewController.idString = self.idString;
            _bookingViewController.unitPriceString = [_dataDic valueForKey:@"expense"];
            _bookingViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            _bookingViewController.meetingChildBookingViewControllerDelegate = self;
            [self addChildViewController:_bookingViewController];
            [_scrollView addSubview:_bookingViewController.view];
            
        }
    }
    else if (index == 1)
    {
        if (_detailsViewController == nil) {
            _detailsViewController = [[MeetingChildDetailsController alloc]init];
            _detailsViewController.dataDic = _dataDic;
            _detailsViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            _detailsViewController.meetingChildDetailsControllerDelegate = self;
            [self addChildViewController:_detailsViewController];
            [_scrollView addSubview:_detailsViewController.view];
            
        }
        
    }else
    {
        if (_indructionViewController == nil) {
            _indructionViewController = [[MeetingChildIndructionController alloc]init];
            _indructionViewController.noteString = [_dataDic valueForKey:@"notes"];
            _indructionViewController.controllerFrame = CGRectMake(YGScreenWidth * index,1, _scrollView.width, _scrollView.height);
            _indructionViewController.meetingChildIndructionControllerrDelegate = self;
            [self addChildViewController:_indructionViewController];
            [_scrollView addSubview:_indructionViewController.view];
            
        }
        
    }
}

#pragma mark ---- DiscoverySubViewController上拉滑动更新位置代理
- (void)scrollViewDidScrollWithHeight:(CGFloat)offset {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGFloat height = _baseView.height;//偏移量
        if (offset > 0)//向下拉是负值，向上是正
        {
            _baseView.y = - height + _segmentView.height;
        }
        else if(offset < 0)
        {
            _baseView.y = 0;
            
        }
        _scrollView.y = CGRectGetMaxY(_baseView.frame);
        
    } completion:nil];
    
}

@end
