//
//  HouseRentAuditViewController.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "HouseRentAuditViewController.h"

@interface HouseRentAuditViewController ()

@end

@implementation HouseRentAuditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    // Do any additional setup after loading the view.
    self.naviTitle = @"企业认证";
    //热门推荐label
   UILabel  *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = colorWithBlack;
    titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    titleLabel.text = @"您的申请正在审核中，请稍后再试";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake( 10, 100,YGScreenWidth-20, 20);
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
}
- (void)back
{
   if([self.houseRentHomeOrCertifyPage isEqualToString:@"certifyPage"])//认证页跳的返前两页  //网络管家跳认证状态页 返上两页
    {
        NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2]animated:YES];
    }else//网络管家认证也跳返网络管家
    {
        [self.navigationController popViewControllerAnimated:YES];

    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
