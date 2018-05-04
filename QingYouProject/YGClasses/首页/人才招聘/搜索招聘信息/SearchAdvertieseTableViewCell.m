//
//  SearchAdvertieseTableViewCell.m
//  QingYouProject
//
//  Created by 王丹 on 2017/10/24.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "SearchAdvertieseTableViewCell.h"

@implementation SearchAdvertieseTableViewCell
{
    UILabel *_titleLabel; //标题
    UILabel *_money; //月薪
    UILabel *_jobNameLabel; //职位
    UIView *_treatmentBaseView; //待遇
    UIButton *_deliverCurriculumButton; //投递简历按钮
    UIButton *_deleteCurriculumButton; //删除简历按钮
    UILabel *_deliverStateLabel; //投递状态
    
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
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        arrowImageView.frame = CGRectMake(0, 0, 17, 17);
        arrowImageView.image = [UIImage imageNamed:@"unfold_btn_gray"];
        [arrowImageView sizeToFit];
        self.accessoryView = arrowImageView;

        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 90)];
        baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:baseView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , YGScreenWidth-20, 20)];
        _titleLabel.text = @"王者荣耀   男   24岁   本科";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _titleLabel.textColor = colorWithBlack;
        [baseView addSubview:_titleLabel];
        
        _deliverStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_titleLabel.y+_titleLabel.height+5 , YGScreenWidth-20, 20)];
        _deliverStateLabel.text = @"产品经理   工作经验1~2年";
        _deliverStateLabel.textAlignment = NSTextAlignmentLeft;
        _deliverStateLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _deliverStateLabel.textColor = colorWithBlack;
        [_deliverStateLabel sizeToFit];
        _deliverStateLabel.frame = CGRectMake(_deliverStateLabel.x,_deliverStateLabel.y , _deliverStateLabel.width, 20);
        [baseView addSubview:_deliverStateLabel];
        
        
        _money = [[UILabel alloc] initWithFrame:CGRectMake(10,_deliverStateLabel.y+_deliverStateLabel.height+5 , YGScreenWidth-20, 20)];
        _money.text = @"期望薪资3000-5000";
        _money.textAlignment = NSTextAlignmentLeft;
        _money.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _money.textColor = colorWithDeepGray;
        [baseView addSubview:_money];
        
        _jobNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_deliverStateLabel.x+_deliverStateLabel.width+10,_deliverStateLabel.y , 100, 20)];
        _jobNameLabel.text = @"元/月";
        _jobNameLabel.textAlignment = NSTextAlignmentLeft;
        _jobNameLabel.font = [UIFont systemFontOfSize:YGFontSizeNormal];
        _jobNameLabel.textColor = colorWithBlack;
        [baseView addSubview:_jobNameLabel];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _money.y+_money.height+10, YGScreenWidth-10, 1)];
        lineView.backgroundColor = colorWithTable;
        [baseView addSubview:lineView];
        
    }
    return self;
}

- (void)setModel:(AdvertiseModel *)model
{
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%@   %@    %@    %@",_model.name,([_model.sex isEqualToString:@"0"]?@"女":@"男"),_model.birthday,_model.educational];

    _deliverStateLabel.text = _model.job;
    
//    _money.text = _model.price;
    [_deliverStateLabel sizeToFit];
    _deliverStateLabel.frame = CGRectMake(_deliverStateLabel.x,_deliverStateLabel.y , _deliverStateLabel.width, 20);
    _jobNameLabel.text = [NSString stringWithFormat:@"工作经验%@",_model.experience];
    [_jobNameLabel sizeToFit];
    _jobNameLabel.frame = CGRectMake(_deliverStateLabel.x+_deliverStateLabel.width+10,_jobNameLabel.y , _jobNameLabel.width, 20);
    
    if ([_model.salary isEqualToString:@"面议"] || [_model.salary isEqualToString:@"不限"]) {
        _money.text = _model.salary;
        _money.textColor = colorWithOrangeColor;

    }else
    {
        [_money addAttributedWithString:[NSString stringWithFormat:@"期望工资%@/月",_model.salary] range:NSMakeRange(@"期望工资".length, [NSString stringWithFormat:@"%@",_model.salary].length) color:colorWithOrangeColor];

    }
    
    
}

- (void)deliverCurriculumButtonAction:(UIButton *)btn
{
    
}

- (void)deleteCurriculumButtonAction:(UIButton *)btn
{
    
}
@end
