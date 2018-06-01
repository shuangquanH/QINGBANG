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

@end

@implementation SQApplyAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNavigation];
}

- (void)layoutNavigation {
    self.naviTitle = @"申请售后";
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(click_listButton) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"售后记录" forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}

- (void)click_listButton {
    SQAfterSaleListViewController *next = [SQAfterSaleListViewController new];
    [self.navigationController pushViewController:next animated:YES];
}


@end
