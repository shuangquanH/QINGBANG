//
//  SQConfirmDecorationOrderVC.m
//  QingYouProject
//
//  Created by qwuser on 2018/5/25.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQConfirmDecorationOrderVC.h"
#import "SQDecorationAddressModel.h"

#import "SQChooseDecorationAddressView.h"
#import "SQConfirmDecorationCell.h"


@interface SQConfirmDecorationOrderVC () <decorationAddressTapDelegate>

@property (nonatomic, strong) UIScrollView                  *backScrollView;
@property (nonatomic, strong) UILabel                        *bottomPayView;



@property (nonatomic, strong) SQDecorationAddressModel      *addressModel;

@property (nonatomic, strong) SQChooseDecorationAddressView       *chooseAddressView;


@end

@implementation SQConfirmDecorationOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
}

- (void)requestData {
    //获取用户地址
    NSDictionary    *param = @{@"userId":YGSingletonMarco.user.userId,@"type":@"0", @"total":@"0",@"count":@"1"};
    [YGNetService YGPOST:REQUEST_AddressList parameters:param showLoadingView:nil scrollView:nil success:^(id responseObject) {
        NSArray *addresslist = [NSArray arrayWithArray:responseObject[@"addressList"]];
        self.addressModel = [SQDecorationAddressModel yy_modelWithDictionary:addresslist.firstObject];
    } failure: nil];
    
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
    
    /** 选择地址  */
    self.chooseAddressView = [[SQChooseDecorationAddressView alloc] init];
    self.chooseAddressView.delegate = self;
    [contentView addSubview:self.chooseAddressView];
    [self.chooseAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(contentView);
    }];
    
    
    /** 订单cell  */
    SQConfirmDecorationCell   *orderCell = [[SQConfirmDecorationCell alloc] init];
    orderCell.backgroundColor = kWhiteColor;
    [contentView addSubview:orderCell];
    [orderCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.chooseAddressView);
        make.top.equalTo(self.chooseAddressView.mas_bottom).offset(KSCAL(20));
    }];
    
    
    /** 支付方式  */
    UILabel *payLabel = [[UILabel alloc] init];
    payLabel.text = @"支付方式";
    [contentView addSubview:payLabel];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.top.equalTo(orderCell.mas_bottom).offset(KSCAL(20));
        make.height.mas_equalTo(KSCAL(88));
    }];
    
    SQConfirmDecorationPayLabel *payTypeLabel = [[SQConfirmDecorationPayLabel alloc] init];
    [contentView addSubview:payTypeLabel];
    [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(payLabel.mas_bottom);
        make.bottom.mas_equalTo(contentView);
    }];
    
}

- (void)tapedAddressWithType:(BOOL)hadAddress {
    if (hadAddress) {
        //跳转到修改地址
    } else {
        //跳转到新建地址
    }
}



- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        CGRect frame =CGRectMake(0, 0, KAPP_WIDTH, KAPP_HEIGHT-KNAV_HEIGHT-60);
        _backScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _backScrollView.backgroundColor = self.view.backgroundColor;
    }
    return _backScrollView;
}

- (UILabel   *)bottomPayView {
    if (!_bottomPayView) {
        _bottomPayView = [[UILabel alloc] initWithFrame:CGRectMake(0, KAPP_HEIGHT-KNAV_HEIGHT-60, KAPP_WIDTH, 60)];
        _bottomPayView.backgroundColor = colorWithMainColor;
        _bottomPayView.text = @"提交订单";
        _bottomPayView.textColor = kWhiteColor;
        _bottomPayView.textAlignment = NSTextAlignmentCenter;
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
