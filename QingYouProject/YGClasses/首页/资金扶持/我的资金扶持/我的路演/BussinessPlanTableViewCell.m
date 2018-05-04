//
//  BussinessPlanTableViewCell.m
//  QingYouProject
//
//  Created by nefertari on 2017/11/15.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "BussinessPlanTableViewCell.h"

@implementation BussinessPlanTableViewCell
{
    UILabel *_titleLabel; //标题
    UILabel *_money; //月薪
    UILabel *_jobNameContentLabel; //职位
    UIView *_treatmentBaseView; //待遇
    UIButton *_deliverCurriculumButton; //投递简历按钮
    UIButton *_deleteCurriculumButton; //删除简历按钮
    UILabel *_deliverStateLabel; //投递状态
    UIView *_baseView;
    
    UILabel *_waitToCheckLabel; //待审核

    UILabel *_moneyLabel;
    UILabel *_jobNameLabel;
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
    
        
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YGScreenWidth, 90)];
        _baseView.backgroundColor = colorWithYGWhite;
        [self.contentView addSubview:_baseView];
        
       UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , 50, 20)];
        nameLabel.text = @"姓名：";
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        nameLabel.textColor = colorWithDeepGray;
        [nameLabel sizeToFit];
        nameLabel.frame = CGRectMake(10,10 , nameLabel.width, 20);
        [_baseView addSubview:nameLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x+nameLabel.width,nameLabel.y , YGScreenWidth-20-nameLabel.width, 20)];
        _titleLabel.text = @"王者荣耀   男   24岁   本科";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _titleLabel.textColor = colorWithBlack;
        [_baseView addSubview:_titleLabel];
        
        UILabel *deliverLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_titleLabel.y+_titleLabel.height+5 , nameLabel.width, 20)];
        deliverLabel.text = @"电话：";
        deliverLabel.textAlignment = NSTextAlignmentLeft;
        deliverLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        deliverLabel.textColor = colorWithDeepGray;
        [_baseView addSubview:deliverLabel];
        
        _deliverStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(deliverLabel.x+deliverLabel.width,deliverLabel.y, _titleLabel.width, 20)];
        _deliverStateLabel.text = @"产品经理   工作经验1~2年";
        _deliverStateLabel.textAlignment = NSTextAlignmentLeft;
        _deliverStateLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _deliverStateLabel.textColor = colorWithBlack;
        [_deliverStateLabel sizeToFit];
        _deliverStateLabel.frame = CGRectMake(_deliverStateLabel.x,_deliverStateLabel.y , _deliverStateLabel.width, 20);
        [_baseView addSubview:_deliverStateLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_deliverStateLabel.y+_deliverStateLabel.height+5 , nameLabel.width, 20)];
        _moneyLabel.text = @"地址：";
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        _moneyLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _moneyLabel.textColor = colorWithDeepGray;
        [_baseView addSubview:_moneyLabel];
        
        _money = [[UILabel alloc] initWithFrame:CGRectMake(_moneyLabel.x+_moneyLabel.width,_moneyLabel.y , _titleLabel.width, 20)];
        _money.text = @"期望薪资3000-5000";
        _money.textAlignment = NSTextAlignmentLeft;
        _money.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _money.textColor = colorWithBlack;
        _money.numberOfLines = 0;
        [_baseView addSubview:_money];
        
        _jobNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,_money.y+_money.height+5 , nameLabel.width, 20)];
        _jobNameLabel.text = @"企业/个人名称：";
        _jobNameLabel.textAlignment = NSTextAlignmentLeft;
        _jobNameLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _jobNameLabel.textColor = colorWithDeepGray;
        [_jobNameLabel sizeToFit];
        _jobNameLabel.frame = CGRectMake(_jobNameLabel.x,_jobNameLabel.y , _jobNameLabel.width, 20);
        [_baseView addSubview:_jobNameLabel];
        
        _jobNameContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_jobNameLabel.x+_jobNameLabel.width,_money.y+_money.height+5, YGScreenWidth-20-_jobNameLabel.width, 20)];
        _jobNameContentLabel.text = @"元/月";
        _jobNameContentLabel.textAlignment = NSTextAlignmentLeft;
        _jobNameContentLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _jobNameContentLabel.textColor = colorWithBlack;
        _jobNameContentLabel.numberOfLines = 0;
        [_baseView addSubview:_jobNameContentLabel];
  
        
        _waitToCheckLabel = [[UILabel alloc] initWithFrame:CGRectMake(YGScreenWidth-100,nameLabel.y ,80,30)];
        _waitToCheckLabel.text = @"待审核";
        _waitToCheckLabel.textAlignment = NSTextAlignmentCenter;
        _waitToCheckLabel.font = [UIFont systemFontOfSize:YGFontSizeBigOne];
        _waitToCheckLabel.textColor = colorWithYGWhite;
        _waitToCheckLabel.backgroundColor = colorWithMainColor;
        [_baseView addSubview:_waitToCheckLabel];
//
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, _money.y+_money.height+10, YGScreenWidth-10, 1)];
//        lineView.backgroundColor = colorWithTable;
//        [baseView addSubview:lineView];
        
    }
    return self;
}

- (void)setModel:(BussinessPlanModel *)model
{
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%@",_model.name];
    
    _deliverStateLabel.text = [NSString stringWithFormat:@"%@",_model.contactPhone];
    
    _money.text = [NSString stringWithFormat:@"%@",_model.address];
    [_money sizeToFit];
    _money.frame = CGRectMake(_money.x,_deliverStateLabel.y+_deliverStateLabel.height+5 , _money.width, _money.height+5);

    _jobNameLabel.frame = CGRectMake(_jobNameLabel.x,_money.y+_money.height+5 , _jobNameLabel.width, 20);

    _jobNameContentLabel.text = [NSString stringWithFormat:@"%@",_model.firmName];
    [_jobNameContentLabel sizeToFit];
    _jobNameContentLabel.frame = CGRectMake(_jobNameContentLabel.x,_jobNameLabel.y , _jobNameContentLabel.width, _jobNameContentLabel.height);
    _baseView.frame = CGRectMake(0, 0, YGScreenWidth, _jobNameContentLabel.y+_jobNameContentLabel.height+10);
    
    NSArray *arr = @[@"",@"待审核",@"已完成"];
    NSArray *arrColor = @[colorWithMainColor,colorWithMainColor,colorWithPlaceholder];
    _waitToCheckLabel.text = arr[[_model.audit intValue]];
    _waitToCheckLabel.backgroundColor = arrColor[[_model.audit intValue]];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(YGScreenWidth, _baseView.height);
}
@end
