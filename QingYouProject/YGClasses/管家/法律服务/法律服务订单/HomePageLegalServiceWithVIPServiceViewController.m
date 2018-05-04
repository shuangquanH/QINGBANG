//
//  HomePageLegalServiceWithVIPServiceViewController.m
//  QingYouProject
//
//  Created by apple on 2018/1/31.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "HomePageLegalServiceWithVIPServiceViewController.h"
#import "YGSegmentView.h"
@interface HomePageLegalServiceWithVIPServiceViewController ()<YGSegmentViewDelegate,UIScrollViewDelegate>
{
    YGSegmentView *_segmentView;
    UIScrollView *_scrollView;
    NSMutableArray *_controllersArray;
    UIButton * _netButton;
    UIButton * _vipButton;
    
    YGSegmentView *_VIPsegmentView;
    UIScrollView *_VIPscrollView;
    NSMutableArray *_VIPcontrollersArray;
    BOOL _isVip;
    BOOL _isFirst;
    
}
@end

@implementation HomePageLegalServiceWithVIPServiceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isVip = NO;
    _isFirst = YES;
    [self configUI];
    
    _VIPsegmentView.hidden =YES;
    _VIPscrollView.hidden =YES;
    

}


- (void)configAttribute
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.navigationItem.titleView  =titleView;
    
    _netButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleView.width/2, titleView.height)];
    [_netButton setTitle:@"法律服务" forState:UIControlStateNormal];
    [titleView addSubview:_netButton];
    [_netButton addTarget:self action:@selector(netButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _netButton.titleLabel.font = leftFont;
    [_netButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    
    _vipButton =[[UIButton alloc]initWithFrame:CGRectMake(titleView.width/2, 0, titleView.width/2, titleView.height)];
    [_vipButton setTitle:@"VIP包月服务" forState:UIControlStateNormal];
    [titleView addSubview:_vipButton];
    [_vipButton addTarget:self action:@selector(vipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _vipButton.titleLabel.font = leftFont;
    [_vipButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(titleView.width/2, (titleView.height -15)/2, 1, 15)];
    line.backgroundColor = YGUIColorFromRGB(0xe0e0e0, 1);
    [titleView addSubview:line];
    
    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"待处理",@"处理中",@"已处理"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [self.view  addSubview: _segmentView];
    
}
-(void)netButtonClick:(UIButton *)btn
{
    _isVip = NO;
    
    _VIPsegmentView.hidden =YES;
    _VIPscrollView.hidden =YES;
    _scrollView.hidden =NO;
    _segmentView.hidden =NO;
    
    [_netButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_vipButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
}
-(void)vipButtonClick:(UIButton *)btn
{
    _isVip = YES;
    
    if(_isFirst)
    {
        _isFirst = NO;
        [self configUIVIP];
    }
    
    _VIPsegmentView.hidden =NO;
    _VIPscrollView.hidden = NO;
    _scrollView.hidden = YES;
    _segmentView.hidden = YES;
    
    [_vipButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
    [_netButton setTitleColor:colorWithDeepGray forState:UIControlStateNormal];
    
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
    
    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"HomePageLegalServiceWaitTorViewController",@"HomePageLegalDealingViewController",@"HomePageLegalDealedViewController"]];
    
    [self segmentButtonClickWithIndex:0];
}

-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [self loadControllerWithIndex:buttonIndex];
    
    if(_isVip)
    {
        [UIView animateWithDuration:0.25 animations:^{
            _VIPscrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _VIPscrollView.contentOffset.y);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            _scrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _scrollView.contentOffset.y);
        }];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / YGScreenWidth;
    
    [self loadControllerWithIndex:index];
    if(_isVip)
        [_VIPsegmentView selectButtonWithIndex:index];
    else
        [_segmentView selectButtonWithIndex:index];
}

-(void)loadControllerWithIndex:(int)index
{
    if(_isVip)
    {
        if ([_VIPcontrollersArray[index] isKindOfClass:[NSString class]])
        {
            UIViewController *controller = [[NSClassFromString(_VIPcontrollersArray[index])  alloc]init];
            [controller performSelector:@selector(setControllFrame:) withObject:NSStringFromCGRect(CGRectMake(YGScreenWidth * index, 0, _VIPscrollView.width, _VIPscrollView.height))];
            [controller performSelector:@selector(setPushView:) withObject:@"isVIP"];
            
            [self addChildViewController:controller];
            [_VIPscrollView addSubview:controller.view];
            [_VIPcontrollersArray replaceObjectAtIndex:index withObject:controller];
        }
    }
    else
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
}

- (void)configUIVIP
{
    _VIPsegmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"待处理",@"处理中",@"已处理"] lineColor:colorWithMainColor delegate:self];
    _VIPsegmentView.backgroundColor = colorWithYGWhite;
    [self.view  addSubview: _VIPsegmentView];
    
    _VIPscrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _segmentView.y + _segmentView.height, YGScreenWidth, YGScreenHeight - (YGStatusBarHeight + YGNaviBarHeight) - _segmentView.y - _segmentView.height)];
    _VIPscrollView.contentSize = CGSizeMake(YGScreenWidth * _segmentView.titlesArray.count, _scrollView.height);
    _VIPscrollView.showsVerticalScrollIndicator = NO;
    _VIPscrollView.showsHorizontalScrollIndicator = NO;
    _VIPscrollView.pagingEnabled = YES;
    _VIPscrollView.delegate = self;
    [self.view addSubview:_VIPscrollView];
    
    _VIPcontrollersArray = [[NSMutableArray alloc]initWithArray:@[@"HomePageLegalServiceWaitTorViewController",@"HomePageLegalDealingViewController",@"HomePageLegalDealedViewController"]];
    
    [self segmentButtonClickWithIndex:0];
}

@end






