//
//  ProjectApplyMainTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/27.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "ProjectApplyMainTableViewCell.h"

@implementation ProjectApplyMainTableViewCell
{
    UIView *_baseView;
    UILabel *_describeLabel; //内容
    UILabel *_titleLabel; //标题
    UILabel *_dateLabel; //标题

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(ProjectApplyForSubModel *)model
{
    _model = model;
    _titleLabel.text = _model.fundName;
    _describeLabel.text = _model.remarks;
    [_describeLabel sizeToFit];
    _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , _describeLabel.width+5, 25);
    _dateLabel.frame = CGRectMake(_describeLabel.x+_describeLabel.width+5, _describeLabel.y, 120, 25);
    _dateLabel.text = _model.createDate;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        //热门推荐view
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 80)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 1)];
//        lineView.backgroundColor = colorWithLine;
//        [_baseView addSubview:lineView];
        
        
        //新鲜事标题label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
        _titleLabel.text = @"今日头条   ";
        _titleLabel.frame = CGRectMake(10, 15,YGScreenWidth-35, 25);
        [_baseView addSubview:_titleLabel];
        
        
        //新鲜事内容label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , 100, 20);
        _describeLabel.textColor = colorWithLightGray;
        _describeLabel.text = @" ";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_baseView addSubview:_describeLabel];
        
        //新鲜事内容label
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.frame = CGRectMake(_describeLabel.x+_describeLabel.width+5, _describeLabel.y, YGScreenWidth-20, 20);
        _dateLabel.textColor = colorWithLightGray;
        _dateLabel.text = @"is就嗲减低设计费is分解符及时答复hi合肥如武汉";
        _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _dateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_baseView addSubview:_dateLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.frame = CGRectMake(0, 0, 17, 17);
        arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
        [arrowImageView sizeToFit];
        self.accessoryView = arrowImageView;
        
    }
    return self;
}


@end
