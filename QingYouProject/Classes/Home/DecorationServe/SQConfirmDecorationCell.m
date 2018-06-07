//
//  SQConfirmDecorationCell.m
//  QingYouProject
//
//  Created by qwuser on 2018/6/6.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQConfirmDecorationCell.h"

#define KSPACE 20

@implementation SQConfirmDecorationCell {
    UIImageView *orderImage;
    UILabel *orderTitle;
    UILabel *orderDesc;
    UILabel *orderPrice;
    
    UILabel *payForPrice;//定金
    UITextField  *beizhuTextView;//备注
    UILabel *totalPrice;//共计
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        orderImage = [[UIImageView alloc] init];
        orderImage.backgroundColor = [UIColor orangeColor];
        orderImage.contentMode = UIViewContentModeScaleAspectFill;
        orderImage.clipsToBounds = YES;
        [self addSubview:orderImage];
        
        orderTitle = [[UILabel alloc] init];
        orderTitle.font = KFONT(28.0);
        orderTitle.textColor = KCOLOR(@"666666");
        orderTitle.numberOfLines = 2;
        [self addSubview:orderTitle];
        orderTitle.text = @"产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称产品名称";
        
        orderDesc = [[UILabel alloc] init];
        orderDesc.font = KFONT(28.0);
        orderDesc.textColor = KCOLOR(@"666666");
        orderDesc.numberOfLines = 1;
        [self addSubview:orderDesc];
        orderDesc.text = @"属性名属性名属性名属性名属性名属性名属性名";
        
        orderPrice = [[UILabel alloc] init];
        orderPrice.font = KFONT(28.0);
        orderPrice.textColor = KCOLOR(@"333333");
        [self addSubview:orderPrice];
        orderPrice.text = @"10000元(预估价)";
        
        
        UIImageView *topLine = [[UIImageView alloc] init];
        topLine.image = [UIImage imageNamed:@"order_lis_line"];
        topLine.backgroundColor = kGrayColor;
        [self addSubview:topLine];
        
        payForPrice = [[UILabel alloc] init];
        [self addSubview:payForPrice];
        payForPrice.text = @"定金:10元";
        payForPrice.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *centerLine = [[UIImageView alloc] init];
        centerLine.image = [UIImage imageNamed:@"order_lis_line"];
        centerLine.backgroundColor = kGrayColor;
        [self addSubview:centerLine];
        
        
        UILabel *beizhuLabel = [[UILabel alloc] init];
        [self addSubview:beizhuLabel];
        beizhuLabel.text = @"备注留言:";
        beizhuLabel.font = KFONT(28);
        beizhuLabel.textColor = kGrayColor;
        
        
        beizhuTextView = [[UITextField alloc] init];
        beizhuTextView.font = KFONT(28);
        beizhuTextView.placeholder = @"请输入留言,不超过200字";
        [self addSubview:beizhuTextView];
        
        UIImageView *bottomLine = [[UIImageView alloc] init];
        bottomLine.image = [UIImage imageNamed:@"order_lis_line"];
        bottomLine.backgroundColor = kGrayColor;
        [self addSubview:bottomLine];
        
        
        totalPrice  = [[UILabel alloc] init];
        totalPrice.textAlignment = NSTextAlignmentCenter;
        [self addSubview:totalPrice];
        totalPrice.text = @"共计:10元";
        
        
        
        //图片
        [orderImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.top.equalTo(self).offset(KSPACE);
            make.width.mas_equalTo(KSCAL(240));
            make.height.mas_equalTo(KSCAL(180));
        }];
        
        //标题
        [orderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orderImage.mas_right).offset(KSCAL(KSPACE));
            make.top.equalTo(orderImage);
            make.right.equalTo(self).offset(-KSCAL(30));
        }];
        
        //描述
        [orderDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(orderTitle);
            make.top.equalTo(orderTitle.mas_baseline).offset(KSCAL(KSPACE));
        }];
        
        //价格
        [orderPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(orderTitle);
            make.bottom.equalTo(orderImage.mas_bottom);
        }];
        
        //线1
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.right.equalTo(self).offset(-KSPACE);
            make.top.equalTo(orderImage.mas_bottom).offset(KSPACE);
        }];
        
        //定金
        [payForPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(topLine);
            make.top.equalTo(topLine.mas_bottom);
            make.height.mas_equalTo(KSCAL(88));
        }];
        
        //线2
        [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.right.equalTo(self).offset(-KSPACE);
            make.top.equalTo(payForPrice.mas_bottom);
        }];
        
        //备注留言label
        [beizhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.top.equalTo(centerLine.mas_bottom);
            make.height.mas_equalTo(KSCAL(88));
        }];
        
        //备注留言textview
        [beizhuTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(beizhuLabel);
            make.left.equalTo(beizhuLabel.mas_right).offset(5);
            make.right.equalTo(self).offset(-KSPACE);
        }];

        //线3
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(KSPACE);
            make.right.equalTo(self).offset(-KSPACE);
            make.top.equalTo(beizhuLabel.mas_bottom);
        }];
        
        //共计价格
        [totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(bottomLine.mas_bottom);
            make.height.mas_equalTo(KSCAL(88));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
    }
    return self;
}


- (NSString *)leaveMessageStr {
    return beizhuTextView.text;
}

@end


@implementation SQConfirmDecorationPayLabel {
    
    UIButton    *zfbBtn;
    UIButton    *wxBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kWhiteColor;
        
        
        UILabel *zhifubao = [[UILabel alloc] init];
        [self configureLabel:zhifubao];
        [self addSubview:zhifubao];
        zhifubao.text = @"支付宝支付";
        
        UIImageView  *topLine = [[UIImageView alloc] init];
        topLine.image =  [UIImage imageNamed:@"order_lis_line"];
        [self addSubview:topLine];
        
        
        zfbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [zfbBtn setImage:[UIImage imageNamed:@"order_list_btn1"] forState:UIControlStateNormal];
        [zfbBtn setImage:[UIImage imageNamed:@"order_list_btn_down"] forState:UIControlStateSelected];
        [self addSubview:zfbBtn];
        

        [zhifubao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(KSPACE);
            make.height.mas_equalTo(KSCAL(88));
        }];

        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KSPACE);
            make.top.equalTo(zhifubao.mas_bottom);
            make.right.equalTo(self).offset(-KSPACE);
        }];

        [zfbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-KSPACE);
            make.centerY.equalTo(zhifubao);
            make.width.height.mas_equalTo(KSCAL(28));
        }];
        
        
        
        
        UILabel *weixin = [[UILabel alloc] init];
        [self configureLabel:weixin];
        [self addSubview:weixin];
        weixin.text = @"微信支付";
        
        UIImageView  *bottomLine = [[UIImageView alloc] init];
        bottomLine.image = [UIImage imageNamed:@"order_lis_line"];
        [self addSubview:bottomLine];
        
        wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [wxBtn setImage:[UIImage imageNamed:@"order_list_btn1"] forState:UIControlStateNormal];
        [wxBtn setImage:[UIImage imageNamed:@"order_list_btn_down"] forState:UIControlStateSelected];
        [self addSubview:wxBtn];
        
        
        
        [weixin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(zhifubao.mas_bottom);
            make.left.mas_equalTo(KSPACE);
            make.height.mas_equalTo(KSCAL(88));
        }];
        
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KSPACE);
            make.top.equalTo(weixin.mas_bottom);
            make.right.equalTo(self).offset(-KSPACE);
        }];
        
        [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-KSPACE);
            make.centerY.equalTo(weixin);
            make.width.height.mas_equalTo(KSCAL(28));
        }];
        
        
        
        
        
        UILabel *zhifudingjin = [[UILabel alloc] init];
        [self configureLabel:zhifudingjin];
        [self addSubview:zhifudingjin];
        zhifudingjin.text = @"支付定金:10元";
        
        [zhifudingjin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weixin.mas_bottom);
            make.left.mas_equalTo(KSPACE);
            make.height.mas_equalTo(KSCAL(88));
            make.bottom.equalTo(self);
        }];
        
        [zfbBtn addTarget:self action:@selector(zhifuaction) forControlEvents:UIControlEventTouchUpInside];
        [wxBtn addTarget:self action:@selector(wxaction) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    return self;
}

- (void)configureLabel:(UILabel *)label {
    label.font = KFONT(28);
    label.textColor = kCOLOR_333;
}

- (void)zhifuaction {
    wxBtn.selected = NO;
    zfbBtn.selected = YES;
}
- (void)wxaction {
    wxBtn.selected = YES;
    zfbBtn.selected = NO;
}
@end





