//
//  BreakContractBillTableViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/19.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BreakContractBillTableViewCell.h"

@implementation BreakContractBillTableViewCell
{
    UIView          *_baseView;
    UILabel *_titleLabel;
    
    UIImageView *_caseLeftLineImageView; //水滴
    UILabel *_caseLeaderLabel; //房租
    UILabel * _signLabel; //已逾期
    UIImageView *_bigColorView;
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
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 115)];
    _baseView.backgroundColor = colorWithYGWhite;
    [self.contentView addSubview:_baseView];
    //大背景
    _bigColorView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, YGScreenWidth-20, 95)];
    _bigColorView.layer.cornerRadius= 5;
    _bigColorView.contentMode = UIViewContentModeScaleAspectFill;
    _bigColorView.clipsToBounds = YES;
    [_baseView addSubview:_bigColorView];
    
    
    //水滴
    _caseLeftLineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    _caseLeftLineImageView.frame = CGRectMake(0.34*_bigColorView.width,15,25, 25);
    _caseLeftLineImageView.contentMode = UIViewContentModeScaleAspectFill;
    _caseLeftLineImageView.clipsToBounds = YES;
    [_bigColorView addSubview:_caseLeftLineImageView];
    
    _caseLeaderLabel = [[UILabel alloc] init];
    _caseLeaderLabel.textColor = colorWithYGWhite;
    _caseLeaderLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _caseLeaderLabel.text = @"房租账单";
    _caseLeaderLabel.frame = CGRectMake(_caseLeftLineImageView.width+_caseLeftLineImageView.x+5, _caseLeftLineImageView.y+5, 100, 20);
    [_caseLeaderLabel sizeToFitHorizontal];
    [_bigColorView addSubview:_caseLeaderLabel];

    
    UIView *baseLineView = [[UIView alloc] initWithFrame:CGRectMake(_caseLeftLineImageView.x, _caseLeftLineImageView.y+_caseLeftLineImageView.height+5, _caseLeaderLabel.width+25+10, 1)];
    baseLineView.backgroundColor = colorWithYGWhite;
    [_bigColorView addSubview:baseLineView];
    
    
    //最新账单
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = colorWithYGWhite;
    _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _titleLabel.text = @"最新账单  2017-3-19 至 2017-9-19";
    _titleLabel.frame = CGRectMake(10, _bigColorView.height-30,YGScreenWidth-30-55, 20);
    [_bigColorView addSubview:_titleLabel];
    
    //已逾期
   _signLabel = [[UILabel alloc]init];
    _signLabel.frame = CGRectMake(_bigColorView.width-65,_titleLabel.y, 55, 20);
    _signLabel.textColor = colorWithYGWhite;
    _signLabel.text = @"已逾期";
    _signLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _signLabel.numberOfLines = 0;
    _signLabel.textAlignment = NSTextAlignmentRight;
    [_bigColorView addSubview:_signLabel];
    _signLabel.centery = _titleLabel.centery;
}
- (void)setModel:(BreakContractBillModel *)model
{
    _model = model;
    _caseLeftLineImageView.image = [UIImage imageNamed:_model.img];
    _caseLeaderLabel.text = [NSString stringWithFormat:@"%@账单",_model.title];
    if ([_model.state isEqualToString:@"1"]) {
        _signLabel.text = @"未缴纳";
        _titleLabel.text = [NSString stringWithFormat:@"最新账单 %@ 至 %@",_model.startTime,_model.endTime];

    }else
    {
        _signLabel.text = @"";
        _titleLabel.text = @"";

    }
    _bigColorView.image = [UIImage imageNamed:_model.backGroundImg];
}
@end
