//
//  SecondPaySuccessViewController.m
//  QingYouProject
//
//  Created by zhaoao on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SecondPaySuccessViewController.h"
#import "BabyDetailsController.h"

@interface SecondPaySuccessViewController ()

@end

@implementation SecondPaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"支付成功";
    //关闭侧滑
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
    [bottomLabel addAttributedWithString:@"您已支付成功" lineSpace:8];
    //    bottomLabel.text = bottomString;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.numberOfLines = 0;
    [baseTopView addSubview:bottomLabel];
    
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
    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
//    UINavigationController *navc = self.navigationController;
//    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
//    for (UIViewController *vc in [navc viewControllers]) {
//        [viewControllers addObject:vc];
//        if ([vc isKindOfClass:[BabyDetailsController class]]) {
//            break;
//        }
//    }
//    [navc setViewControllers:viewControllers];
}
-(void)back
{
    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
