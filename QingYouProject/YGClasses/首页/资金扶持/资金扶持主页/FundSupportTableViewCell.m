//
//  FundSupportTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/17.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "FundSupportTableViewCell.h"

@implementation FundSupportTableViewCell
{
    UILabel *_titleLabel; //标题
    UIImageView *_bigImageView; //图
    UIButton *_goInDetailBtn; //进入详情指示
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 3, 20)];
    [self.contentView addSubview:leftView];
    
    //新鲜事标题label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _titleLabel.text = @"今日头条";
    _titleLabel.frame = CGRectMake(leftView.x+leftView.width+10, leftView.y,YGScreenWidth-30, 20);
    [self.contentView addSubview:_titleLabel];
    //大图
    _bigImageView = [[UIImageView alloc]initWithImage:YGDefaultImgTwo_One];
    _bigImageView.frame = CGRectMake(10, _titleLabel.height+_titleLabel.height, YGScreenWidth-20, (YGScreenWidth-20)*0.5);
    _bigImageView.layer.borderColor = colorWithLine.CGColor;
    _bigImageView.layer.borderWidth = 0.5;
    _bigImageView.backgroundColor = colorWithMainColor;
    _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bigImageView.clipsToBounds = YES;
    [self.contentView addSubview:_bigImageView];
    
    //新鲜事标题label
    _goInDetailBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _bigImageView.height-30, _bigImageView.width, 30)];
    _goInDetailBtn.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
    [_goInDetailBtn setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
    _goInDetailBtn.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"进入服务大厅"];
    NSTextAttachment *attatchment = [[NSTextAttachment alloc] init];
    attatchment.image = [UIImage imageNamed:@"home_tool1"];
    attatchment.bounds = CGRectMake(0, -3, attatchment.image.size.width, attatchment.image.size.height);
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    [_goInDetailBtn setAttributedTitle:attributedText forState:UIControlStateNormal];
    [_bigImageView addSubview:_goInDetailBtn];
}

- (void)setModel:(FundSupportModel *)model
{
    _model = model;
    _titleLabel.text = _model.title;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:_model.picture] placeholderImage:YGDefaultImgTwo_One];  
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"进入%@大厅→",_model.keyWord] attributes:@{NSForegroundColorAttributeName:colorWithYGWhite,NSFontAttributeName:[UIFont systemFontOfSize:YGFontSizeNormal]}];
    
    NSTextAttachment *attatchment = [[NSTextAttachment alloc] init];
    attatchment.image = [UIImage imageNamed:@"→"];
    attatchment.bounds = CGRectMake(0, -3, attatchment.image.size.width, attatchment.image.size.height);
    [attributedText appendAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment]];
    [_goInDetailBtn setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    
}
@end
