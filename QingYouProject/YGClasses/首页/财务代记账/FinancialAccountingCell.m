//
//  FinancialAccountingCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/9/22.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "FinancialAccountingCell.h"

@implementation FinancialAccountingCell
{
    UIView *_baseView;
    UIImageView *_leftImageView; //左边的图
    UILabel *_describeLabel; //内容
    UILabel *_titleLabel; //标题
    UIButton *_submitOderBtn; //立即下单
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(FinancialAccountingModel *)model
{
      _model = model;
    if([self.isPush isEqualToString:@"FinancialAccounting"])
    {
        _titleLabel.text = model.financeName;
        NSString *desStr = [NSString stringWithFormat:@"¥%@",model.financePrice];
        _describeLabel.attributedText = [desStr ld_attributedStringFromNSString:desStr startLocation:0 forwardFont:[UIFont systemFontOfSize:YGFontSizeSmallThree] backFont:[UIFont systemFontOfSize:YGFontSizeBigOne] forwardColor:colorWithOrangeColor backColor:colorWithOrangeColor];
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:model.financeImg] placeholderImage:YGDefaultImgFour_Three];
    }
    else
    {
        _titleLabel.text = model.commerceName;
        NSString *desStr = [NSString stringWithFormat:@"¥%@",model.commercePrice];
        _describeLabel.attributedText = [desStr ld_attributedStringFromNSString:desStr startLocation:0 forwardFont:[UIFont systemFontOfSize:YGFontSizeSmallThree] backFont:[UIFont systemFontOfSize:YGFontSizeBigOne] forwardColor:colorWithOrangeColor backColor:colorWithOrangeColor];
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:model.commerceImg] placeholderImage:YGDefaultImgFour_Three];
    }

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
        
        //左线
        _leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_tool1.png"]];
        _leftImageView.frame = CGRectMake(10, 10, 60*1.73, 60);
        _leftImageView.layer.borderColor = colorWithLine.CGColor;
        _leftImageView.layer.borderWidth = 0.5;
        _leftImageView.backgroundColor = colorWithMainColor;
        _leftImageView.layer.cornerRadius = 5;
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        [_baseView addSubview:_leftImageView];
        
        //新鲜事标题label
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = colorWithBlack;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _titleLabel.text = @"  ";
        _titleLabel.frame = CGRectMake(_leftImageView.x+_leftImageView.width+10, _leftImageView.y +2,YGScreenWidth-_leftImageView.width-15, 20);
        [_baseView addSubview:_titleLabel];
        
        
        //新鲜事内容label
        _describeLabel = [[UILabel alloc]init];
        _describeLabel.frame = CGRectMake(_titleLabel.x,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-_leftImageView.width-25, 35);
        _describeLabel.textColor = colorWithLightGray;
        _describeLabel.text = @"";
        _describeLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _describeLabel.numberOfLines = 2;
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_baseView addSubview:_describeLabel];


        
        _submitOderBtn = [[UIButton alloc]initWithFrame:CGRectMake(YGScreenWidth-70,_describeLabel.y + 10,70,25)];
        [_submitOderBtn setTitle:@"立即下单" forState:UIControlStateNormal];
        [_submitOderBtn setTitleColor:colorWithYGWhite forState:UIControlStateNormal];
        [_submitOderBtn addTarget:self action:@selector(submitOderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _submitOderBtn.layer.cornerRadius = 13;
        _submitOderBtn.titleLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallTwo];
        [_submitOderBtn sizeToFit];
        _submitOderBtn.backgroundColor =colorWithMainColor;
        [_baseView addSubview:_submitOderBtn];
        _submitOderBtn.frame = CGRectMake(YGScreenWidth-_submitOderBtn.width-30,_describeLabel.y,_submitOderBtn.width+20,25);
        _submitOderBtn.userInteractionEnabled = NO;
        
    }
    return self;
}

- (void)submitOderButtonAction:(UIButton *)btn
{
    
}
@end
