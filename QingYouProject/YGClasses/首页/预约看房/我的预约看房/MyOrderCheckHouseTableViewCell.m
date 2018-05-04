//
//  MyOrderCheckHouseTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/12/1.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyOrderCheckHouseTableViewCell.h"

@implementation MyOrderCheckHouseTableViewCell
{
    UILabel *_titleLabel; //标题
    UILabel *_uinitLabel; //单位
    UIImageView *_arrowImageView;
    UIButton *_cancleOrderButton;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(OrderCheckHouseModel *)model withHiddenCancleButton:(BOOL)cancle
{
    _model = model;
    [_arrowImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgs] placeholderImage:YGDefaultImgFour_Three];
    _titleLabel.text = _model.name;
    _uinitLabel.text  = [NSString stringWithFormat:@"预约时间 %@",_model.time];
    if (cancle) {
        _cancleOrderButton.hidden = YES;
    }
    
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
        
        
        
        _uinitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.x,_arrowImageView.y+_arrowImageView.height-25 , YGScreenWidth-20-_arrowImageView.width-10, 20)];
        _uinitLabel.text = @"元/月/㎡";
        _uinitLabel.textAlignment = NSTextAlignmentLeft;
        _uinitLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _uinitLabel.textColor = colorWithPlaceholder;
        [baseView addSubview:_uinitLabel];
        
        _cancleOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleOrderButton.frame = CGRectMake(YGScreenWidth-85, _uinitLabel.y, 70, 30);
        [_cancleOrderButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleOrderButton.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        [_cancleOrderButton setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        _cancleOrderButton.layer.borderColor = colorWithMainColor.CGColor;
        _cancleOrderButton.layer.borderWidth = 1;
        _cancleOrderButton.layer.cornerRadius = 15;
        [_cancleOrderButton addTarget:self action:@selector(cancleBackOutBtnClilckAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancleOrderButton.centery = _uinitLabel.centery;
        [baseView addSubview:_cancleOrderButton];
        
    }
    return self;
}

- (void)cancleBackOutBtnClilckAction:(UIButton *)btn
{
    [self.delegate cancleBackOutBtnWithModel:_model];

}
@end
