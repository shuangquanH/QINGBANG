//
//  ResultViewController.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/9/26.
//  Copyright © 2017 ccyouge. All rights reserved.
//

#import "ResultViewController.h"
#import "BreakContractBillViewController.h"
#import "MeetingDetailsViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configAttribute
{
    NSString *bottomString;
    UIColor *color;
    
    
    switch (self.pageType)
    {
        case ResultPageTypeOfflinePayResult:
        {
            self.naviTitle = @"线下支付";
            bottomString = @"您已成功下单\n我们将在第一时间为您处理";
            color = colorWithYGWhite;

        }
            break;
        case ResultPageTypeNetVIPOfflinePayResult:
        {
            self.naviTitle = @"线下支付";
            bottomString = @"您已成功下单\n我们将在第一时间为您处理";
            color = colorWithYGWhite;
            
        }
            break;
        case (ResultPageTypeOnlinePayResult):
        {
            self.naviTitle = @"支付结果";
            bottomString = @"您的订单已支付成功\n我们将在第一时间为您处理";
            color = colorWithTable;
        }
            break;
            
        case ResultPageTypeSubmitResult:
        {
            self.naviTitle = @"提交成功";
            bottomString = @"您的广告位申请已成功提交\n等待审核";
            color = colorWithYGWhite;
        }
            break;
            //开始
        case (ResultPageTypeIndustryFinancialResult):
        {
            self.naviTitle = @"支付结果";
            bottomString = @"您的订单已支付成功\n我们将在第一时间为您处理";
            color = colorWithTable;
        }
            break;
        case (ResultPageTypeSubmitNetmanagerResult)://青币网络管家翻一页
        {
            self.naviTitle = @"支付成功";
            bottomString = @"您的订单已支付成功\n我们将在第一时间为您处理";
            color = colorWithTable;
        }
            break;
    
        case ResultPageTypeSubmitHousePayResult:
        {
            self.naviTitle = @"支付成功";
            bottomString = @"您已支付成功";
            color = colorWithYGWhite;
        }
            break;
        case ResultPageTypeSubmitOfficeResult: //青币办公采购
        {
            self.naviTitle = @"支付成功";
            bottomString = @"您已支付成功";
            color = colorWithYGWhite;
        }
            break;
        case ResultPageTypeSubmitPlayTogether://
        {
            self.naviTitle = @"支付成功";
            bottomString = @"支付成功，我们将第一时间为您处理！";
            color = colorWithYGWhite;
        }
            break;
        case ResultPageTypeNetVIPPayResult://
        {
            self.naviTitle = @"支付成功";
            bottomString = @"支付成功，我们将第一时间为您处理！";
            color = colorWithTable;
        }
            break;
        case (ResultPageTypeMeetingResult)://会议室青币
        {
            self.naviTitle = @"支付结果";
            bottomString = @"您的订单已支付成功\n我们将在第一时间为您处理";
            color = colorWithTable;
        }
            break;
        case ResultPageTypeSubmitPurchsePayResult://青币抢购
        {
            self.naviTitle = @"支付成功";
            bottomString = @"您已支付成功";
            color = colorWithTable;
        }
            break;
         
    }

    self.navigationItem.rightBarButtonItem = [self createBarbuttonWithNormalTitleString:@"完成" selectedTitleString:@"完成" selector:@selector(doneButtonClick)];
    [self configUIWithBottomString:bottomString withBackColor:color];
}

- (void)configUIWithBottomString:(NSString *)bottomString withBackColor:(UIColor *)color
{
    self.view.backgroundColor = color;

    UIView *baseTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 150)];
    baseTopView.backgroundColor = colorWithYGWhite;
    [self.view addSubview:baseTopView];
    
    UIImageView *correctImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_finish_icon_green"]];
    [correctImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [baseTopView addSubview:correctImageView];

    UILabel *bottomLabel = [[UILabel alloc]init];
    bottomLabel.textColor = colorWithDeepGray;
    bottomLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [bottomLabel addAttributedWithString:bottomString lineSpace:8];
//    bottomLabel.text = bottomString;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.numberOfLines = 0;
    [baseTopView addSubview:bottomLabel];

//    UIView *baseBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, baseTopView.height+10, YGScreenWidth, 70)];
//    baseBottomView.backgroundColor = colorWithYGWhite;
//    [self.view addSubview:baseBottomView];

// || self.pageType == ResultPageTypeSubmitPurchsePayResult   self.pageType == ResultPageTypeSubmitOfficeResult || self.pageType == ResultPageTypeMeetingResult ||  self.pageType == ResultPageTypeIndustryFinancialResult
    
    if( self.pageType == ResultPageTypeSubmitNetmanagerResult || self.pageType == ResultPageTypeNetVIPPayResult)
    {
        UIView *baseBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, baseTopView.height+10, YGScreenWidth, 70)];
        baseBottomView.backgroundColor = colorWithYGWhite;
        [self.view addSubview:baseBottomView];

        UILabel *pointsLabel = [[UILabel alloc]init];
        pointsLabel.textColor = colorWithOrangeColor;
        pointsLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        [pointsLabel addAttributedWithString:bottomString lineSpace:8];
        [pointsLabel addAttributedWithString:[NSString stringWithFormat:@"恭喜您获得%d个青币",_earnPoints] range:NSMakeRange(0, @"恭喜您获得".length) color:colorWithBlack];
        [baseBottomView addSubview:pointsLabel];

        UIImageView *pointsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"integral_gain_icon"]];
        [baseBottomView addSubview:pointsImageView];

        [pointsLabel mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.top.mas_equalTo(baseBottomView.mas_top).offset(25);
            make.left.mas_equalTo(55);

        }];

        [pointsImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.centerY.mas_equalTo(pointsLabel);
            make.right.mas_equalTo(-55);
        }];
    }

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

- (void)doneButtonClick
{
    
    if (self.pageType ==ResultPageTypeSubmitHousePayResult) { //返回房租缴纳页面待支付订单页
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[BreakContractBillViewController class]]) {
                break;
            }
        }
        [navc setViewControllers:viewControllers];
    }else if (self.pageType ==ResultPageTypeMeetingResult)  //返回会议室详情页
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
        
    }else if (self.pageType == ResultPageTypeSubmitPlayTogether)//一起玩儿
    {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 3]animated:YES];
        
   }else if (self.pageType == ResultPageTypeSubmitPlayTogether  || self.pageType == ResultPageTypeIndustryFinancialResult || self.pageType == ResultPageTypeSubmitNetmanagerResult || self.pageType == ResultPageTypeSubmitOfficeResult || self.pageType == ResultPageTypeSubmitPurchsePayResult)
   {
       NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
       
   }else if(self.pageType == ResultPageTypeNetVIPOfflinePayResult || self.pageType == ResultPageTypeNetVIPPayResult)
   {
       NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 3]animated:YES];
   }else
   {
       NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
       [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
   }
    
    
}

-(void)back
{
    if (self.pageType ==ResultPageTypeSubmitHousePayResult) { //返回房租缴纳页面待支付订单页
        UINavigationController *navc = self.navigationController;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        for (UIViewController *vc in [navc viewControllers]) {
            [viewControllers addObject:vc];
            if ([vc isKindOfClass:[BreakContractBillViewController class]]) {
                break;
            }
        }
        [navc setViewControllers:viewControllers];
    }else if (self.pageType ==ResultPageTypeMeetingResult)  //返回会议室详情页
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
        
    }else if (self.pageType == ResultPageTypeSubmitPlayTogether)//一起玩儿
    {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 3]animated:YES];
        
    }else if (self.pageType == ResultPageTypeSubmitPlayTogether  || self.pageType == ResultPageTypeIndustryFinancialResult || self.pageType == ResultPageTypeSubmitNetmanagerResult || self.pageType == ResultPageTypeSubmitOfficeResult || self.pageType == ResultPageTypeSubmitPurchsePayResult)
    {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
        
    }else if(self.pageType == ResultPageTypeNetVIPOfflinePayResult)
    {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 3]animated:YES];
    }else
    {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
