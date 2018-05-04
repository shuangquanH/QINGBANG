//
//  MineIntergralRecordTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineIntergralRecordTableViewCell.h"

@implementation MineIntergralRecordTableViewCell
{
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UILabel *_moneyLabel;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithYGWhite;
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews
{
    //热门推荐label
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithBlack;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
    _titleLabel.text = @"啥的骄傲导师端";
    _titleLabel.frame = CGRectMake(10, 10,YGScreenWidth-130, 20);
    [self.contentView addSubview:_titleLabel];
    
    //热门推荐label
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.textColor = colorWithDeepGray;
    _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _dateLabel.text = @"08-29";
    _dateLabel.frame = CGRectMake(10, _titleLabel.y+_titleLabel.height,200, 20);
    [self.contentView addSubview:_dateLabel];
    
 
    //热门推荐label
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.textColor = colorWithBlack;
    _moneyLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _moneyLabel.text = @"-300.00";
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_moneyLabel];
    _moneyLabel.frame = CGRectMake(YGScreenWidth-120, 20,110, 20);

}
- (void)setModel:(MineIntergralRecordModel *)model
{
    _model = model;
    _titleLabel.text = _model.reason;
    _dateLabel.text = _model.createDate;
    _moneyLabel.text = [NSString stringWithFormat:@"%@%@",model.changes,model.amount];
    if ([model.changes isEqualToString:@"+"]) {
        _moneyLabel.textColor = colorWithOrangeColor;
    }
    else {
        _moneyLabel.textColor = colorWithMainColor;
    }
    

}

@end
