//
//  SQPaySuccessfulVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQPaySuccessfulVC.h"
#import "SQDecorationOrderVC.h"

@interface SQPaySuccessfulVC ()

@end

@implementation SQPaySuccessfulVC {
    UILabel *titel;
    UILabel *descLabel;
    UILabel *timeLabel;
    UIButton *centerImage;
    UIButton    *leftButton;
    UIButton    *rightButton;
}

- (void)configAttribute {
    self.naviTitle =  @"付款提示";
    UIBarButtonItem *item = [self createBarbuttonWithNormalImageName:@"paymentsuccess_nav_colse_icon" selectedImageName:nil selector:@selector(closeSelf)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)closeSelf {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KCOLOR_WHITE;
    
    titel = [[UILabel alloc] init];
    [self.view addSubview:titel];
    titel.font = KFONT(42);
    titel.textColor = kCOLOR_333;
    
    descLabel = [[UILabel alloc] init];
    [self.view addSubview:descLabel];
    descLabel.font = KFONT(28);
    descLabel.textColor = kCOLOR_333;
    
    timeLabel = [[UILabel alloc] init];
    [self.view addSubview:timeLabel];
    timeLabel.font = KFONT(28);
    timeLabel.textColor = kCOLOR_333;
    
    centerImage = [UIButton buttonWithType:UIButtonTypeCustom];
    centerImage.titleLabel.font = KFONT(32);
    [self.view addSubview:centerImage];
    centerImage.layer.cornerRadius = KSCAL(100);
    centerImage.layer.masksToBounds = YES;
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.titleLabel.font = KFONT(38);
    [self.view addSubview:leftButton];
    leftButton.backgroundColor = KCOLOR_MAIN;
    leftButton.layer.cornerRadius = KSCAL(20);
    
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = KFONT(38);
    [self.view addSubview:rightButton];
    rightButton.backgroundColor = KCOLOR_MAIN;
    rightButton.layer.cornerRadius = KSCAL(20);
    
    
    if (self.type==SQDecorationBookSuccess) {
        [self SQDecorationBookSuccessType];
    }
    
}

- (void)SQDecorationBookSuccessType {
    
    titel.text = @"恭喜您,预约成功!";
    descLabel.text = @"青邦将会在1小时内联系您沟通装修事宜!";
    timeLabel.text = @"(工作时间9:00---18:00)";
    [centerImage setImage:[UIImage imageNamed:@"paymentsuccess_tel_icon"] forState:UIControlStateNormal];
    
    
    [leftButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [rightButton setTitle:@"我的订单" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backHomePage) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(gotoMyOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [titel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KSCAL(300));
        make.centerX.equalTo(self.view);
    }];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titel.mas_bottom).offset(KSCAL(35));
        make.centerX.equalTo(self.view);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(KSCAL(23));
        make.centerX.equalTo(self.view);
    }];
    [centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(KSCAL(67));
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(KSCAL(200));
    }];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(65));
        make.top.equalTo(centerImage.mas_bottom).offset(KSCAL(100));
        make.height.mas_equalTo(KSCAL(98));
        make.width.mas_equalTo(KSCAL(300));
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-KSCAL(65));
        make.top.equalTo(centerImage.mas_bottom).offset(KSCAL(100));
        make.height.mas_equalTo(KSCAL(98));
        make.width.mas_equalTo(KSCAL(300));
    }];
}

/** 返回首页  */
- (void)backHomePage {
    if (self.lastNav) {
        [self.lastNav popToRootViewControllerAnimated:YES];
        [self closeSelf];
    }
}
/** 去我的装修订单  */
- (void)gotoMyOrder {
    if (self.lastNav) {
        [self.lastNav popToRootViewControllerAnimated:YES];
        SQDecorationOrderVC *vc = [[SQDecorationOrderVC alloc] init];
        [self.lastNav pushViewController:vc animated:YES];
        [self closeSelf];
    }
}




@end
