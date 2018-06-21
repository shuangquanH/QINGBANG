//
//  SQDecorationDetailAddressView.m
//  QingYouProject
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "SQDecorationDetailAddressView.h"
#import "NSString+SQStringSize.h"

@implementation SQDecorationDetailAddressView
{
    UIImageView *_flagImageView;
    UILabel *_nameLab;
    UILabel *_phoneLab;
    UILabel *_addressLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupSubviews];
        self.backgroundColor = KCOLOR_MAIN;
    }
    return self;
}

- (void)setupSubviews {
    
    _flagImageView = [UIImageView new];
    _flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    _flagImageView.image = [UIImage imageNamed:@"orderdetails_address_icon"];
    [self addSubview:_flagImageView];
    
    _nameLab = [UILabel labelWithFont:KSCAL(28.0) textColor:[UIColor whiteColor]];
    [_nameLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:_nameLab];
    
    _phoneLab = [UILabel labelWithFont:KSCAL(28.0) textColor:[UIColor whiteColor]];
    _phoneLab.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_phoneLab];
    
    _addressLab = [UILabel labelWithFont:KSCAL(28.0) textColor:[UIColor whiteColor]];
    [self addSubview:_addressLab];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(86));
        make.top.mas_equalTo(KSCAL(14));
    }];
    
    [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLab);
        make.left.equalTo(_nameLab.mas_right).offset(KSCAL(40));
        make.right.mas_equalTo(-KSCAL(30));
    }];
    
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLab);
        make.right.equalTo(_phoneLab);
        make.top.equalTo(_phoneLab.mas_bottom).offset(4);
    }];

    [_flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(KSCAL(30));
        make.top.equalTo(_addressLab.mas_top);
        make.right.equalTo(_nameLab.mas_left).offset(-KSCAL(23));
    }];
 
}

- (void)configOrderDetailInfo:(WKDecorationOrderDetailModel *)orderDetailInfo {
    _nameLab.text = [NSString stringWithFormat:@"联系人：%@", orderDetailInfo.addressInfo.name];
    _phoneLab.text = orderDetailInfo.addressInfo.phone;
    
    NSString *addressStr = [NSString stringWithFormat:@"联系地址：%@", orderDetailInfo.addressInfo.detail];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:3.0];
    NSAttributedString *address = [[NSAttributedString alloc] initWithString:addressStr attributes:@{NSParagraphStyleAttributeName : style}];
    _addressLab.attributedText = address;
}


- (CGSize)viewSize {
    CGFloat nameH = [_nameLab.text sizeWithFont:KFONT(28.0) andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGFloat addressH = [_addressLab.text labelAutoCalculateRectWithLineSpace:3.0 Font:KFONT(28.0) MaxSize:CGSizeMake(kScreenW-KSCAL(116), MAXFLOAT)].height;
    CGFloat height = nameH + addressH + KSCAL(28) + 4;
    return CGSizeMake(kScreenW, height);
}


@end
