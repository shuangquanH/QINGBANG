//
//  SeccondHandExchangeCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/14.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SeccondHandExchangeCell.h"

@implementation SeccondHandExchangeCell
{
    UIView              *_baseView;
    UIImageView         *_playerImageView;
    
    UILabel             *_titleLabel;
    UIImageView         *_eyeImageView;
    UILabel             *_countTimesLabel;
    
}

- (void)setModel:(SeccondModel *)model
{
    _model = model;
    _titleLabel.text = _model.name;
    [_playerImageView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:YGDefaultImgAvatar];
    _countTimesLabel.text = _model.detail;
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
    
    _playerImageView = [[UIImageView alloc] init];
    _playerImageView.layer.masksToBounds = YES;
    _playerImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _playerImageView.userInteractionEnabled = YES;
    [_baseView addSubview:_playerImageView];
    [_playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(_baseView);
        make.height.mas_equalTo(((YGScreenWidth-30)/2)*0.56);
        make.width.mas_equalTo((YGScreenWidth-30)/2);
    }];
    
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    coverView.userInteractionEnabled = YES;
    [_playerImageView addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_playerImageView);
        make.right.mas_equalTo(_playerImageView);
        make.top.mas_equalTo(_playerImageView);
        make.bottom.mas_equalTo(_playerImageView);
    }];
    
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _titleLabel.text = @"有个技术工厂 有个技术工厂 有个技术工厂有个技术工厂有个技术工厂有个技术工厂";
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleLabel.text length])];
    //attributedText设置后之前设置的都失效
    
    _titleLabel.attributedText = attributedString;
    
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleLabel sizeToFit];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.top.mas_equalTo(_playerImageView.mas_bottom).mas_offset(7);
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
    }];
    
    
    _eyeImageView = [[UIImageView alloc] init];
    _eyeImageView.layer.masksToBounds = YES;
    _eyeImageView.image = [UIImage imageNamed:@"video_eyes"];
    _eyeImageView.userInteractionEnabled = YES;
    [_baseView addSubview:_eyeImageView];
    [_eyeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_baseView.mas_bottom).mas_offset(-5);
        make.left.mas_equalTo(_baseView.mas_left).mas_offset(10);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(17);
    }];
    
    _countTimesLabel = [[UILabel alloc] init];
    _countTimesLabel.textColor = colorWithBlack;
    _countTimesLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    _countTimesLabel.text = @"1:40";
    [_baseView addSubview:_countTimesLabel];
    [_countTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_eyeImageView.mas_right).mas_offset(5);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(_baseView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(_eyeImageView.mas_centerY);
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
