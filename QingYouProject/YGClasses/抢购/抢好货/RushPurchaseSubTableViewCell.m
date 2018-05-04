//
//  RushPurchaseSubTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/5.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "RushPurchaseSubTableViewCell.h"

@implementation RushPurchaseSubTableViewCell
{
//    UIView              *_baseView;
    UIImageView         *_playerImageView;
    
    UILabel             *_titleLabel;
    UILabel             *_subTitleLabel;
    UILabel         *_newPriceLabel;
    UILabel             *_oldPriceLabel;
    UIButton            *_noticeBtn;
    UIView             *_dateCoverView;
    UILabel             *_dateLabel;

    UILabel *_statusLabel;
    UIView *_coverView;
    UIButton *_playBtn;
    UIView              *_oldLineView;

    
}

- (void)setModel:(RushPurchaseProductModel *)model withIndexPath:(NSIndexPath *)indexPath
{
    _model = model;
    _indexPath = indexPath;
    _titleLabel.text = _model.name;
    // 调整行间距
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_titleLabel.text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:4];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleLabel.text length])];
////    attributedText设置后之前设置的都失效
//    _titleLabel.attributedText = attributedString;


    NSString * stringTwo = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)_model.coverUrl,NULL,NULL,kCFStringEncodingUTF8));
    [_playerImageView sd_setImageWithURL:[NSURL URLWithString:stringTwo] placeholderImage:YGDefaultImgFour_Three];

    if ([_model.subTitle isEqualToString:@""]) {
        _subTitleLabel.hidden = YES;
    }else
    {
        _subTitleLabel.hidden = NO;
        _subTitleLabel.text = _model.subTitle;
    }


    _noticeBtn.userInteractionEnabled = YES;
    _newPriceLabel.text = [NSString stringWithFormat:@"¥%@",_model.newprice];
    _oldPriceLabel.text = [NSString stringWithFormat:@"¥%@",_model.oldPrice];
    _coverView.hidden = YES;
    _playBtn.hidden = YES;
    if ([_model.type isEqualToString:@"0"]) {
       
       
        if (_model.remindingSum == nil) {
            _oldLineView.hidden = NO;
        }else
        {
            _oldLineView.hidden = YES;
            _newPriceLabel.text = _model.remindingSum;
            _oldPriceLabel.text = @"人想买";
        }
        NSArray *typeArry = @[@"提醒我",@"取消提醒"];
        NSArray *typeColorArry = @[[UIColor clearColor],[UIColor clearColor]];
        NSArray *typeTextColorArry = @[colorWithMainColor,colorWithLightGray];
        NSArray *typeBorderColorArry = @[colorWithMainColor,colorWithLightGray];
        
        [_noticeBtn setTitle: typeArry[[_model.reminding intValue]] forState:UIControlStateNormal];
        [_noticeBtn setTitleColor:typeTextColorArry[[_model.reminding intValue]] forState:UIControlStateNormal];
        _noticeBtn.backgroundColor = typeColorArry[[_model.reminding intValue]];
        _noticeBtn.layer.borderColor = ((UIColor *)typeBorderColorArry[[_model.reminding intValue]]).CGColor;
        
        _noticeBtn.selected = NO;
        if ([_model.reminding isEqualToString:@"1"])
        {
            _noticeBtn.selected = YES;
        }
    }else if([_model.type isEqualToString:@"2"]) //已抢光
    {
        [_noticeBtn setTitle:@"马上抢" forState:UIControlStateNormal];
        _noticeBtn.backgroundColor = colorWithLightGray;
        _noticeBtn.layer.borderColor = colorWithLightGray.CGColor;
        [_noticeBtn setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        _noticeBtn.userInteractionEnabled = NO;
        _coverView.hidden = NO;
        _playBtn.hidden = NO;
    }else //开始抢购
    {
        [_noticeBtn setTitle:@"马上抢" forState:UIControlStateNormal];
        _noticeBtn.backgroundColor = colorWithMainColor;
        [_noticeBtn setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        _noticeBtn.userInteractionEnabled = NO;
    }
    if (_model.startDate) {
        _dateCoverView.hidden = NO;
        _dateLabel.text = [NSString stringWithFormat:@"抢购时间：%@－%@",_model.startDate,_model.endDate];
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
//    _baseView = [[UIView alloc] init];
//    _baseView.layer.cornerRadius = 3;
//    _baseView.clipsToBounds = YES;
//    _baseView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:_baseView];
//    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView);
//        make.right.mas_equalTo(self.contentView);
//        make.top.mas_equalTo(self.contentView);
//        make.bottom.mas_equalTo(self.contentView);
//    }];
    
    _playerImageView = [[UIImageView alloc] init];
    _playerImageView.layer.cornerRadius = 5;
    _playerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _playerImageView.clipsToBounds = YES;
    _playerImageView.layer.masksToBounds = YES;
    _playerImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    _playerImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_playerImageView];
    [_playerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).mas_offset(10);
        make.height.mas_equalTo((YGScreenWidth-20)*0.42);
        make.width.mas_equalTo(YGScreenWidth-20);
    }];
    
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth-20, (YGScreenWidth-20)*0.42)];
    _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _coverView.userInteractionEnabled = YES;
    [_playerImageView addSubview:_coverView];
    _coverView.hidden = YES;
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:[UIImage imageNamed:@"snapup_robthelight"] forState:UIControlStateNormal];
    _playBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_playBtn sizeToFit];
    _playBtn.frame = CGRectMake(_coverView.width/2-_playBtn.width/2, _coverView.height/2-_playBtn.width/2, _playBtn.width, _playBtn.height);
    [_coverView addSubview:_playBtn];
    _playBtn.hidden = YES;

    _dateCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, (YGScreenWidth-20)*0.42-35, YGScreenWidth-22, 35)];
    _dateCoverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_playerImageView addSubview:_dateCoverView];
    _dateCoverView.hidden = YES;
    
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _dateCoverView.width-5, 35)];
    _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _dateLabel.text = @"";
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.textColor = colorWithYGWhite;
    [_dateCoverView addSubview:_dateLabel];

    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
    _titleLabel.text = @"有个技术工厂 有个技术工厂 有个技术工厂有个技术工厂有个技术工厂有个技术工厂";
    _titleLabel.numberOfLines = 2;
    _titleLabel.preferredMaxLayoutWidth = YGScreenWidth-20;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.top.mas_equalTo(_playerImageView.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
    }];
    

    
    _subTitleLabel = [[UILabel alloc] init];
    _subTitleLabel.textColor = colorWithDeepGray;
    _subTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _subTitleLabel.text = @"有个技术工厂 有个技术工厂 有个技术工厂有个技术工厂有个技术工厂有个技术工厂";
    _subTitleLabel.numberOfLines = 2;
    _subTitleLabel.preferredMaxLayoutWidth = YGScreenWidth-20;
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(10);
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.contentView).mas_offset(-10);
    }];
    
    
    //时间label
    _newPriceLabel = [[UILabel alloc]init];
    _newPriceLabel.textColor = colorWithOrangeColor;
    _newPriceLabel.text = @"¥299";
    _newPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeBigThree];
    _newPriceLabel.preferredMaxLayoutWidth = 100;
    [self.contentView addSubview:_newPriceLabel];
    [_newPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_subTitleLabel.mas_bottom).mas_offset(30);
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
    }];
    
    //热门推荐label
    _oldPriceLabel = [[UILabel alloc]init];
    _oldPriceLabel.textColor = colorWithPlaceholder;
    _oldPriceLabel.text = @"¥99.9";
    _oldPriceLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    [self.contentView addSubview:_oldPriceLabel];
    [_oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_newPriceLabel.mas_right).mas_offset(10);
        make.top.mas_equalTo(_newPriceLabel.mas_top).mas_offset(5);
        
    }];
    
    _oldLineView = [[UIView alloc] initWithFrame:CGRectMake(0,_newPriceLabel.y+_newPriceLabel.height+10, YGScreenWidth, 1)];
    _oldLineView.backgroundColor = colorWithPlaceholder;
    [self.contentView addSubview:_oldLineView];
    [_oldLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_oldPriceLabel.mas_left).mas_offset(-5);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(_oldPriceLabel.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(_oldPriceLabel.mas_centerY);
        
    }];
    
    _noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_noticeBtn setTitle:@"提醒我" forState:UIControlStateNormal];
    [_noticeBtn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
    _noticeBtn.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _noticeBtn.layer.cornerRadius = 12;
    _noticeBtn.layer.borderColor = colorWithMainColor.CGColor;
    _noticeBtn.layer.borderWidth = 0.7;
    [_noticeBtn addTarget:self action:@selector(noticeToPurchase:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_noticeBtn];
    [_noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(75);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.bottom.mas_equalTo(_newPriceLabel.mas_bottom);

    }];
    
}

- (void)noticeToPurchase:(UIButton *)btn
{
    [self.delegate RushPurchaseSubTableViewCellClickNoticeButtonWithModel:_model andIndexPath:_indexPath andNoticeButton:btn];
}
@end
