//
//  TradeRecordCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/25.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "TradeRecordCell.h"

@implementation TradeRecordCell
{
    UILabel *_titleLabel;
    UILabel *_describeLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(TradeRecoredModel *)model
{
    _model = model;
    if(_model.userPhone.length)
    {
        _titleLabel.text = [_model.userPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4)  withString:@"****"];
    }
    _describeLabel.text = _model.createDate;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //热门推荐label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _titleLabel.text = @"青网科技";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.frame = CGRectMake(0, 0,YGScreenWidth/2, 40);
        [self.contentView addSubview:_titleLabel];
        
        
        //热门推荐label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(YGScreenWidth/2, 0,YGScreenWidth/2, 40);
        _describeLabel.textColor = colorWithLightGray;
        _describeLabel.text = @"我评论了";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _describeLabel.numberOfLines = 0;
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_describeLabel];
   
    }
    return self;
}
@end
