//
//  AllianceMemberTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceMemberTableViewCell.h"

@implementation AllianceMemberTableViewCell
{
    UIView *_baseView;
    UIImageView *_leftImageView; //左边的图
    UILabel *_describeLabel; //内容
    UILabel *_titleLabel; //标题
    UIButton *_applyBackOutBtn; //申请退出按钮
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(AllianceMemberModel *)model
{
    _model = model;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_model.userImg] placeholderImage:YGDefaultImgAvatar];
    _titleLabel.text = _model.userName;
    _describeLabel.text = _model.autograph;
    [_describeLabel sizeToFit];
    _describeLabel.frame = CGRectMake(_describeLabel.x,_describeLabel.y, YGScreenWidth-80, _describeLabel.height+5);
    if ((_describeLabel.height+_titleLabel.height)>50) {
        _baseView.frame = CGRectMake(_baseView.x,_baseView.y, _baseView.width, _describeLabel.height+_describeLabel.y+15);
    }else
    {
        _baseView.frame = CGRectMake(_baseView.x,_baseView.y, _baseView.width, 70);

    }


}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //热门推荐view
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 70)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
    
        
        //左线
        _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
        _leftImageView.frame = CGRectMake(10, 10, 50, 50);
        _leftImageView.layer.borderColor = colorWithLine.CGColor;
        _leftImageView.layer.borderWidth = 0.5;
        _leftImageView.backgroundColor = colorWithMainColor;
        _leftImageView.layer.cornerRadius = 25;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        [_baseView addSubview:_leftImageView];
        
        //新鲜事标题label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.text = @"今日头条";
        _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y,YGScreenWidth-(_leftImageView.x+_leftImageView.width+10)-10, 25);
        [_baseView addSubview:_titleLabel];
        
        
        //新鲜事内容label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height, _titleLabel.width, 25);
        _describeLabel.textColor = colorWithDeepGray;
        _describeLabel.text = @"115位盟友";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _describeLabel.numberOfLines = 0;
        [_baseView addSubview:_describeLabel];
        
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(YGScreenWidth, _baseView.height);
}
@end
