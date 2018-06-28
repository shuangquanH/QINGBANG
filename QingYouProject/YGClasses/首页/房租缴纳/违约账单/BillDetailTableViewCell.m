//
//  BillDetailTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/10/20.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BillDetailTableViewCell.h"
#import "NSString+SQAttributeString.h"

@implementation BillDetailTableViewCell
{
    UIView *_baseView;
    UILabel *_payStatsLabel; //缴纳状态
    UILabel *_statsLabel; //逾期状态
    UILabel *_rentMoney; //租金
    UILabel *_propertyMoney; //物业
    
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
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
    _baseView.backgroundColor = colorWithYGWhite;
    [self.contentView addSubview:_baseView];
    
    
    _payStatsLabel  = [[UILabel alloc] init];
    _payStatsLabel.textColor = colorWithPlaceholder;
    _payStatsLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _payStatsLabel.text = @"已逾期";
    _payStatsLabel.textAlignment = NSTextAlignmentRight;
    _payStatsLabel.frame = CGRectMake(YGScreenWidth-120, 0, 110, 20);
    [_baseView addSubview:_payStatsLabel];
    
    _statsLabel  = [[UILabel alloc] init];
    _statsLabel.textColor = colorWithPlaceholder;
    _statsLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    _statsLabel.text = @"逾期： 90天";
    _statsLabel.textAlignment = NSTextAlignmentRight;
    _statsLabel.frame = CGRectMake(_payStatsLabel.x, _payStatsLabel.y+_payStatsLabel.height+5, _payStatsLabel.width, 20);
    [_baseView addSubview:_statsLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _statsLabel.y+_statsLabel.height+10, YGScreenWidth, 1)];
    lineView.backgroundColor = colorWithTable;
    [_baseView addSubview:lineView];
    
    
    UILabel *rentTitle  = [[UILabel alloc] init];
    rentTitle.textColor = colorWithDeepGray;
    rentTitle.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
    rentTitle.text = @"租金(含物业管理费)";
    rentTitle.frame = CGRectMake(10, lineView.y+10, YGScreenWidth*0.5, 20);
    [_baseView addSubview:rentTitle];
    
    _rentMoney  = [[UILabel alloc] init];
    _rentMoney.textColor = colorWithPlaceholder;
    _rentMoney.font = [UIFont systemFontOfSize:YGFontSizeNormal];
    _rentMoney.text = @"54000.00";
    _rentMoney.frame = CGRectMake(YGScreenWidth-130, rentTitle.y, 120, 20);
    _rentMoney.textAlignment = NSTextAlignmentRight;
    [_baseView addSubview:_rentMoney];
    
//    UILabel *propertyMoneyTitle  = [[UILabel alloc] init];
//    propertyMoneyTitle.textColor = colorWithDeepGray;
//    propertyMoneyTitle.font = [UIFont systemFontOfSize:YGFontSizeNormal];
//    propertyMoneyTitle.text = @"租金";
//    propertyMoneyTitle.frame = CGRectMake(10, rentTitle.y+rentTitle.height+5, 100, 20);
//    [_baseView addSubview:propertyMoneyTitle];
//
//    _propertyMoney  = [[UILabel alloc] init];
//    _propertyMoney.textColor = colorWithPlaceholder;
//    _propertyMoney.font = [UIFont systemFontOfSize:YGFontSizeNormal];
//    _propertyMoney.text = @"54000.00";
//    _propertyMoney.textAlignment = NSTextAlignmentRight;
//    _propertyMoney.frame = CGRectMake(YGScreenWidth-120, propertyMoneyTitle.y, 100, 20);
//    _propertyMoney.textAlignment = NSTextAlignmentRight;
//    [_baseView addSubview:_propertyMoney];
    
}

- (void)setModel:(BillDetailModel *)model withType:(NSString *)type;
{
    _model = model;
    _payStatsLabel.text = @"已逾期";

    if ([type isEqualToString:@"waitToPay"]) {
        _payStatsLabel.text = @"未缴纳";

    }
    
    if ([_model.time isEqualToString:@""]) {
        _statsLabel.text = @"逾期: 0天";
        
    }else
    {
        _statsLabel.text = [NSString stringWithFormat:@"逾期: %@天",_model.time];
        
    }
    _statsLabel.attributedText =   [_statsLabel.text attributedStringFromNSString:_statsLabel.text startLocation:3 forwardFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] backFont:[UIFont systemFontOfSize:YGFontSizeSmallOne] forwardColor:colorWithPlaceholder backColor:colorWithOrangeColor];
    
    _rentMoney.text = [NSString stringWithFormat:@"%.2f",[_model.price floatValue]];
}
@end
