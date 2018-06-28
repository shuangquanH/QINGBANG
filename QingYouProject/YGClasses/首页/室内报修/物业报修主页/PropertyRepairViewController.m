//
//  PropertyRepairViewController.m
//  QingYouProject
//
//  Created by LDSmallCat on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PropertyRepairViewController.h"
#import "PropertyRepairView.h"
#import "ServiceIntroductionViewController.h"//维修服务介绍
#import "IndoorMaintenanceViewController.h"//室内维修
#import "MyComplaintsViewController.h"//我的投诉
#import "OrderListBaseViewController.h"//我的工单
#import "RepairOrderViewController.h"

@interface PropertyRepairViewController ()<SDCycleScrollViewDelegate>
/** 背景ScrollowView  */
@property (nonatomic,strong) UIScrollView * backScrollowView;
/** 轮播图  */
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
/** PropertyRepairView  */
@property (nonatomic,strong) PropertyRepairView * propertyRepairView0;
/** PropertyRepairView  */
@property (nonatomic,strong) PropertyRepairView * propertyRepairView1;
/** PropertyRepairView  */
@property (nonatomic,strong) PropertyRepairView * propertyRepairView2;
/** PropertyRepairView  */
@property (nonatomic,strong) PropertyRepairView * propertyRepairView3;

@property (nonatomic,strong) UIButton * button0;
@property (nonatomic,strong) UIButton * button1;
@property (nonatomic,strong) UIButton * button2;
@property (nonatomic,strong) UIButton * button3;

@end

@implementation PropertyRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    self.naviTitle = @"室内报修";
    
    //设置UI视图
    [self setupUI];
    
    //网络请求
    [self sendRequest];
    
}

#pragma mark - 设置UI视图
- (void)setupUI{
    
    //背景scrollowView
    UIScrollView * backScrollowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - YGNaviBarHeight - YGStatusBarHeight)];
    backScrollowView.backgroundColor = kWhiteColor;
    [self.view addSubview:backScrollowView];
    self.backScrollowView = backScrollowView;
    //容器视图
    UIView * container = [[UIView alloc] init];
    container.backgroundColor = colorWithTable;
    
    [self.backScrollowView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.left.right.offset(0);
        make.width.equalTo(backScrollowView);
        
    }];
    
    
    //顶部试图
    UIView * headerView = [UIView new];
    [container addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.left.offset(0);
        make.height.offset(kScreenW  / (35 / 17));
    }];
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -1, kScreenW, kScreenW  / (35 / 17)) delegate:self placeholderImage:YGDefaultImgTwo_One];
    
    _cycleScrollView.autoScrollTimeInterval = 3;
    [headerView addSubview:self.cycleScrollView];
    
    
    //底部四个视图
//    CGFloat propertyRepairViewY = kScreenW  / (35 / 17);
    //正常3个视图的 高度
//    CGFloat propertyRepairViewY = (kScreenH - YGNaviBarHeight - YGStatusBarHeight - kScreenW  / (35 / 17) - 4*LDHPadding  - 20 )/3;
   
//    CGFloat propertyRepairViewY = (kScreenH - YGNaviBarHeight - YGStatusBarHeight - kScreenW  / (35 / 17) - 4*LDHPadding  - 20 )/4;
    CGFloat propertyRepairViewY = 0;
    
    self.propertyRepairView0 = [[PropertyRepairView alloc] initWithFrame:CGRectMake(LDHPadding, self.cycleScrollView.height +  LDHPadding , kScreenW - 2*LDHPadding ,propertyRepairViewY)];
    self.button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button0.tag = 0;
    self.button0.frame = self.propertyRepairView0.bounds;
    [self.button0 addTarget:self action:@selector(whichButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.propertyRepairView0 addSubview:self.button0];
    
    self.propertyRepairView1 = [[PropertyRepairView alloc] initWithFrame:CGRectMake(LDHPadding, propertyRepairViewY + self.cycleScrollView.height +  LDHPadding *2, kScreenW - 2*LDHPadding,propertyRepairViewY)];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button1.tag = 1;
    self.button1.frame = self.propertyRepairView1.bounds;
    [self.button1 addTarget:self action:@selector(whichButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.propertyRepairView1 addSubview:self.button1];

    self.propertyRepairView2 =  [[PropertyRepairView alloc] initWithFrame:CGRectMake(LDHPadding, propertyRepairViewY *2 + self.cycleScrollView.height +  LDHPadding *3, kScreenW - 2*LDHPadding,propertyRepairViewY)];
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button2.tag = 2;
    self.button2.frame = self.propertyRepairView2.bounds;
    
    [self.button2 addTarget:self action:@selector(whichButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.propertyRepairView2 addSubview:self.button2];
    
    //测试4个视图高度
    self.propertyRepairView3 = [[PropertyRepairView alloc] initWithFrame:CGRectMake(LDHPadding, propertyRepairViewY *3 + self.cycleScrollView.height +  LDHPadding *4, kScreenW - 2*LDHPadding,propertyRepairViewY)];

    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button3.tag = 3;
    self.button3.frame = self.propertyRepairView3.bounds;
    [self.button3 addTarget:self action:@selector(whichButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.propertyRepairView3 addSubview:self.button3];
    
    
    [container addSubview:self.propertyRepairView0];
    [container addSubview:self.propertyRepairView1];
    [container addSubview:self.propertyRepairView2];
    [container addSubview:self.propertyRepairView3];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.propertyRepairView3.mas_bottom).offset(0);
//        make.bottom.equalTo(self.propertyRepairView2.mas_bottom).offset(0);
        make.height.offset(kScreenH- YGNaviBarHeight - YGStatusBarHeight);
    }];
    
    [self.propertyRepairView0 reloadDataWithImage:@"steward_repairs_indoor_maintenance" andTitle:@"室内维修"];
    [self.propertyRepairView1 reloadDataWithImage:@"steward_repairs_complaints" andTitle:@"我的投诉"];
    [self.propertyRepairView2 reloadDataWithImage:@"steward_repairs_service" andTitle:@"维修服务介绍"];
    [self.propertyRepairView3 reloadDataWithImage:@"steward_repairs_order" andTitle:@"我的工单"];
    
}
#pragma mark - 网络请求
- (void)sendRequest{
    
    [YGNetService YGPOST:@"IndoorPicture" parameters:@{@"commenId":YGSingletonMarco.user.userId} showLoadingView:NO scrollView:nil success:^(id responseObject) {
        
        NSString *  type = responseObject[@"type"];
        NSMutableArray * pictureArry = [NSMutableArray new];
        [pictureArry addObject:responseObject[@"indoorPicture"][@"picture"]];
        
        self.cycleScrollView.imageURLStringsGroup = pictureArry;
        CGFloat propertyRepairViewY = (kScreenH - YGNaviBarHeight - YGStatusBarHeight - kScreenW  / (35 / 17) - 4*LDHPadding  - 20 )/3;

        if([type isEqualToString:@"2"])
        {
            //-----我的工单
            self.propertyRepairView3.frame = CGRectMake(LDHPadding, self.cycleScrollView.height +  LDHPadding, kScreenW - 2*LDHPadding ,propertyRepairViewY);
            self.button3.frame = self.propertyRepairView3.bounds;
            
            self.propertyRepairView0.hidden =YES;
            self.propertyRepairView1.hidden =YES;
            self.propertyRepairView2.hidden =YES;
        }
        else
        {
            self.propertyRepairView0.frame = CGRectMake(LDHPadding, self.cycleScrollView.height +  LDHPadding, kScreenW - 2*LDHPadding ,propertyRepairViewY);
            self.button0.frame = self.propertyRepairView0.bounds;
            self.propertyRepairView1.frame = CGRectMake(LDHPadding, propertyRepairViewY + self.cycleScrollView.height +  LDHPadding *2, kScreenW - 2*LDHPadding,propertyRepairViewY);
            self.button1.frame = self.propertyRepairView1.bounds;
            
            self.propertyRepairView2.frame = CGRectMake(LDHPadding, propertyRepairViewY *2 + self.cycleScrollView.height +  LDHPadding *3, kScreenW - 2*LDHPadding,propertyRepairViewY);
            self.button2.frame = self.propertyRepairView2.bounds;
            self.propertyRepairView3.hidden = YES;
        }

    } failure:^(NSError *error) {
        
        LDLog(@"%@",error);
    }];
}
#pragma mark - 底部按钮点击事件
- (void)whichButtonClick:(UIButton *)whichButton{
    
    switch (whichButton.tag) {
        case 0:
            {
                IndoorMaintenanceViewController * vc = [[IndoorMaintenanceViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            break;
        case 1:
        {
            MyComplaintsViewController *controller =[[MyComplaintsViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:
        {
            ServiceIntroductionViewController * vc = [[ServiceIntroductionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            OrderListBaseViewController * vc = [[OrderListBaseViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];            
        }
            break;
    }
    
}
#pragma mark - 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    [YGAppTool showToastWithText:[NSString stringWithFormat:@"点击了第%ld张图片",index]];
    
}

@end
