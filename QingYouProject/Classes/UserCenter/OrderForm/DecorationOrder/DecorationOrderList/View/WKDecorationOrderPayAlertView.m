//
//  WKDecorationOrderPayAlertView.m
//  QingYouProject
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKDecorationOrderPayAlertView.h"

#import "WKAnimationAlert.h"

#import "WKDecorationOrderDetailModel.h"
#import "UILabel+SQAttribut.h"
#import "UIButton+WKTouchEdges.h"

@interface WKDecorationOrderPayAlertView()

@end

@implementation WKDecorationOrderPayAlertView
{
    
    UIButton *_confirmPayButton;
    UIButton *_dismissButton;

    UIView   *_headerView;
    UILabel  *_tipLabel;
    UIButton *_aliSelectBtn;
    UIButton *_wechatSelectBtn;
    
    
    NSInteger _selectType;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    CGRect instanceFrame = CGRectMake(0, 0, KSCAL(690), KSCAL(590));
    
    if (self == [super initWithFrame:instanceFrame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8.0;
        _selectType = -1;
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = kCOLOR_RGB(152, 153, 154);
    [self addSubview:_headerView];
    
    UILabel *headerTipLab = [UILabel labelWithFont:KSCAL(38) textColor:[UIColor whiteColor] text:@"确认支付"];
    [_headerView addSubview:headerTipLab];
    
    _dismissButton = [UIButton new];
    [_dismissButton setImage:[UIImage imageNamed:@"alert_dismiss_btn"] forState:UIControlStateNormal];
    [_dismissButton addTarget:self action:@selector(click_dismissButton) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_dismissButton];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(KSCAL(70));
    }];
    [headerTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    
    [_dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-KSCAL(15));
        make.width.height.mas_equalTo(KSCAL(50));
    }];
    
    _tipLabel = [UILabel labelWithFont:KSCAL(38) textColor:kCOLOR_333 textAlignment:NSTextAlignmentCenter text:@"支付方式"];
    [self addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_headerView.mas_bottom);
        make.height.mas_equalTo(KSCAL(115));
    }];
    
    UIView *line = [self createLine];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(KSCAL(20));
        make.top.equalTo(_tipLabel.mas_bottom);
        make.centerX.mas_equalTo(0);
    }];
    
    UIView *aliPayView = [self createPayTypeViewWithTitle:@"支付宝支付" payType:WKDecorationPayTypeAliPay];
    [self addSubview:aliPayView];
    [aliPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KSCAL(89));
        make.top.equalTo(line.mas_bottom);
        make.left.centerX.mas_equalTo(0);
    }];
    
    UIView *wechatPayView = [self createPayTypeViewWithTitle:@"微信支付" payType:WKDecorationPayTypeWechatPay];
    [self addSubview:wechatPayView];
    [wechatPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KSCAL(89));
        make.top.equalTo(aliPayView.mas_bottom);
        make.left.centerX.mas_equalTo(0);
    }];
    
    _confirmPayButton = [UIButton buttonWithTitle:@"去付款" titleFont:KSCAL(38) titleColor:[UIColor whiteColor] bgColor:KCOLOR_MAIN];
    _confirmPayButton.layer.cornerRadius = 8.0;
    [_confirmPayButton addTarget:self action:@selector(click_confirmButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirmPayButton];
    [_confirmPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KSCAL(315), KSCAL(98)));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-KSCAL(47));
    }];
}

- (UIView *)createPayTypeViewWithTitle:(NSString *)title payType:(WKDecorationPayType)payType {
    
    UIView *view = [UIView new];
    
    UILabel *lable = [UILabel labelWithFont:KSCAL(28) textColor:kCOLOR_666 text:title];
    [view addSubview:lable];
    
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"order_list_btn1"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"order_list_btn1"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(click_selectButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    button.tag = payType;
    [view addSubview:button];
    if (payType == WKDecorationPayTypeAliPay) {
        _aliSelectBtn = button;
    }
    else {
        _wechatSelectBtn = button;
    }
    
    UIView *line = [self createLine];
    [view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(20));
        make.centerX.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(line);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(line);
        make.width.height.mas_equalTo(KSCAL(35));
    }];
    
    return view;
}

- (UIView *)createLine {
    UIView *line = [UIView new];
    line.backgroundColor = KCOLOR_LINE;
    return line;
}

- (void)click_selectButton:(UIButton *)sender {
    if (_selectType == sender.tag) return;
    
    [sender setImage:[UIImage imageNamed:@"order_list_btn_down"] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"order_list_btn_down"] forState:UIControlStateHighlighted];

    if (sender.tag == WKDecorationPayTypeAliPay) {
        [_wechatSelectBtn setImage:[UIImage imageNamed:@"order_list_btn1"] forState:UIControlStateNormal];
        [_wechatSelectBtn setImage:[UIImage imageNamed:@"order_list_btn1"] forState:UIControlStateHighlighted];

    }
    else if (sender.tag == WKDecorationPayTypeWechatPay) {
        [_aliSelectBtn setImage:[UIImage imageNamed:@"order_list_btn1"] forState:UIControlStateNormal];
        [_aliSelectBtn setImage:[UIImage imageNamed:@"order_list_btn1"] forState:UIControlStateHighlighted];

    }
    
    _selectType = sender.tag;
    
}

- (void)click_confirmButton {
    
    if (_selectType < 0) {
        [YGAppTool showToastWithText:@"请选择支付方式"];
        return;
    }
    
    if (self.paymentAction) {
        self.paymentAction(_selectType);
    }
    [self dismissPaymentView];
}

- (void)click_dismissButton {
    [self dismissPaymentView];
}
- (void)showPaymentViewInSuperView:(UIView *)superView {
    [WKAnimationAlert showAlertWithInsideView:self animation:WKAlertAnimationTypeCenter canTouchDissmiss:NO];
}
- (void)dismissPaymentView {
    [WKAnimationAlert dismiss];
}

@end
