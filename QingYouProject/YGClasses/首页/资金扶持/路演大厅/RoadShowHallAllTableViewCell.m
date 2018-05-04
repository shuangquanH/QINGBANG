//
//  RoadShowHallAllTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RoadShowHallAllTableViewCell.h"

@implementation RoadShowHallAllTableViewCell
{
    UIView              *_baseView;
    UIImageView         *_playerImageView;

    UILabel             *_titleLabel;
    UIImageView         *_eyeImageView;
    UILabel             *_countTimesLabel;
    UIButton            *_playBtn;
    
    UILabel *_statusLabel;
}

- (void)setModel:(RoadShowHallModel *)model
{
    _model = model;
    _titleLabel.text = _model.roadshowName;
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleLabel.text length])];
    //attributedText设置后之前设置的都失效
    [_titleLabel sizeToFit];
    _titleLabel.attributedText = attributedString;
    
    NSString * stringTwo = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)_model.videoImg,NULL,NULL,kCFStringEncodingUTF8));
    [_playerImageView sd_setImageWithURL:[NSURL URLWithString:stringTwo] placeholderImage:YGDefaultImgFour_Three];
    _countTimesLabel.text = _model.createDate;
    
    if (_model.auditStatus == nil) {
        _statusLabel.hidden = YES;
    }else
    {
        _countTimesLabel.text = _model.createDate;
        NSArray *typeColorArry = @[colorWithMainColor,colorWithMainColor,colorWithLightGray,colorWithBlack];
        _statusLabel.backgroundColor = [((UIColor *)typeColorArry[[_model.auditStatus intValue]]) colorWithAlphaComponent:0.7];
        NSArray *typeArry = @[@"",@"待审核",@"已完成",@"审核未通过"];
        _statusLabel.text = typeArry[[_model.auditStatus intValue]];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
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
    _playerImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    _playerImageView.userInteractionEnabled = YES;
    [_baseView addSubview:_playerImageView];
    [_playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(_baseView).mas_offset(10);
        make.height.mas_equalTo((YGScreenWidth-20)*0.56);
        make.width.mas_equalTo(YGScreenWidth-20);
    }];
    
 
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    coverView.userInteractionEnabled = YES;
    [_playerImageView addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_playerImageView);
        make.right.mas_equalTo(_playerImageView);
        make.top.mas_equalTo(_playerImageView);
        make.bottom.mas_equalTo(_playerImageView);
    }];
    
    _statusLabel = [[UILabel alloc]init];
    _statusLabel.textColor = colorWithYGWhite;
    _statusLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _statusLabel.frame = CGRectMake(0, 20,100, 30);
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.backgroundColor = [colorWithMainColor colorWithAlphaComponent:0.5];
    [coverView addSubview:_statusLabel];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _titleLabel.text = @"有个技术工厂 有个技术工厂 有个技术工厂有个技术工厂有个技术工厂有个技术工厂";
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.top.mas_equalTo(_playerImageView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
    }];
    
    //小的书签标志
    _eyeImageView = [[UIImageView alloc] init];
    _eyeImageView.layer.masksToBounds = YES;
    _eyeImageView.image = [UIImage imageNamed:@"steward_capital_label"];
    _eyeImageView.userInteractionEnabled = YES;
    [_baseView addSubview:_eyeImageView];
    [_eyeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(_baseView.mas_left).mas_offset(10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(_baseView.mas_bottom).mas_offset(-10);
    }];
    
    //时间
    _countTimesLabel = [[UILabel alloc] init];
    _countTimesLabel.textColor = colorWithLightGray;
    _countTimesLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _countTimesLabel.text = @"1:40";
    [_baseView addSubview:_countTimesLabel];
    [_countTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_eyeImageView.mas_right).mas_offset(0);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(_baseView.mas_right).mas_offset(-10);
        make.centerY.mas_equalTo(_eyeImageView.mas_centerY);
        
    }];
    
    
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:[UIImage imageNamed:@"steward_capital_play_btn"] forState:UIControlStateNormal];
    _playBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [coverView addSubview:_playBtn];
    [_playBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
//        make.top.mas_equalTo(25);
        make.centerX.mas_equalTo(coverView.centerx);
        make.centerY.mas_equalTo(coverView.centery);
    }];
}
@end
