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
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupSubviews {
    
    _flagImageView = [UIImageView new];
    _flagImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_flagImageView];
    
    _nameLab = [UILabel labelWithFont:13.0 textColor:[UIColor blackColor]];
    _nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_nameLab];
    
    _phoneLab = [UILabel labelWithFont:13.0 textColor:[UIColor blackColor]];
    [_phoneLab setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _phoneLab.preferredMaxLayoutWidth = 0.0;
    [self addSubview:_phoneLab];
    
    _addressLab = [UILabel labelWithFont:13.0 textColor:[UIColor blackColor]];
    [self addSubview:_addressLab];
    
    [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
    
    [_flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self->_phoneLab.mas_bottom).offset(4);
        make.left.mas_equalTo(15);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_flagImageView.mas_right).offset(10);
        make.top.equalTo(self->_phoneLab);
        make.right.equalTo(self->_phoneLab.mas_left).offset(-5);
    }];
    
    [_addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_nameLab);
        make.right.equalTo(self->_phoneLab);
        make.top.equalTo(self->_phoneLab.mas_bottom).offset(8);
    }];
}

- (void)configOrderInfo:(SQDecorationDetailModel *)orderInfo {
    _nameLab.text = @"联系人：小伊";
    _phoneLab.text = @"15728006850";
    _addressLab.text = @"联系地址：对方是否色弱无若热无温柔沃尔沃二无若沃尔沃惹我二沃尔沃二为 玩儿温热无沃尔沃";
}

- (CGSize)viewSize {
    
    CGFloat nameH = [_nameLab.text sizeWithFont:[UIFont systemFontOfSize:13.0] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].height;
    CGFloat addressH = [_addressLab.text sizeWithFont:[UIFont systemFontOfSize:13.0] andMaxSize:CGSizeMake(kScreenW - 60, MAXFLOAT)].height;
    
    CGFloat height = nameH + 8 + 30 + addressH;
    
    return CGSizeMake(kScreenW, height);
}


@end
