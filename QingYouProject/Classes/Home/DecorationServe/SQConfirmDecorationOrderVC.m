//
//  SQConfirmDecorationOrderVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQConfirmDecorationOrderVC.h"
#import "SQDecorationOrderCell.h"


@interface SQConfirmDecorationOrderVC ()

@property (nonatomic, strong) UIScrollView    *backScrollView;
@property (nonatomic, strong) UIView       *bottomPayView;

@end

@implementation SQConfirmDecorationOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)configAttribute {
    self.naviTitle = @"确认订单";
    [self.view addSubview:self.backScrollView];
    [self.view addSubview:self.bottomPayView];
    
    
    UIView  *contentView = [[UIView alloc] init];
    [self.backScrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backScrollView);
        make.width.equalTo(self.backScrollView);
    }];
    
    UIView  *addressView = [[UIView alloc] init];
    addressView.backgroundColor = kGrayColor;
    [contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(contentView);
        make.height.mas_equalTo(100);
    }];
    
    SQDecorationOrderCellWithThreeStage   *orderCell = [[SQDecorationOrderCellWithThreeStage alloc] init];
    orderCell.model = @"dd";
    [contentView addSubview:orderCell];
    [orderCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(addressView);
        make.top.equalTo(addressView.mas_bottom);
    }];
    
    UITextView  *textView = [[UITextView alloc] init];
    textView.text = @"备注留言:";
    [contentView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(addressView);
        make.top.equalTo(orderCell.mas_bottom);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"共计:100000(不含定金)";
    [contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(textView.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
    UILabel *payLabel = [[UILabel alloc] init];
    payLabel.text = @"支付方式";
    [contentView addSubview:payLabel];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(priceLabel.mas_bottom);
        make.height.mas_equalTo(200);
        make.bottom.equalTo(contentView);
    }];
    
    
    
    
}



- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        CGRect frame =CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT-60);
        _backScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _backScrollView.backgroundColor = self.view.backgroundColor;
    }
    return _backScrollView;
}

- (UIView   *)bottomPayView {
    if (!_bottomPayView) {
        _bottomPayView = [[UIView alloc] initWithFrame:CGRectMake(0, KAPP_HEIGHT-KNAV_HEIGHT-60, KAPP_WIDTH, 60)];
        _bottomPayView.backgroundColor = colorWithMainColor;
    }
    return _bottomPayView;
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
