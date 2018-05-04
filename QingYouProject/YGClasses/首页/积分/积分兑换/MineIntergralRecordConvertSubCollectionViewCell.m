//
//  MineIntergralRecordConvertSubCollectionViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralRecordConvertSubCollectionViewCell.h"

@implementation MineIntergralRecordConvertSubCollectionViewCell
{
    UIView              *_baseView;
    UIImageView         *_playerImageView;
    UILabel             *_titleLabel;
    UILabel             *_intragralContentLabel;
    
}

- (void)setModel:(MineIntergralRecordConvertModel *)model
{
    _model = model;
    _titleLabel.text = _model.title;
    [_playerImageView sd_setImageWithURL:[NSURL URLWithString:_model.picture] placeholderImage:YGDefaultImgSquare];
    _intragralContentLabel.text = _model.commodityIntegral;
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
        make.height.mas_equalTo(((YGScreenWidth-45)/2));
        make.width.mas_equalTo((YGScreenWidth-45)/2);
    }];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _titleLabel.text = @"有个技术工厂 有个技术工厂";
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleLabel.text length])];
    //attributedText设置后之前设置的都失效
    
    _titleLabel.attributedText = attributedString;
    
    _titleLabel.numberOfLines = 1;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleLabel sizeToFit];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.top.mas_equalTo(_playerImageView.mas_bottom).mas_offset(7);
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
    }];
    
    UILabel *convertLabel = [[UILabel alloc] init];
    convertLabel.textColor = colorWithYGWhite;
    convertLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    convertLabel.text = @"兑换";
    convertLabel.textAlignment = NSTextAlignmentCenter;
    convertLabel.layer.cornerRadius = 5;
    convertLabel.clipsToBounds = YES;
    convertLabel.backgroundColor = colorWithOrangeColor;
    [_baseView addSubview:convertLabel];
    [convertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(_baseView.mas_left).mas_offset(10);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(45);
    }];
    
    
    _intragralContentLabel = [[UILabel alloc] init];
    _intragralContentLabel.textColor = colorWithOrangeColor;
    _intragralContentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _intragralContentLabel.text = @"1:40";
    _intragralContentLabel.textAlignment = NSTextAlignmentRight;
    [_baseView addSubview:_intragralContentLabel];
    [_intragralContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(_baseView.mas_left).mas_offset(60);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *intragralLabel = [[UILabel alloc] init];
    intragralLabel.textColor = colorWithLightGray;
    intragralLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
    intragralLabel.text = @"青币";
    [_baseView addSubview:intragralLabel];
    [intragralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_intragralContentLabel.mas_bottom);
        make.left.mas_equalTo(_intragralContentLabel.mas_right).mas_offset(5);
        make.right.mas_equalTo(_baseView.mas_right).mas_offset(0);
        make.height.mas_equalTo(20);
    }];
//    UIView *baseCoverView = [[UIView alloc] init];
//    baseCoverView.layer.cornerRadius = 3;
//    baseCoverView.clipsToBounds = YES;
//    baseCoverView.backgroundColor = [UIColor clearColor];
//    baseCoverView.userInteractionEnabled = YES;
//    [self.contentView addSubview:baseCoverView];
//    [baseCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView);
//        make.right.mas_equalTo(self.contentView);
//        make.top.mas_equalTo(self.contentView);
//        make.bottom.mas_equalTo(self.contentView);
//    }];
//
    
}

@end
