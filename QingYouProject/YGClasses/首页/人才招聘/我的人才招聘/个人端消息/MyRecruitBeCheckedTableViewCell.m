//
//  MyRecruitBeCheckedTableViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/11/16.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "MyRecruitBeCheckedTableViewCell.h"

@implementation MyRecruitBeCheckedTableViewCell
{
    UILabel *_titleLabel; //标题
    UILabel *_money; //月薪
        UILabel *_jobNameLabel; //职位
    UILabel *_deliverStateLabel; //投递状态
    UILabel *_dateLabel;

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
        self.contentView.backgroundColor = colorWithTable;
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 100)];
        baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:baseView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 25)];
        _titleLabel.text = @"诚聘业务员、业务经理";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.textColor = colorWithBlack;
        [baseView addSubview:_titleLabel];
        
        _deliverStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(YGScreenWidth-100,_titleLabel.y , 90, 25)];
        _deliverStateLabel.text = @"被查看";
        _deliverStateLabel.textAlignment = NSTextAlignmentLeft;
        _deliverStateLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _deliverStateLabel.textColor = colorWithMainColor;
        [_deliverStateLabel sizeToFit];
        _deliverStateLabel.frame = CGRectMake(YGScreenWidth-_deliverStateLabel.width-10,_deliverStateLabel.y , _deliverStateLabel.width, 25);
        [baseView addSubview:_deliverStateLabel];
        
        
        _money = [[UILabel alloc] initWithFrame:CGRectMake(10,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth/2, 25)];
        _money.text = @"3000-5000元/月";
        _money.textAlignment = NSTextAlignmentLeft;
        _money.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _money.textColor = colorWithOrangeColor;
        [_money sizeToFit];
        _money.frame = CGRectMake(10,_money.y , _money.width, 25);
        [baseView addSubview:_money];
        
        _jobNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_money.x+_money.width+10,_money.y , 100, 25)];
        _jobNameLabel.text = @"业务员";
        _jobNameLabel.textAlignment = NSTextAlignmentLeft;
        _jobNameLabel.font = [UIFont systemFontOfSize:YGFontSizeSmallOne];
        _jobNameLabel.textColor = colorWithDeepGray;
        [_jobNameLabel sizeToFit];
        _jobNameLabel.frame = CGRectMake(_jobNameLabel.x,_money.y , _jobNameLabel.width, 25);
        [baseView addSubview:_jobNameLabel];
        
        UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_money.y+_money.height+5, 75, 25)];
        dateTitleLabel.text = @"投递时间:";
        dateTitleLabel.textAlignment = NSTextAlignmentLeft;
        dateTitleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        dateTitleLabel.textColor = colorWithDeepGray;
        [self.contentView addSubview:dateTitleLabel];
        
        
        //热门推荐label
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textColor = colorWithBlack;
        _dateLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _dateLabel.text = @"2017-10-09 下午15：00";
        _dateLabel.frame = CGRectMake(dateTitleLabel.x+dateTitleLabel.width, dateTitleLabel.y,YGScreenWidth-dateTitleLabel.width-30, 25);
        [self.contentView addSubview:_dateLabel];
    
    
    }
    return self;
}

- (void)setModel:(AdvertiseModel *)model
{
    _model = model;
    _titleLabel.text = _model.name == nil?_model.job:_model.name;
    _dateLabel.text = _model.time;

    _money.text = [NSString stringWithFormat:@"%@/月",_model.price == nil?_model.salary:_model.price];
    if ((_model.price != nil && [_model.price isEqualToString:@"面议"]) || (_model.salary != nil && [_model.salary isEqualToString:@"面议"]) || (_model.price != nil && [_model.price isEqualToString:@"不限"]) || (_model.salary != nil && [_model.salary isEqualToString:@"不限"])) {
        _money.text = [NSString stringWithFormat:@"%@",_model.price == nil?_model.salary:_model.price];
    }
    [_money sizeToFit];
    _money.frame = CGRectMake(10,_money.y , _money.width, 25);
    
    _jobNameLabel.frame = CGRectMake(_money.x+_money.width+10,_money.y , _jobNameLabel.width, 25);
}


@end
