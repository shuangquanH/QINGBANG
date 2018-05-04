//
//  PlayTogetherDetailSignUpTableViewCell.m
//  QingYouProject
//
//  Created by apple on 2017/12/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "PlayTogetherDetailSignUpTableViewCell.h"
#import "ServiceEvalutionModel.h"

@implementation PlayTogetherDetailSignUpTableViewCell

{
    UIImageView *_leftImageView;
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UILabel *_describeLabel;
    UIView *_headerView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ServiceEvalutionModel *)model
{
    _model = model;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_model.userImg] placeholderImage:YGDefaultImgAvatar];
    _leftImageView.layer.cornerRadius = 20;
    _leftImageView.clipsToBounds = YES;
    _titleLabel.text = _model.userName;
    
    if([self.typeStr isEqualToString:@"LeaveMessage"])
        _describeLabel.text = _model.context;
    else
        _describeLabel.text = _model.userAutograph;

    [_describeLabel sizeToFitVerticalWithMaxWidth:YGScreenWidth-100];
    _headerView.frame = CGRectMake(0, 0, YGScreenWidth, (20+_describeLabel.height+10)>60?(20+_describeLabel.height+10+20):60);
    NSArray * timeArry = [_model.createDate componentsSeparatedByString:@" "];
    if([timeArry count]>0)
        _dateLabel.text = [NSString stringWithFormat:@"%@",timeArry[0]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 50)];
        [self.contentView addSubview:_headerView];
        //左线
        _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
        _leftImageView.frame = CGRectMake(10, 10, 40, 40);
        _leftImageView.layer.borderColor = colorWithLine.CGColor;
        _leftImageView.layer.borderWidth = 0.5;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:_leftImageView];
        
        //热门推荐label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _titleLabel.text = @"";
        _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y,YGScreenWidth-100-15, 20);
        [_headerView addSubview:_titleLabel];
        
        //时间label
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.frame = CGRectMake(YGScreenWidth-115,_titleLabel.y , 100, 20);
        _dateLabel.textColor = colorWithPlaceholder;
        _dateLabel.text = @"";
        _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        [_headerView addSubview:_dateLabel];
        
        //热门推荐label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-100, 0);
        _describeLabel.textColor = colorWithBlack;
        _describeLabel.text = @"";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _describeLabel.numberOfLines = 0;
        [_headerView addSubview:_describeLabel];
        
        
        
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(YGScreenWidth, _headerView.height);
}
@end

