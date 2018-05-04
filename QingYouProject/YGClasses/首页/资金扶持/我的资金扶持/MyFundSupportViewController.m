//
//  MyFundSupportViewController.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyFundSupportViewController.h"
#import "SubscribeWaitToPayViewController.h"
#import "MyRoadShowViewController.h"
#import "MyInvestViewController.h"
#import "RealNameCertifyViewController.h"

@interface MyFundSupportViewController ()

@end

@implementation MyFundSupportViewController
{
    UIScrollView    *_mainScrollView;
    SDCycleScrollView *_topScrollview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)configUI
{
    self.naviTitle = @"我的资金扶持";
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, YGScreenHeight-64)];
    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, YGScreenHeight);
    [self.view addSubview:_mainScrollView];
    
    NSArray *itemsArray  = @[
                             @{
                                 @"img":@"mine_fund_project_person_certification",
                                 @"title":@"项目人认证"
                                 },
                             @{
                                 @"img":@"mine_fund_investor_certification",
                                 @"title":@"投资人认证"
                                 },
                             @{
                                 @"img":@"mine_fund_unpaid",
                                 @"title":@"认购待支付"
                                 },
                             @{
                                 @"img":@"mine_fund_my_investment",
                                 @"title":@"我的投资"
                                 },
                             @{
                                 @"img":@"mine_fund_roadshow",
                                 @"title":@"我的服务"
                                 },
                             @{
                                 @"img":@"mine_fund_myproject",
                                 @"title":@"我的项目"
                                 }

                             ];
    
    int r = 0;
    int k = 0;
    for (int i = 0 ; i<itemsArray.count;i++) {
        NSDictionary *dict = itemsArray[i];
        UIButton *coverButton = [[UIButton alloc]init];
        coverButton.tag = 1000+i;
        [coverButton addTarget:self action:@selector(functionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.backgroundColor = colorWithMainColor;
        coverButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        [_mainScrollView addSubview:coverButton];
        coverButton.frame = CGRectMake(YGScreenWidth/2*r, _topScrollview.height+(YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)/3*k, YGScreenWidth/2, (YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)/3);
        UIImage *titleImage = [UIImage imageNamed:dict[@"img"]];
        coverButton.backgroundColor = colorWithYGWhite;
        [coverButton setTitleColor:colorWithBlack forState:UIControlStateNormal];
        [coverButton setTitle:dict[@"title"] forState:UIControlStateNormal];
        [coverButton setImage:titleImage forState:UIControlStateNormal];
        coverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [coverButton setTitleEdgeInsets:UIEdgeInsetsMake(coverButton.imageView.frame.size.height ,-coverButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [coverButton setImageEdgeInsets:UIEdgeInsetsMake(-coverButton.imageView.frame.size.height, 0.0,0.0, -coverButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
        r++;
        if ((i+1)%2==0) {
            k++;
            r=0;
            UIView *linehoribleView = [[UIView alloc] initWithFrame:CGRectMake(0, coverButton.height*k-1, YGScreenWidth, 1)];
            linehoribleView.backgroundColor = colorWithLine;
            [_mainScrollView addSubview:linehoribleView];
        }
        
    }
    UIView *lineVerticalView = [[UIView alloc] initWithFrame:CGRectMake(YGScreenWidth/2, 0, 1, YGScreenHeight-YGNaviBarHeight-YGStatusBarHeight)];
    lineVerticalView.backgroundColor = colorWithLine;
    [_mainScrollView addSubview:lineVerticalView];

    _mainScrollView.contentSize = CGSizeMake(YGScreenWidth, YGScreenHeight-YGStatusBarHeight-YGNaviBarHeight);
    
}

- (void)functionBtnAction:(UIButton *)btn
{
    if (btn.tag -1000 == 4)
    {
        MyRoadShowViewController *controller = [[MyRoadShowViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
        return ;
    }
    if (YGSingletonMarco.user.isCertified == YES)
    {
        
        switch (btn.tag -1000) {
            case 0:
            {
                
                [YGAppTool showToastWithText:@"您已经认证过了"];
                
                break;
            }
            case 1:
            {
                [YGAppTool showToastWithText:@"您已经认证过了"];
                
                break;
            }
            case 2:
            {
                SubscribeWaitToPayViewController *controller = [[SubscribeWaitToPayViewController alloc]init];
                controller.pageType = @"myFundSupportSubscribeWaitToPay";
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
            case 3:
            {
                MyInvestViewController *controller = [[MyInvestViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
            case 5:
            {
                SubscribeWaitToPayViewController *controller = [[SubscribeWaitToPayViewController alloc]init];
                controller.pageType = @"myFundSupportMyProject";
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
        }
    }else
    {
    [YGNetService YGPOST:REQUEST_authentication parameters:@{@"userId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        YGSingletonMarco.user.isCertified =[responseObject[@"zhiMaXinYong"] boolValue];
        
        if (YGSingletonMarco.user.isCertified == NO) {
            if (btn.tag -1000 == 0 || btn.tag -1000 == 1) {
                RealNameCertifyViewController *controller = [[RealNameCertifyViewController alloc]init];
                
                [self.navigationController pushViewController:controller animated:YES];
                return ;
            }
            [YGAppTool showToastWithText:@"您尚未进行认证，请认证后使用该功能"];
            
        }else
        {
            switch (btn.tag -1000) {
                case 0:
                {
                    
                    [YGAppTool showToastWithText:@"您已经认证过了"];

                    break;
                }
                case 1:
                {
                    [YGAppTool showToastWithText:@"您已经认证过了"];

                    break;
                }
                case 2:
                {
                    SubscribeWaitToPayViewController *controller = [[SubscribeWaitToPayViewController alloc]init];
                    controller.pageType = @"myFundSupportSubscribeWaitToPay";
                    [self.navigationController pushViewController:controller animated:YES];
                    break;
                }
                case 3:
                {
                    MyInvestViewController *controller = [[MyInvestViewController alloc]init];
                    [self.navigationController pushViewController:controller animated:YES];
                    break;
                }
                case 5:
                {
                    SubscribeWaitToPayViewController *controller = [[SubscribeWaitToPayViewController alloc]init];
                    controller.pageType = @"myFundSupportMyProject";
                    [self.navigationController pushViewController:controller animated:YES];
                    break;
                }
            }
        }
        
                
        
    } failure:^(NSError *error) {
        
    }];
    }


}



@end
