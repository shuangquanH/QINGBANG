//
//  SQApplyAfterSaleViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQApplyAfterSaleViewController.h"
#import "SQAfterSaleListViewController.h"

@interface SQApplyAfterSaleViewController ()

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UITextView *problemTV;

@property (nonatomic, strong) UIView *certificateView;

@end

@implementation SQApplyAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigation];
    [self setupSubviews];
}

- (void)layoutNavigation {
    self.naviTitle = @"申请售后";

    UIBarButtonItem *rightBarButton = [self createBarbuttonWithNormalTitleString:@"售后记录" selectedTitleString:@"售后记录" selector:@selector(click_listButton)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (void)setupSubviews {
    _confirmButton = [UIButton new];
    [_confirmButton setBackgroundColor:[UIColor redColor]];
    [_confirmButton setTitle:@"提交申请" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_confirmButton];
    
    _tipLabel = [UILabel labelWithFont:15.0 textColor:[UIColor blackColor] text:@"问题描述："];
    [_tipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.view addSubview:_tipLabel];
    
    _problemTV = [UITextView new];
    [self.view addSubview:_problemTV];
    
    _certificateView = [UIView new];
    _certificateView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_certificateView];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    

    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        }
        else {
            make.bottom.mas_equalTo(-self.view.layoutMargins.bottom);
        }
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [_problemTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_tipLabel.mas_right);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self->_tipLabel);
        make.height.mas_equalTo(100);
    }];
    [_certificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_problemTV.mas_bottom).offset(20);
        make.left.equalTo(self->_tipLabel);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
}

- (void)click_listButton {
    SQAfterSaleListViewController *next = [SQAfterSaleListViewController new];
    [self.navigationController pushViewController:next animated:YES];
}


@end
