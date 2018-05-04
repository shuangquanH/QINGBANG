//
//  AllianceCircleViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceCircleViewController.h"
#import "YGSegmentView.h"
#import "AllAllianceViewController.h"
#import "AllAllianceCollectionViewCell.h"

#import "MyFavoriteAllianceViewController.h"
#import "MyAllianceViewController.h"
#import "MyAllianceTableViewCell.h"
#import "AllianceMainViewController.h"

#import "RealNameCertifyViewController.h"
#import "TobeLeaderOfAllianceViewController.h"

@interface AllianceCircleViewController()<UIScrollViewDelegate>
{

    UIView *_baseView;
}

@end

@implementation AllianceCircleViewController
{
    SDCycleScrollView *_adScrollview; //广告轮播
    AllAllianceViewController *_allAllianceViewController;
    MyAllianceViewController *_myyAllianceViewController;
    MyFavoriteAllianceViewController *_myFavoriteAllianceViewController;
    YGSegmentView *_segmentView;
    UIScrollView * _scrollView;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

- (void)configAttribute
{
//    self.naviTitle = @"联盟圈";
    UILabel *naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth - 120, 20)];
    naviTitleLabel.textColor = colorWithBlack;
    naviTitleLabel.textAlignment = NSTextAlignmentCenter;
    naviTitleLabel.text = @"联盟圈" ;
    [naviTitleLabel sizeToFit];
    naviTitleLabel.frame = CGRectMake(YGScreenWidth/2-naviTitleLabel.width/2, 0, naviTitleLabel.width, 20);
    self.navigationItem.titleView = naviTitleLabel;
    UIBarButtonItem *buttonItem =[self createBarbuttonWithNormalTitleString:@"联盟中心" selectedTitleString:@"联盟中心" selector:@selector(pushToAllianceCenter:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
}
- (void)configUI
{
    self.view.backgroundColor = colorWithTable;
    
    //选择页面按钮
    YGSegmentView *segmentView = [[YGSegmentView alloc]initWithFrame:CGRectMake(0, 0, YGScreenWidth, 40) titlesArray:@[@"全部",@"我的联盟",@"我关注的"] lineColor:colorWithMainColor delegate:self];
    _segmentView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:segmentView];
    
    /********************* _scrollView ***************/
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, YGScreenWidth, YGScreenHeight -_segmentView.height)];
    _scrollView.contentSize = CGSizeMake(YGScreenWidth * 3, _scrollView.height);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //默认第0页
    [self segmentButtonClickWithIndex:0];
}


#pragma mark ---- 改变当前Controller
-(void)segmentButtonClickWithIndex:(int)buttonIndex
{
    [self loadControllerWithIndex:buttonIndex];
    
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(buttonIndex * YGScreenWidth, _scrollView.contentOffset.y);
    }];
}

//#pragma mark ---- 滑动切换Controller
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    int index = scrollView.contentOffset.x / YGScreenWidth;
//    [self loadControllerWithIndex:index];
//    [_segmentView selectButtonWithIndex:index];
//}

#pragma mark ---- 加载Controller
-(void)loadControllerWithIndex:(int)index
{
    if (index == 0)
    {
        if (_allAllianceViewController == nil) {
            _allAllianceViewController = [[AllAllianceViewController alloc]init];
            _allAllianceViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_allAllianceViewController];
            [_scrollView addSubview:_allAllianceViewController.view];
            
        }
    }
    else if (index == 1)
    {
        if (_myyAllianceViewController == nil) {
            _myyAllianceViewController = [[MyAllianceViewController alloc]init];
            _myyAllianceViewController.controllerFrame = CGRectMake(YGScreenWidth * index, 1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myyAllianceViewController];
            [_scrollView addSubview:_myyAllianceViewController.view];
            
        }
        
    }else
    {
        if (_myFavoriteAllianceViewController == nil) {
            _myFavoriteAllianceViewController = [[MyFavoriteAllianceViewController alloc]init];
            _myFavoriteAllianceViewController.controllerFrame = CGRectMake(YGScreenWidth * index,1, _scrollView.width, _scrollView.height);
            [self addChildViewController:_myFavoriteAllianceViewController];
            [_scrollView addSubview:_myFavoriteAllianceViewController.view];
            
        }
        
    }
}

- (void)pushToAllianceCenter:(UIButton *)btn
{
    if (![self loginOrNot])
    {
        return;
    }
    btn.userInteractionEnabled = NO;

    [YGNetService YGPOST:REQUEST_isManager parameters:@{@"userID":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        btn.userInteractionEnabled = YES;

        if ([responseObject[@"isManager"] isEqualToString:@"1"]) {
            
            [YGAlertView showAlertWithTitle:@"您还不是盟主哦！" buttonTitlesArray:@[@"立即申请",@"先看看"] buttonColorsArray:@[colorWithMainColor,colorWithPlaceholder] handler:^(NSInteger buttonIndex) {
                [YGNetService YGPOST:REQUEST_authentication parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
                    if (buttonIndex == 1) {
                        return ;
                    }
                    YGSingletonMarco.user.isCertified =[responseObject[@"zhiMaXinYong"] boolValue];
                    if (YGSingletonMarco.user.isCertified == NO) {
                        RealNameCertifyViewController *controller = [[RealNameCertifyViewController alloc]init];
                        controller.createFieldsType = @"createAllaince";
                        [self.navigationController pushViewController:controller animated:YES];
                    }else
                    {
#pragma 认证状态提取完再从服务请求是否已填写联盟申请
                        TobeLeaderOfAllianceViewController *controller = [[TobeLeaderOfAllianceViewController alloc]init];
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                    
                } failure:^(NSError *error) {

                }];
                
            }];
        }else if([responseObject[@"isManager"] isEqualToString:@"0"])
        {
            //是盟主并且是自己的联盟
            YGSingletonMarco.user.allianceID = responseObject[@"allianceID"];
            
            AllianceMainViewController *mainVc = [[AllianceMainViewController alloc] init];
            mainVc.allianceID = responseObject[@"allianceID"];
            [self.navigationController pushViewController:mainVc animated:YES];
        }else
        {
            [YGAppTool showToastWithText:@"您的联盟圈申请在审核中。。请耐心等待！"];
        }

        
    } failure:^(NSError *error) {
        btn.userInteractionEnabled = YES;

    }];
  
}



@end
