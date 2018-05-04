//
//  AllianceMainTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/29.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceMainTableViewCell.h"

@implementation AllianceMainTableViewCell
{
    UIView *_baseView;
    UIImageView *_leftImageView; //左边的图
    UILabel *_describeLabel; //内容
    UILabel *_titleLabel; //标题
    UILabel *_dateLabel; //内容
    UIButton *_applyBackOutBtn; //申请退出按钮
    UILabel *_endLabel; //内容

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(AllianceMainModel *)model
{
    _model = model;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_model.activityImg] placeholderImage:YGDefaultImgAvatar];
    _titleLabel.text = _model.activityName;
    _describeLabel.text = _model.activityAddress;
    _dateLabel.text = [NSString stringWithFormat:@"%@ 至 %@",_model.activityBeginTime,_model.activityEndTime];
    if ([_model.isEnd isEqualToString:@"1"]) {
        _endLabel.hidden = NO;
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //热门推荐view
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 80)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
        
        //左线
        _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
        _leftImageView.frame = CGRectMake(10, 10, 120, 60);
        _leftImageView.layer.borderColor = colorWithLine.CGColor;
        _leftImageView.layer.borderWidth = 0.5;
        _leftImageView.backgroundColor = colorWithMainColor;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        [_baseView addSubview:_leftImageView];
        
        
        _endLabel = [[UILabel alloc]init];
        _endLabel.textColor = colorWithYGWhite;
        _endLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _endLabel.backgroundColor = [colorWithBlack colorWithAlphaComponent:0.5];
        _endLabel.text = @"已结束";
        _endLabel.textAlignment = NSTextAlignmentCenter;
        _endLabel.frame = CGRectMake(0, _leftImageView.height-25,_leftImageView.width, 25);
        [_leftImageView addSubview:_endLabel];
        _endLabel.hidden = YES;
        
        //新鲜事标题label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.text = @"今日头条";
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+7, _leftImageView.y,YGScreenWidth-(_leftImageView.x+_leftImageView.width+7)-10, 20);
        [_baseView addSubview:_titleLabel];
        
        
        //新鲜事内容label
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+7,_titleLabel.y+_titleLabel.height+3, YGScreenWidth-_titleLabel.x-30, 17);
        _dateLabel.textColor = colorWithDeepGray;
        _dateLabel.text = @"115位盟友";
        _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _dateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_baseView addSubview:_dateLabel];
        
        //新鲜事内容label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+7,_dateLabel.y+_dateLabel.height+3, YGScreenWidth-_titleLabel.x-30, 17);
        _describeLabel.textColor = colorWithDeepGray;
        _describeLabel.text = @"115位盟友";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_baseView addSubview:_describeLabel];
    }
    return self;
}

@end
