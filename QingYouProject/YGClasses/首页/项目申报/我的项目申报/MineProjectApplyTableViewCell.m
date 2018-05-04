//
//  MineProjectApplyTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/28.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MineProjectApplyTableViewCell.h"

@implementation MineProjectApplyTableViewCell
{
    UILabel *_titleLabel; //标题
    UILabel *_createDate; //创建时间
    UIView *_baseView;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(MineProjectApplyModel *)model
{
    _model = model;
    _titleLabel.text =  _model.remarks;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y , YGScreenWidth-20, _titleLabel.height+10);
    
    _createDate.text = [NSString stringWithFormat:@"企业名称：%@",_model.enterpriseName];
    [_createDate sizeToFit];
    _createDate.frame = CGRectMake(_createDate.x,_titleLabel.height+_titleLabel.y , YGScreenWidth-20, _createDate.height+10);
    
    if ((_createDate.y+_createDate.height) <= 60)
    {
        _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, 58);

    }else
    {
        _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, _createDate.y+_createDate.height+10);
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithTable;
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, YGScreenWidth, 58)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
        _titleLabel.text = @"岗位外包服务";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigThree];
        _titleLabel.textColor = colorWithBlack;
        [_baseView addSubview:_titleLabel];
        
        _createDate = [[UILabel alloc] initWithFrame:CGRectMake(10,_titleLabel.height+_titleLabel.y , YGScreenWidth-20, 20)];
        _createDate.text = @"企业名称：2017-9-13 13：54";
        _createDate.textAlignment = NSTextAlignmentLeft;
        _createDate.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _createDate.textColor = colorWithDeepGray;
        _createDate.numberOfLines = 0;
        [_baseView addSubview:_createDate];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(_baseView.width, _baseView.height);
}
@end
