//
//  ServiceContentCollectionViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/18.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ServiceContentCollectionViewCell.h"

@implementation ServiceContentCollectionViewCell
{
    UIView              *_baseView;
    UILabel             *_titleLabel;
    UILabel             *_countTimesLabel;
    
}

- (void)setModel:(ServiceResonModel *)model
{
    _model = model;
    _titleLabel.text = _model.title;
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_model.introduce];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_model.introduce length])];
    //attributedText设置后之前设置的都失效
    
    _countTimesLabel.attributedText = attributedString;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews
{
    _baseView = [[UIView alloc] init];
    _baseView.layer.cornerRadius = 3;
    _baseView.clipsToBounds = YES;
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_baseView];
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
 
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    coverView.userInteractionEnabled = YES;
    coverView.backgroundColor = colorWithMainColor;
    [_baseView addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_baseView);
        make.right.mas_equalTo(_baseView);
        make.top.mas_equalTo(_baseView);
        make.height.mas_equalTo(30);
    }];
    
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = colorWithYGWhite;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _titleLabel.text = @"有个技术工厂 有个技术工厂";
    [coverView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(coverView).mas_offset(5);
        make.top.mas_equalTo(coverView.mas_top).mas_offset(10);
        make.right.mas_equalTo(coverView).mas_offset(-5);
        make.centerY.mas_equalTo(coverView.mas_centerY);

    }];
    
    
    
    _countTimesLabel = [[UILabel alloc] init];
    _countTimesLabel.textColor = colorWithDeepGray;
    _countTimesLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _countTimesLabel.text = @"1:40";
    _countTimesLabel.textAlignment = NSTextAlignmentCenter;
    _countTimesLabel.numberOfLines = 0;
    [_baseView addSubview:_countTimesLabel];
    [_countTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coverView.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(_baseView.mas_left).mas_offset(5);
        make.right.mas_equalTo(_baseView.mas_right).mas_offset(-5);
    }];
    
    
    UIView *baseCoverView = [[UIView alloc] init];
    baseCoverView.layer.cornerRadius = 3;
    baseCoverView.clipsToBounds = YES;
    baseCoverView.backgroundColor = [UIColor clearColor];
    baseCoverView.userInteractionEnabled = YES;
    [self.contentView addSubview:baseCoverView];
    [baseCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
}

@end
