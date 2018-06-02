//
//  SQChooseGardenVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/2.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQChooseGardenVC.h"
#import "UIView+SQGesture.h"

@interface SQChooseGardenVC ()

@property (nonatomic, copy) NSString       *isInGarden;

@end

@implementation SQChooseGardenVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    [self configureUI];
    
}

- (void)configureUI {
    UIButton    *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"login_Choose_park_back"] forState:UIControlStateNormal];
    [backButton setTitle:@"跳过" forState:UIControlStateNormal];
    backButton.titleLabel.font = KFONT(24);
    [backButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self.navigationController action:@selector(popToRootViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame=  CGRectMake(KAPP_WIDTH-KSCAL(80)-KSCAL(30), KSCAL(60), KSCAL(80), KSCAL(40));
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = KFONT(42);
    titleLabel.textColor = KCOLOR(@"666666");
    titleLabel.text = @"请选择企业办公地址";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KSCAL(120));
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = KFONT(32);
    descLabel.textColor = KCOLOR(@"999999");
    descLabel.text = @"青邦将更好的为您服务";
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(KSCAL(20));
        make.centerX.equalTo(titleLabel);
    }];
    
    UIImageView *topImage = [[UIImageView alloc] init];
    topImage.image = [UIImage imageNamed:@"login_Choose_park_nor_1"];

    [self.view addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(KSCAL(75));
        make.centerX.equalTo(titleLabel);
    }];
    UILabel *topTilte = [[UILabel alloc] init];
    topTilte.text = @"已入驻青网科技园";
    topTilte.font = KFONT(24);
    topTilte.textColor = KCOLOR(@"333333");
    [self.view addSubview:topTilte];
    [topTilte mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.mas_bottom).offset(KSCAL(20));
        make.centerX.equalTo(titleLabel);
    }];
    
    UILabel *topDesc = [[UILabel alloc] init];
    topDesc.text = @"汇聚青年力量,成就创业梦想.";
    topDesc.font = KFONT(24);
    topDesc.textColor = KCOLOR(@"999999");
    [self.view addSubview:topDesc];
    [topDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topTilte.mas_bottom).offset(KSCAL(20));
        make.centerX.equalTo(titleLabel);
    }];
    
    UIButton    *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterButton setBackgroundImage:[UIImage imageNamed:@"login_Choose_park_btn"] forState:UIControlStateNormal];
    [enterButton setTitle:@"进入" forState:UIControlStateNormal];
    enterButton.titleLabel.font = KFONT(32);
    enterButton.titleLabel.textColor = kWhiteColor;
    [enterButton addTarget:self action:@selector(enterButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterButton];
    
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-KSCAL(60));
        make.centerX.equalTo(titleLabel);
        make.width.mas_equalTo(KSCAL(300));
        make.height.mas_equalTo(KSCAL(70));
    }];
    
    UILabel *bottomDes = [[UILabel alloc] init];
    bottomDes.text = @"青网城邀行走在梦想路上的人,不破不立,与创业者同行......";
    bottomDes.font = KFONT(24);
    bottomDes.textColor = KCOLOR(@"999999");
    [self.view addSubview:bottomDes];
    [bottomDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(enterButton.mas_top).offset(-KSCAL(125));
        make.centerX.equalTo(titleLabel);
    }];
    
    UILabel *bottomTitle = [[UILabel alloc] init];
    bottomTitle.text = @"已入驻其他园区";
    bottomTitle.font = KFONT(24);
    bottomTitle.textColor = KCOLOR(@"333333");
    [self.view addSubview:bottomTitle];
    [bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomDes.mas_top).offset(-KSCAL(20));
        make.centerX.equalTo(titleLabel);
    }];
    
    UIImageView *bottomImage = [[UIImageView alloc] init];
    bottomImage.image = [UIImage imageNamed:@"login_Choose_park_nor_2"];

    
    [self.view addSubview:bottomImage];
    [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomTitle.mas_top).offset(-KSCAL(20));
        make.centerX.equalTo(titleLabel);
    }];
    
    
    
    enterButton.hidden = YES;
    
    topImage.userInteractionEnabled = YES;
    bottomImage.userInteractionEnabled = YES;
    
    WeakSelf(weakSelf);
    [topImage sq_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        topImage.image = [UIImage imageNamed:@"login_Choose_park_down_1"];
        bottomImage.image = [UIImage imageNamed:@"login_Choose_park_nor_2"];
        enterButton.hidden = NO;
        weakSelf.isInGarden = @"yes";
    }];
    [bottomImage sq_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        bottomImage.image = [UIImage imageNamed:@"login_Choose_park_down_2"];
        topImage.image = [UIImage imageNamed:@"login_Choose_park_nor_1"];
        enterButton.hidden = NO;
        weakSelf.isInGarden = @"no";
    }];
    
}


- (void)enterButton {
    YGSingletonMarco.user.isInGarden = self.isInGarden;
    [YGSingletonMarco archiveUser];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
