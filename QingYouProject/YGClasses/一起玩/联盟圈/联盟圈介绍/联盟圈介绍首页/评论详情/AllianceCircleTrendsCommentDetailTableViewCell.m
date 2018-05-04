//
//  AllianceCircleTrendsCommentDetailTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/30.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "AllianceCircleTrendsCommentDetailTableViewCell.h"

@implementation AllianceCircleTrendsCommentDetailTableViewCell
{
    UIView *_baseView;
    UILabel *_titleLabel; //标题
    UILabel *_dateLabel; //标题
    UILabel *_describeLabel;
    UIImageView *_leftImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(AllianceCircleTrendsCommentDetailModel *)model
{
    _model = model;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_model.userImg] placeholderImage:YGDefaultImgSquare];
    _titleLabel.text = _model.userName;
    [_titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-100-15];
    _dateLabel.text = _model.createDate;
    _describeLabel.text = _model.content;
    [_describeLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-58];
//    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-58, 0);

    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _describeLabel.height+20+_describeLabel.y);

}
-(void)setSecondModel:(SecondHandCommentModel *)secondModel
{
    _secondModel = secondModel;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:secondModel.userImg] placeholderImage:YGDefaultImgSquare];
    _titleLabel.text = secondModel.userName;
    [_titleLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-100-15];
    _dateLabel.text = secondModel.time;
    _describeLabel.text = secondModel.comment;
    [_describeLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-58];
    
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _describeLabel.height+20+_describeLabel.y);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        //热门推荐view
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 100)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
        //左线
        _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
        _leftImageView.frame = CGRectMake(10, 20, 35, 35);
        _leftImageView.layer.borderColor = colorWithLine.CGColor;
        _leftImageView.layer.borderWidth = 0.5;
        _leftImageView.backgroundColor = colorWithMainColor;
        _leftImageView.layer.cornerRadius = 17.5;
        _leftImageView.clipsToBounds = YES;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_baseView addSubview:_leftImageView];
        
        //热门推荐label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.text = @"";
        _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y+5,YGScreenWidth-48-10, 20);
        [_baseView addSubview:_titleLabel];
        
        
        //热门推荐label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-58, 0);
        _describeLabel.textColor = colorWithBlack;
        _describeLabel.text = @"";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _describeLabel.numberOfLines = 0;
        [_baseView addSubview:_describeLabel];
        
        //时间label
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.frame = CGRectMake(YGScreenWidth-150,_leftImageView.y+5 , 140, 20);
        _dateLabel.textColor = colorWithDeepGray;
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.text = @"9-20 12:17:12";
        _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _dateLabel.numberOfLines = 0;
        [_baseView addSubview:_dateLabel];
        
        
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return  CGSizeMake(_baseView.width, _baseView.height);
}
@end
