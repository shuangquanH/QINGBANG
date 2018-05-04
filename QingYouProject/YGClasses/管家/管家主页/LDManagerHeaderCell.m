//
//  LDManagerHeaderCell.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/9/13.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "LDManagerHeaderCell.h"
#import "LDVerticalButton.h"//图片 在上 文字在下
#import "LDPayViewController.h"//管家 : 立即申请
#import "AddressAskViewController.h"//立即申请
#import "MeetingAreaChooseViewController.h"//会议室预订
#import "TakePicturesEasyController.h"//随手拍
#import "OfficePurchaseOrderListViewController.h"


#import "FundSupportViewController.h"
#import "PayRentViewController.h"
#import "HouseRentAuditViewController.h"
#import "CheckUserInfoViewController.h"
#import "AdvertisesForViewController.h"
#import "UpLoadIDFatherViewController.h"

#import "LoginViewController.h"
#import "MineIntergralViewController.h"

@interface LDManagerHeaderCell ()

/** 数据源  */
@property (nonatomic,strong) NSArray * nameArray;

@end

@implementation LDManagerHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        [self addSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
- (void)addSubviews{
    //背景View
    UIView * backView = [UIView new];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10);
        make.right.bottom.offset(-10);
    }];
    //Button子试图
    self.nameArray = @[
                                @{@"title":@"预定会议室",@"image":@"steward_bookameetingroom"},
                                @{@"title":@"人才招聘",@"image":@"steward_talentrecruitment"},
                                @{@"title":@"随手拍",@"image":@"steward_takephoto"},
                                @{@"title":@"房租缴纳",@"image":@"steward_paytherent"},
                                @{@"title":@"资金扶持",@"image":@"steward_thefinancialsupportof"}
                                ];
  
    CGFloat Y = 10;
    CGFloat W = (kScreenW - 20) / self.nameArray.count;
    CGFloat H = 60;
    for (int i = 0; i < self.nameArray.count ; i++) {
        
        LDVerticalButton * btn = [LDVerticalButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[self.nameArray[i] objectForKey:@"title"] forState:normal];
        [btn setImage:LDImage([self.nameArray[i] objectForKey:@"image"]) forState:normal];
        btn.frame = CGRectMake(W * i, Y, W, H);
        [backView addSubview:btn];
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.button];
    [self.button setBackgroundImage:YGDefaultImgHorizontal forState:UIControlStateNormal];

//    self.button.backgroundColor = LDRGBColor(250, 130, 100);
    self.button.layer.cornerRadius = 8;
    self.button.frame = CGRectMake(15, 95, kScreenW - 30, 60);
    [self.button addTarget:self action:@selector(giftButtonClick:) forControlEvents:UIControlEventTouchUpInside];

}

//for (int i = 0; i < self.nameArray.count ; i++) {
//    
//    LDVerticalButton * btn = [self viewWithTag:100 + i];
//    
//    [btn setTitle:[self.nameArray[i] objectForKey:@"title"] forState:normal];
//    
//    [btn setImage:LDImage([self.nameArray[i] objectForKey:@"image"]) forState:normal];
//    
//}
#pragma mark - 未知跳转页面
- (void)giftButtonClick:(UIButton *)giftButton{
    
//    NSArray * titleArray = @[@"全部",@"待付款",@"待发货",@"已发货",@"售后"];
//    NSArray * classArray = @[@"AllOfficePurchaseOrderListViewController",@"PendingPaymentOfficePurchaseViewController",@"DeliveredViewController",@"ShippedViewController",@"AfterSaleViewController"];
//    OfficePurchaseOrderListViewController * vc = [[OfficePurchaseOrderListViewController alloc] initWithTitleArray:titleArray viewControllerClassStringArray:classArray navgationTitle:@"办公采购订单"];
//    UIViewController * currentVC = [self getCellViewController];
//
//    [currentVC.navigationController pushViewController:vc animated:YES];
    //未登录
    if (![[NSFileManager defaultManager] fileExistsAtPath:USERFILEPATH])
    {
        UIViewController * currentVC = [self getCellViewController];
        LoginViewController *controller = [[LoginViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [currentVC.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    MineIntergralViewController * VC= [[MineIntergralViewController alloc] init];
    UIViewController * currentVC = [self getCellViewController];
    [currentVC.navigationController pushViewController:VC animated:YES];
}
#pragma mark - 点击事件
- (void)btnClick:(LDVerticalButton *)btn {

    //未登录
    if (![[NSFileManager defaultManager] fileExistsAtPath:USERFILEPATH])
    {
        UIViewController * currentVC = [self getCellViewController];
        LoginViewController *controller = [[LoginViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [currentVC.navigationController pushViewController:controller animated:YES];
        return;
    }
    
    NSInteger btnTag = btn.tag;
    
    switch (btnTag) {
        case 100:
        {//会议室预订
            //目标控制器
            MeetingAreaChooseViewController * vc = [[MeetingAreaChooseViewController alloc] init];
            
            
            UIViewController * currentVC = [self getCellViewController];
            
            [currentVC.navigationController pushViewController:vc animated:YES];
            
     
        }
            break;
            
        case 101:
        {
            //人才招聘主页
            AdvertisesForViewController *controller = [[AdvertisesForViewController alloc]init];

            UIViewController * currentVC = [self getCellViewController];
            
            [currentVC.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        case 102:
        {//随手拍
            
            TakePicturesEasyController * VC= [[TakePicturesEasyController alloc] init];
            UIViewController * currentVC = [self getCellViewController];
            
            [currentVC.navigationController pushViewController:VC animated:YES];
            
        }
            break;
        case 103:
        {
            UIViewController * currentVC = [self getCellViewController];
            
            //房租缴纳审核
            [YGNetService YGPOST:REQUEST_HouserAudit parameters:@{@"userid":YGSingletonMarco.user.userId} showLoadingView:YES scrollView:nil success:^(id responseObject) {
                //返回值state ==0是请提交审核材料 ==1待审核 ==2审核通过直接跳到房租缴纳首页 ==3审核不通过跳到传身份证页面并提示请重新上传资料审核
                    if ([responseObject[@"state"] isEqualToString:@"1"]) {
                        HouseRentAuditViewController *controller = [[HouseRentAuditViewController alloc]init];
                        [currentVC.navigationController pushViewController:controller animated:YES];
            
                        
                    }else if([responseObject[@"state"] isEqualToString:@"2"])
                    {
                        CheckUserInfoViewController *controller = [[CheckUserInfoViewController alloc]init];
                        [currentVC.navigationController pushViewController:controller animated:YES];
                        
                        
                    }else if ([responseObject[@"state"] isEqualToString:@"3"])
                    {
                        UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                        controller.notioceString = @"您的资料未通过审核,请重新上传资料";
                        [currentVC.navigationController pushViewController:controller animated:YES];
                    }else
                    {
                        UpLoadIDFatherViewController *controller = [[UpLoadIDFatherViewController alloc]init];
                        controller.notioceString = @"请上传资料进行审核，审核通过后可进行房租缴纳";
                        [currentVC.navigationController pushViewController:controller animated:YES];
                    }


            } failure:^(NSError *error) {
                
            }];
       
        }
            break;
        case 104:
        {//资金扶持
            UIViewController * currentVC = [self getCellViewController];

            FundSupportViewController * ntVC= [[FundSupportViewController alloc] init];
            [currentVC.navigationController pushViewController:ntVC animated:YES];
            
        }
            break;
    }

}


//网络管理服务跳转 测试 入口
//AddressAskViewController * base = [[AddressAskViewController alloc] init];
//base.pageType = AddressAskPageTypeNetManager;
//UIViewController * currentVC = [self getCellViewController];
//[currentVC.navigationController pushViewController:base animated:YES];






























@end
