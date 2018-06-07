//
//  WKUserCenterCollectCell.m
//  QingYouProject
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ccyouge. All rights reserved.
//

#import "WKUserCenterCollectCell.h"

@implementation WKUserCenterCollectCell
{
    UIImageView *_productImageView;
    UILabel *_productNameLabel;
    UIButton *_cancelCollectBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _productImageView = [[UIImageView alloc] init];
    _productImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_productImageView];
    
    _productNameLabel = [UILabel labelWithFont:KSCAL(30) textColor:[UIColor blackColor]];
    _productNameLabel.numberOfLines = 2;
    [self.contentView addSubview:_productNameLabel];
    
    _cancelCollectBtn = [UIButton buttonWithTitle:@"取消收藏" titleFont:KSCAL(28) titleColor:[UIColor blackColor]];
    _cancelCollectBtn.layer.cornerRadius = 3.0;
    _cancelCollectBtn.layer.borderColor = colorWithLine.CGColor;
    _cancelCollectBtn.layer.borderWidth = 1.0;
    [self.contentView addSubview:_cancelCollectBtn];
    
    [_productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KSCAL(30));
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(KSCAL(160));
        make.height.mas_equalTo(KSCAL(100));
    }];
    
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productImageView);
        make.left.equalTo(_productImageView.mas_right).offset(KSCAL(20));
        make.right.mas_equalTo(-KSCAL(30));
    }];
    
    [_cancelCollectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_productNameLabel);
        make.bottom.equalTo(_productImageView);
        make.size.mas_equalTo(CGSizeMake(KSCAL(140), KSCAL(60)));
    }];
    
    _productImageView.backgroundColor = [UIColor orangeColor];
}

@end
