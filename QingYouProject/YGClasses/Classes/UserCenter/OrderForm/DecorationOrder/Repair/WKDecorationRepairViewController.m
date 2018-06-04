//
//  WKDecorationRepairViewController.m
//  QingYouProject
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationRepairViewController.h"

@interface WKDecorationRepairViewController ()

@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation WKDecorationRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviTitle = @"我要补登";
}

- (void)setupSubviews {
    _confirmButton = [UIButton new];
    [_confirmButton setBackgroundColor:[UIColor redColor]];
    [_confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_confirmButton];
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
}

@end
