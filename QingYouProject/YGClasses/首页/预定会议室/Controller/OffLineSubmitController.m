//
//  OffLineSubmitController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/10/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OffLineSubmitController.h"
#import "MeetingDetailsViewController.h"

@interface OffLineSubmitController ()

@end

@implementation OffLineSubmitController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviTitle = @"提交成功";
    
   [self setFd_interactivePopDisabled:YES];
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(0, 0, 35, 35);
    [completeButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    completeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [completeButton addTarget:self action:@selector(completeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:completeButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self configUI];
}

-(void)configUI
{
    UIView *baseTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 150)];
    baseTopView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseTopView];
    
    UIImageView *correctImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_finish_icon_green"]];
    [correctImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [baseTopView addSubview:correctImageView];
    
    UILabel *bottomLabel = [[UILabel alloc]init];
    bottomLabel.textColor = colorWithDeepGray;
    bottomLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [bottomLabel addAttributedWithString:@"您已提交成功" lineSpace:8];
    //    bottomLabel.text = bottomString;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.numberOfLines = 0;
    [baseTopView addSubview:bottomLabel];
    
    UIView *baseBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, baseTopView.height+10, YGScreenWidth, 70)];
    baseBottomView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseBottomView];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.frame = CGRectMake(0, 20, YGScreenWidth, 30);
    tipLabel.textColor = colorWithDeepGray;
    tipLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [tipLabel addAttributedWithString:@"下单后24小时内去园区付款,超过24小时订单取消" lineSpace:8];
    [tipLabel addAttributedWithString:@"下单后24小时内去园区付款,超过24小时订单取消" range:NSMakeRange(3, 4) color:colorWithMainColor];
//    [tipLabel addAttributedWithString:@"下单后24小时内去园区付款,超过24小时订单取消" range:NSMakeRange(16, 4) color:colorWithMainColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    [baseBottomView addSubview:tipLabel];
    
    [correctImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(self.view);
         make.top.mas_equalTo(35);
     }];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.mas_equalTo(correctImageView);
         make.top.mas_equalTo(correctImageView.mas_bottom).offset(12);
     }];
}

- (void)completeButtonClick:(UIButton *)button
{
    if([self.pageType isEqualToString:@"orderPay"])
    {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
    }
    if([self.pageType isEqualToString:@"reservationPay"])
    {
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[MeetingDetailsViewController class]]) {
                break;
            }
        }
        [navc setViewControllers:viewControllers];
    }
}
-(void)back
{
    if([self.pageType isEqualToString:@"orderPay"])
    {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
    }
    if([self.pageType isEqualToString:@"reservationPay"])
    {
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[MeetingDetailsViewController class]]) {
                break;
            }
        }
        [navc setViewControllers:viewControllers];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
