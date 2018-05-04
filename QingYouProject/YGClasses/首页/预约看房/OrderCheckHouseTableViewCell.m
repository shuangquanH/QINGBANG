//
//  OrderCheckHouseTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "OrderCheckHouseTableViewCell.h"

@implementation OrderCheckHouseTableViewCell
{
    UILabel *_titleLabel; //标题
    UILabel *_money; //月薪
    UILabel *_uinitLabel; //单位
    UILabel *_AreaNumberLabel; //投递状态
    UIImageView *_arrowImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(OrderCheckHouseModel *)model
{
    _model = model;
    [_arrowImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgs] placeholderImage:YGDefaultImgFour_Three];
    _titleLabel.text = _model.name;
    _money.text = [NSString stringWithFormat:@"%@",_model.price];
    [_money sizeToFit];
    _money.frame = CGRectMake(_money.x,_money.y , _money.width, 25);
    _uinitLabel.frame = CGRectMake(_money.x+_money.width,_money.y+3 , 100, 20);
    _AreaNumberLabel.text = [NSString stringWithFormat:@"%@㎡ | %@ | %@",_model.proportion,_model.floor,_model.remarks];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = colorWithTable;
    
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 110)];
        baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:baseView];
        
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.frame = CGRectMake(10, 15, 110, 80);
        _arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
        _arrowImageView.clipsToBounds = YES;
        [self.contentView addSubview:_arrowImageView];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_arrowImageView.x+_arrowImageView.width+10,_arrowImageView.y , YGScreenWidth-(_arrowImageView.x+_arrowImageView.width+10)-10, 20)];
        _titleLabel.text = @"王者荣耀   男   24岁   本科";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.textColor = colorWithBlack;
        [baseView addSubview:_titleLabel];
        
        
        _money = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.x,_arrowImageView.y+_arrowImageView.height-20 , 100, 25)];
        _money.text = @"100";
        _money.textAlignment = NSTextAlignmentLeft;
        _money.font = [UIFont systemFontOfSize:YGFontSizeBigTwo];
        _money.textColor = colorWithOrangeColor;
        [_money sizeToFit];
        _money.frame = CGRectMake(_money.x,_money.y , _money.width, 25);
        [baseView addSubview:_money];
        
        _uinitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_money.x+_money.width,_money.y+5 , 100, 20)];
        _uinitLabel.text = @"元/月/㎡";
        _uinitLabel.textAlignment = NSTextAlignmentLeft;
        _uinitLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        _uinitLabel.textColor = colorWithOrangeColor;
        [baseView addSubview:_uinitLabel];
        
        
        _AreaNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.x,_money.y-20, YGScreenWidth-(_arrowImageView.x+_arrowImageView.width+10)-10, 20)];
        _AreaNumberLabel.text = @"60㎡|A302|精装";
        _AreaNumberLabel.textAlignment = NSTextAlignmentLeft;
        _AreaNumberLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        _AreaNumberLabel.textColor = colorWithPlaceholder;
//        [_AreaNumberLabel sizeToFit];
//        _AreaNumberLabel.frame = CGRectMake(_AreaNumberLabel.x,_AreaNumberLabel.y , _AreaNumberLabel.width, 20);
        [baseView addSubview:_AreaNumberLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 110, YGScreenWidth-10, 1)];
        lineView.backgroundColor = colorWithLine;
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

@end
