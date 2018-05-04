//
//  AddressAskViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/27.
//  Copyright © 2017 ccyouge. All rights reserved.
//

#import "AddressAskViewController.h"
#import "YGSegmentView.h"
#import "AddressAskSubViewController.h"


@interface AddressAskViewController () <UIScrollViewDelegate,YGSegmentViewDelegate>
{
    YGSegmentView *_segmentView;
    UIScrollView *_scrollView;
    NSMutableArray *_controllersArray;
}
@end

@implementation AddressAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configUI
{
    NSArray *titleArray;
    switch (_pageType)
    {
        case AddressAskPageTypeAddressAsk:
        {
            self.naviTitle = @"地址咨询";
            titleArray = @[@"已购买",@"受理中",@"已完成"];
        }
            break;
        case AddressAskPageTypeFinancialAccounting:
        {
            self.naviTitle = @"财务代记账";
            titleArray = @[@"已购买",@"受理中",@"已完成"];
        }
            break;
        case AddressAskPageTypeCommercialRegistration:
        {
            self.naviTitle = @"工商注册";
            titleArray = @[@"已购买",@"受理中",@"已完成"];
        }
            break;
        case AddressAskPageTypeAddressAskAndRegister:
        {
            self.naviTitle = @"地址咨询&工商注册";
            titleArray = @[@"已购买",@"受理中",@"已完成"];
        }
            break;
        case AddressAskPageTypeNetManager:
        {
            self.naviTitle = @"网络管理服务";
            titleArray = @[@"待处理",@"处理中",@"已处理"];
        }
            break;
        case AddressAskPageTypeADManager:
        {
            self.naviTitle = @"广告管理系统";
            titleArray = @[@"待处理",@"处理中",@"已处理"];
        }
            break;
        case AddressAskPageTypeVIPServiceManager:
        {
            self.naviTitle = @"VIP包月管理服务";
            titleArray = @[@"待处理",@"处理中",@"已处理"];
        }
            break;
    }

    _segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:titleArray lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:_segmentView];

    _controllersArray = [[NSMutableArray alloc]initWithArray:@[@"AddressAskSubViewController",@"AddressAskSubViewController",@"AddressAskSubViewController"]];

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentView.frame), YGScreenWidth, YGScreenHeight - YGNaviBarHeight - YGStatusBarHeight - _segmentView.height)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * _controllersArray.count, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];

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
    int index = (int) (scrollView.contentOffset.x / YGScreenWidth);

    [self loadControllerWithIndex:index];
    [_segmentView selectButtonWithIndex:index];
}

-(void)loadControllerWithIndex:(int)index
{
    if ([_controllersArray[(NSUInteger) index] isKindOfClass:[NSString class]])
    {
        AddressAskSubViewController *controller = (AddressAskSubViewController *) [[NSClassFromString(_controllersArray[index])  alloc]init];
        controller.controlFrame = CGRectMake(YGScreenWidth * index, 0, _scrollView.width, _scrollView.height);
        controller.pageType = _pageType;
        controller.subPageType = (AddressAskSubPageType) index;
        [self addChildViewController:controller];
        [_scrollView addSubview:controller.view];
        _controllersArray[(NSUInteger) index] = [[NSObject alloc] init];
    }
}

@end
