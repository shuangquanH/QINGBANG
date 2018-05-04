//
//  MyAllianceTableViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/4.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyAllianceTableViewCell.h"

@implementation MyAllianceTableViewCell
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
- (void)setModel:(AllAllianceModel *)model
{
    _model = model;
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_model.allianceImg] placeholderImage:YGDefaultImgSquare];
    if (![self.cellType isEqualToString:@"fravorite"]) {
        if ([_model.allianceID isEqualToString:YGSingletonMarco.user.allianceID]) {
            _applyBackOutBtn.hidden = YES;
        }
    }
    _titleLabel.text = _model.allianceName;
    _describeLabel.text = [NSString stringWithFormat:@"%@位盟友",_model.memberCount];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //热门推荐view
        _baseView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 95)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0, YGScreenWidth, 1)];
//        lineView.backgroundColor = colorWithLine;
//        [_baseView addSubview:lineView];
        
        //左线
        _leftImageView = [[UIImageView alloc]initWithImage:YGDefaultImgSquare];
        _leftImageView.frame = CGRectMake(10, 10, 70, 70);
        _leftImageView.layer.borderColor = colorWithLine.CGColor;
        _leftImageView.layer.borderWidth = 0.5;
        _leftImageView.layer.cornerRadius = 5;
        _leftImageView.backgroundColor = colorWithMainColor;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        [_baseView addSubview:_leftImageView];
        
        //新鲜事标题label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.text = @"今日头条";
        _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y+5,YGScreenWidth-100-15, 25);
        [_baseView addSubview:_titleLabel];
        
        
        //新鲜事内容label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+10, YGScreenWidth-180, 25);
        _describeLabel.textColor = colorWithLightGray;
        _describeLabel.text = @"115位盟友";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        _describeLabel.numberOfLines = 2;
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_baseView addSubview:_describeLabel];
        
        _applyBackOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyBackOutBtn.frame = CGRectMake(YGScreenWidth-85, _describeLabel.y, 75, 30);
        _applyBackOutBtn.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        [_applyBackOutBtn setTitleColor:colorWithMainColor forState:UIControlStateNormal];
        _applyBackOutBtn.layer.borderColor = colorWithMainColor.CGColor;
        _applyBackOutBtn.layer.borderWidth = 1;
        _applyBackOutBtn.layer.cornerRadius = 15;
        [_applyBackOutBtn addTarget:self action:@selector(applyBackOutBtnClilckAction:) forControlEvents:UIControlEventTouchUpInside];
        _applyBackOutBtn.centery = _describeLabel.centery;
        [_baseView addSubview:_applyBackOutBtn];
  
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 89, YGScreenWidth-10, 1)];
//        lineView.backgroundColor = colorWithTable;
//        [_baseView addSubview:lineView];
    }
    return self;
}
- (void)setCellType:(NSString *)cellType
{
    _cellType = cellType;
    if ([self.cellType isEqualToString:@"fravorite"]) {
        
        [_applyBackOutBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }else
    {
        if ([_model.allianceID isEqualToString:YGSingletonMarco.user.allianceID]) {
            _applyBackOutBtn.hidden = YES;
        }
        [_applyBackOutBtn setTitle:@"申请退出" forState:UIControlStateNormal];
    }
}
- (void)applyBackOutBtnClilckAction:(UIButton *)btn
{
    [self.myAllianceTableViewCellDelegate applyBackOutBtnWithModel:_model];
    
}
@end
